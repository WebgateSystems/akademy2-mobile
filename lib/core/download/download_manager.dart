import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../db/entities/content_entity.dart';
import '../db/isar_service.dart';
import '../network/api.dart';
import '../network/dio_provider.dart';

enum DownloadAssetType { file, poster, subtitles }

enum ModuleDownloadStatus { idle, inProgress, completed, error }

class ModuleDownloadState {
  const ModuleDownloadState._({
    required this.status,
    this.progress = 0,
    this.errorMessage,
  });

  const ModuleDownloadState.idle() : this._(status: ModuleDownloadStatus.idle);

  ModuleDownloadState.inProgress(double progress)
      : this._(
          status: ModuleDownloadStatus.inProgress,
          progress: progress.clamp(0, 1).toDouble(),
        );

  const ModuleDownloadState.completed()
      : this._(
          status: ModuleDownloadStatus.completed,
          progress: 1,
        );

  ModuleDownloadState.error(
    String message, {
    double progress = 0,
  })
      : this._(
          status: ModuleDownloadStatus.error,
          progress: progress,
          errorMessage: message,
        );

  final ModuleDownloadStatus status;
  final double progress;
  final String? errorMessage;

  bool get isCompleted => status == ModuleDownloadStatus.completed;
  bool get isInProgress => status == ModuleDownloadStatus.inProgress;
}

final moduleDownloadProvider = StateNotifierProvider<ModuleDownloadNotifier,
    Map<String, ModuleDownloadState>>(
  (ref) => ModuleDownloadNotifier(ref),
);

class ModuleDownloadNotifier
    extends StateNotifier<Map<String, ModuleDownloadState>> {
  ModuleDownloadNotifier(this.ref) : super({});

  final Ref ref;
  final _activeDownloads = <String, Future<void>>{};

  Future<void> startModuleDownload({
    required String moduleId,
    required List<ContentEntity> contents,
  }) async {
    if (_activeDownloads.containsKey(moduleId)) return;

    final downloadable = contents.where(_requiresDownload).toList();
    if (downloadable.isEmpty) {
      _setState(moduleId, const ModuleDownloadState.completed());
      return;
    }

    final future = _downloadModule(moduleId, downloadable);
    _activeDownloads[moduleId] = future;
    try {
      await future;
    } finally {
      _activeDownloads.remove(moduleId);
    }
  }

  Future<void> _downloadModule(
    String moduleId,
    List<ContentEntity> contents,
  ) async {
    try {
      final dio = ref.read(dioProvider);
      final plans = await _buildContentPlans(moduleId, contents);

      if (plans.isEmpty) {
        _setState(moduleId, const ModuleDownloadState.completed());
        return;
      }

      final totalItems =
          plans.fold<int>(0, (sum, plan) => sum + plan.items.length);
      if (totalItems == 0) {
        _setState(moduleId, const ModuleDownloadState.completed());
        return;
      }

      _setState(moduleId, ModuleDownloadState.inProgress(0));

      var completedItems = 0;
      void report(double current) {
        final progress = ((completedItems + current) / totalItems)
            .clamp(0.0, 1.0)
            .toDouble();
        _setState(moduleId, ModuleDownloadState.inProgress(progress));
      }

      for (final plan in plans) {
        if (plan.items.isEmpty) {
          await _markDownloaded(plan);
          continue;
        }

        for (final item in plan.items) {
          report(0.0);
          await _downloadItem(dio, item, (value) => report(value));
          completedItems++;
          report(0.0);
        }

        await _writeMetadata(plan.dir, plan.signature, plan.items);
        await _markDownloaded(plan);
      }

      _setState(moduleId, const ModuleDownloadState.completed());
    } catch (e, st) {
      debugPrint('ModuleDownloadManager: failed to download module=$moduleId $e\n$st');
      _setState(
        moduleId,
        ModuleDownloadState.error(
          e.toString(),
          progress: state[moduleId]?.progress ?? 0.0,
        ),
      );
    }
  }

  void _setState(String moduleId, ModuleDownloadState newState) {
    state = {
      ...state,
      moduleId: newState,
    };
  }

  Future<void> _markDownloaded(_ContentPlan plan) async {
    final isar = IsarService();
    await isar.updateContentDownload(
      plan.content.id,
      downloaded: true,
      downloadPath: plan.dir.path,
    );
  }
}

Future<bool> isContentDownloadFresh(ContentEntity content) async {
  if (!content.downloaded || content.downloadPath.isEmpty) return false;
  final dir = Directory(content.downloadPath);
  if (!dir.existsSync()) return false;

  final metadata = await _readMetadata(dir);
  final signature = contentSignature(content);
  final items = _buildDownloadItems(content, dir.path);

  if (items.isEmpty) return false;

  return _isContentUpToDate(
    dir: dir,
    metadata: metadata,
    signature: signature,
    expectedFiles: items.map((item) => item.savePath).toList(),
  );
}

String contentSignature(ContentEntity content) {
  return '${content.fileUrl ?? ''}|${content.posterUrl ?? ''}|${content.subtitlesUrl ?? ''}|${content.fileHash ?? ''}|${content.fileFormat ?? ''}';
}

String? contentLocalPath(
  ContentEntity content,
  DownloadAssetType type, {
  bool ensureExists = false,
}) {
  if (content.downloadPath.isEmpty) return null;
  final base = Directory(content.downloadPath);
  if (!base.existsSync()) return null;

  String? url;
  String fallback = 'bin';
  final prefix = _filePrefix(type);
  switch (type) {
    case DownloadAssetType.file:
      url = content.fileUrl;
      fallback = content.fileFormat ?? 'bin';
      break;
    case DownloadAssetType.poster:
      url = content.posterUrl ?? content.fileUrl;
      fallback = 'jpg';
      break;
    case DownloadAssetType.subtitles:
      url = content.subtitlesUrl;
      fallback = 'vtt';
      break;
  }

  if (url == null || url.isEmpty) {
    final file = _firstFileWithPrefix(base, prefix);
    if (file == null) return null;
    return ensureExists && !file.existsSync() ? null : file.path;
  }

  final fileName = _localFileName(type, url, fallbackExtension: fallback);
  final fullPath = '${base.path}/$fileName';
  if (ensureExists && !File(fullPath).existsSync()) return null;
  return fullPath;
}

List<_DownloadItem> _buildDownloadItems(
  ContentEntity content,
  String basePath,
) {
  final items = <_DownloadItem>[];
  final seen = <String>{};

  void addItem(DownloadAssetType type, String? rawUrl, String fallbackExt) {
    final url = _absUrl(rawUrl);
    if (url == null || url.isEmpty) return;
    if (!seen.add(url)) return;

    final fileName = _localFileName(type, url, fallbackExtension: fallbackExt);
    items.add(
      _DownloadItem(
        url: url,
        savePath: '$basePath/$fileName',
      ),
    );
  }

  addItem(DownloadAssetType.file, content.fileUrl, content.fileFormat ?? 'bin');
  addItem(DownloadAssetType.poster, content.posterUrl, 'jpg');
  addItem(DownloadAssetType.subtitles, content.subtitlesUrl, 'vtt');

  return items;
}

Future<List<_ContentPlan>> _buildContentPlans(
  String moduleId,
  List<ContentEntity> contents,
) async {
  final docsDir = await getApplicationDocumentsDirectory();
  final moduleDir = Directory('${docsDir.path}/downloads/modules/$moduleId');
  if (!moduleDir.existsSync()) {
    await moduleDir.create(recursive: true);
  }

  final isar = IsarService();
  final plans = <_ContentPlan>[];

  for (final content in contents) {
    final contentDir = Directory('${moduleDir.path}/${content.id}');
    final items = _buildDownloadItems(content, contentDir.path);
    if (items.isEmpty) continue;

    final signature = contentSignature(content);
    final metadata = await _readMetadata(contentDir);

    final upToDate = await _isContentUpToDate(
      dir: contentDir,
      metadata: metadata,
      signature: signature,
      expectedFiles: items.map((item) => item.savePath).toList(),
    );

    if (upToDate) {
      if (!content.downloaded || content.downloadPath != contentDir.path) {
        await isar.updateContentDownload(
          content.id,
          downloaded: true,
          downloadPath: contentDir.path,
        );
      }
      continue;
    }

    if (contentDir.existsSync()) {
      await contentDir.delete(recursive: true);
    }
    await contentDir.create(recursive: true);
    await isar.updateContentDownload(
      content.id,
      downloaded: false,
      downloadPath: '',
    );

    plans.add(
      _ContentPlan(
        content: content,
        dir: contentDir,
        items: items,
        signature: signature,
      ),
    );
  }

  return plans;
}

Future<void> _downloadItem(
  Dio dio,
  _DownloadItem item,
  void Function(double progress) onProgress,
) async {
  final file = File(item.savePath);
  if (file.existsSync()) {
    await file.delete();
  }

  await dio.download(
    item.url,
    item.savePath,
    onReceiveProgress: (received, total) {
      if (total <= 0) {
        onProgress(0.0);
        return;
      }
      onProgress((received / total).clamp(0, 1).toDouble());
    },
  );
}

Future<_ContentMetadata?> _readMetadata(Directory dir) async {
  final file = File('${dir.path}/meta.json');
  if (!await file.exists()) return null;
  try {
    final raw = await file.readAsString();
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final files = (data['files'] as List?)?.cast<String>() ?? <String>[];
    return _ContentMetadata(
      signature: data['signature'] as String? ?? '',
      files: files,
    );
  } catch (_) {
    return null;
  }
}

Future<void> _writeMetadata(
  Directory dir,
  String signature,
  List<_DownloadItem> items,
) async {
  final file = File('${dir.path}/meta.json');
  final payload = {
    'signature': signature,
    'files':
        items.map((i) => i.savePath.split(Platform.pathSeparator).last).toList(),
  };
  await file.writeAsString(jsonEncode(payload));
}

Future<bool> _isContentUpToDate({
  required Directory dir,
  required _ContentMetadata? metadata,
  required String signature,
  required List<String> expectedFiles,
}) async {
  if (!dir.existsSync()) return false;
  if (metadata == null || metadata.signature != signature) return false;
  if (expectedFiles.isEmpty) return false;

  for (final path in expectedFiles) {
    if (!File(path).existsSync()) {
      return false;
    }
  }
  return true;
}

bool _requiresDownload(ContentEntity content) {
  if (content.type == 'quiz') return false;
  return (content.fileUrl?.isNotEmpty ?? false) ||
      (content.posterUrl?.isNotEmpty ?? false) ||
      (content.subtitlesUrl?.isNotEmpty ?? false);
}

String _localFileName(
  DownloadAssetType type,
  String url, {
  required String fallbackExtension,
}) {
  final prefix = _filePrefix(type);
  final parsed = Uri.tryParse(url);
  final raw =
      parsed?.pathSegments.isNotEmpty == true ? parsed!.pathSegments.last : '';
  final cleaned = raw
      .split('?')
      .first
      .replaceAll(RegExp(r'[^a-zA-Z0-9_.-]'), '_')
      .replaceAll(RegExp(r'_+'), '_');
  final baseName = cleaned.isEmpty ? prefix : cleaned;
  final hasExt = baseName.contains('.');
  final nameWithPrefix =
      baseName.startsWith(prefix) ? baseName : '${prefix}_$baseName';
  if (hasExt) return nameWithPrefix;
  return '$nameWithPrefix.$fallbackExtension';
}

String _filePrefix(DownloadAssetType type) {
  return switch (type) {
    DownloadAssetType.file => 'file',
    DownloadAssetType.poster => 'poster',
    DownloadAssetType.subtitles => 'subtitles',
  };
}

File? _firstFileWithPrefix(Directory dir, String prefix) {
  if (!dir.existsSync()) return null;
  final files = dir
      .listSync()
      .whereType<File>()
      .where((f) {
        final name = f.path.split(Platform.pathSeparator).last;
        return name.startsWith(prefix);
      })
      .toList();
  if (files.isEmpty) return null;
  files.sort(
    (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
  );
  return files.first;
}

Future<void> clearAllDownloads() async {
  try {
    final docsDir = await getApplicationDocumentsDirectory();
    final downloadsDir = Directory('${docsDir.path}/downloads');
    if (await downloadsDir.exists()) {
      await downloadsDir.delete(recursive: true);
    }
  } catch (e, st) {
    debugPrint('ModuleDownloadManager: failed to clear downloads - $e\n$st');
  }
}

String? _absUrl(String? path) {
  if (path == null || path.isEmpty) return null;
  if (path.startsWith('http')) return path;
  final base = Api.baseUploadUrl.endsWith('/')
      ? Api.baseUploadUrl.substring(0, Api.baseUploadUrl.length - 1)
      : Api.baseUploadUrl;
  return path.startsWith('/') ? '$base$path' : '$base/$path';
}

class _ContentPlan {
  _ContentPlan({
    required this.content,
    required this.dir,
    required this.items,
    required this.signature,
  });

  final ContentEntity content;
  final Directory dir;
  final List<_DownloadItem> items;
  final String signature;
}

class _DownloadItem {
  _DownloadItem({
    required this.url,
    required this.savePath,
  });

  final String url;
  final String savePath;
}

class _ContentMetadata {
  _ContentMetadata({
    required this.signature,
    required this.files,
  });

  final String signature;
  final List<String> files;
}
