import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/base_page_with_toolbar.dart';
import 'package:academy_2_app/app/view/circular_progress_widget.dart';
import 'package:academy_2_app/core/download/download_manager.dart';
import 'package:academy_2_app/core/network/api.dart';
import 'package:academy_2_app/features/modules/cards/default_content_card.dart';
import 'package:academy_2_app/features/modules/cards/infographic_content_card.dart';
import 'package:academy_2_app/features/modules/cards/preview_image_body.dart';
import 'package:academy_2_app/features/modules/cards/video_content_card.dart';
import 'package:academy_2_app/features/modules/dialogs/network_video_preview_dialog.dart';
import 'package:academy_2_app/features/modules/dialogs/pdf_preview_dialog.dart';
import 'package:academy_2_app/features/modules/dialogs/youtube_preview_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../core/db/entities/content_entity.dart';
import '../../core/db/entities/module_entity.dart';
import '../../core/db/isar_service.dart';
import '../../core/sync/sync_manager.dart';
import '../../l10n/app_localizations.dart';

class _ModuleData {
  const _ModuleData({required this.module, required this.contents});

  final ModuleEntity module;
  final List<ContentEntity> contents;
}

final moduleDataProvider = FutureProvider.autoDispose
    .family<_ModuleData, String>((ref, moduleId) async {
  final service = IsarService();
  final syncManager = ref.read(syncManagerProvider);
  var bootstrapped = false;

  Future<void> ensureBootstrap() async {
    if (bootstrapped) return;
    bootstrapped = true;
    await syncManager.bootstrap();
  }

  var module = await service.getModuleById(moduleId);
  if (module == null) {
    await ensureBootstrap();
    module = await service.getModuleById(moduleId);
  }

  if (module == null) throw Exception('Module $moduleId not found');

  var contents = await service.getContentsByModuleId(moduleId);
  if (contents.isEmpty || _needsPreviewRefresh(contents)) {
    await ensureBootstrap();
    contents = await service.getContentsByModuleId(moduleId);
    module = await service.getModuleById(moduleId) ?? module;
  }

  contents = await _validateDownloadedContent(contents);

  return _ModuleData(module: module, contents: contents);
});

bool _needsPreviewRefresh(List<ContentEntity> items) {
  return items.any((c) {
    final hasYoutube = c.youtubeUrl?.isNotEmpty ?? false;
    final hasPoster = c.posterUrl?.isNotEmpty ?? false;
    final hasFile = c.fileUrl?.isNotEmpty ?? false;

    switch (c.type) {
      case 'video':
        return !(hasYoutube || hasPoster || hasFile);
      case 'infographic':
        return !(hasPoster || hasFile);
      default:
        return false;
    }
  });
}

Future<List<ContentEntity>> _validateDownloadedContent(
  List<ContentEntity> items,
) async {
  if (items.isEmpty) return items;
  final service = IsarService();

  for (final content in items) {
    if (!content.downloaded || content.downloadPath.isEmpty) continue;
    final isFresh = await isContentDownloadFresh(content);
    if (!isFresh) {
      await service.updateContentDownload(
        content.id,
        downloaded: false,
        downloadPath: '',
      );
      content
        ..downloaded = false
        ..downloadPath = '';
    }
  }

  return items;
}

class ModulePage extends ConsumerStatefulWidget {
  const ModulePage({super.key, required this.moduleId});

  final String moduleId;

  @override
  ConsumerState<ModulePage> createState() => _ModulePageState();
}

class _ModulePageState extends ConsumerState<ModulePage> {
  late final ProviderSubscription<Map<String, ModuleDownloadState>>
      _downloadSub;

  @override
  void initState() {
    super.initState();
    _downloadSub = ref.listenManual<Map<String, ModuleDownloadState>>(
      moduleDownloadProvider,
      (previous, next) {
        final prevStatus = previous?[widget.moduleId]?.status;
        final status = next[widget.moduleId]?.status;
        if (status == ModuleDownloadStatus.completed &&
            prevStatus != ModuleDownloadStatus.completed) {
          ref.invalidate(moduleDataProvider(widget.moduleId));
        }
      },
    );
  }

  @override
  void dispose() {
    _downloadSub.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final downloadMap = ref.watch(moduleDownloadProvider);
    final moduleAsync = ref.watch(moduleDataProvider(widget.moduleId));

    return moduleAsync.when(
      loading: () => _buildScaffold(
        context,
        const Center(child: CircularProgressWidget()),
      ),
      error: (error, _) => _buildScaffold(
        context,
        Center(child: Text('${l10n.retry}: $error')),
      ),
      data: (data) {
        final module = data.module;
        final contents = data.contents;
        final title =
            module.title.isEmpty ? l10n.moduleScreenTitle : module.title;

        if (contents.isEmpty) {
          return _buildScaffold(
            context,
            Center(child: Text(l10n.noContent)),
          );
        }

        final downloadState = downloadMap[module.id];

        return _buildScaffold(
          context,
          BasePageWithToolbar(
            title: title,
            rightIcon: _buildDownloadAction(
              context: context,
              module: module,
              contents: contents,
              state: downloadState,
            ),
            stickChildrenToBottom: true,
            isOneToolbarRow: true,
            paddingBottom: 20.w,
            children: [
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.separated(
                  itemCount: contents.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    final content = contents[index];
                    return _buildContentCard(
                      context: context,
                      l10n: l10n,
                      moduleId: module.id,
                      content: content,
                      onVideoPreview: () => _showVideoPreview(context, content),
                      onInfographicPreview: () =>
                          _showInfographicPreview(context, content),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDownloadAction({
    required BuildContext context,
    required ModuleEntity module,
    required List<ContentEntity> contents,
    ModuleDownloadState? state,
  }) {
    final hasDownloadable = contents.any(_isDownloadableContent);
    final moduleDownloaded = _isModuleDownloaded(contents);

    if (state?.status == ModuleDownloadStatus.inProgress) {
      final percent = ((state?.progress ?? 0) * 100).clamp(0, 100).round();
      return Padding(
        padding: EdgeInsets.only(right: 2.w),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressWidget(
              value: state!.progress,
            ),
            Text(
              '$percent%',
              style: AppTextStyles.h5(context).copyWith(
                color: AppColors.contentAccent(context),
              ),
            ),
          ],
        ),
      );
    }

    if (!hasDownloadable) {
      return IconButton(
        icon: Image.asset(
          'assets/images/ic_download.png',
          width: 24.w,
          height: 24.w,
          color: AppColors.contentSecondary(context),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Немає файлів для офлайн. Перевірте що API повертає file_url/poster_url.',
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        },
      );
    }

    if (moduleDownloaded || state?.status == ModuleDownloadStatus.completed) {
      return Image.asset(
        'assets/images/ic_download_done.png',
        width: 24.w,
        height: 24.w,
        color: AppColors.contentAccent(context),
      );
    }

    final hasError = state?.status == ModuleDownloadStatus.error;

    return IconButton(
      icon: Image.asset(
        'assets/images/ic_download.png',
        width: 24.w,
        height: 24.w,
        color: hasError
            ? AppColors.contentError(context)
            : AppColors.contentSecondary(context),
      ),
      onPressed: () => _onDownloadTap(module.id, contents),
    );
  }

  void _onDownloadTap(String moduleId, List<ContentEntity> contents) {
    if (!contents.any(_isDownloadableContent)) {
      return;
    }
    final state = ref.read(moduleDownloadProvider)[moduleId];
    if (state?.status == ModuleDownloadStatus.inProgress) return;
    ref.read(moduleDownloadProvider.notifier).startModuleDownload(
          moduleId: moduleId,
          contents: contents,
        );
  }

  bool _isModuleDownloaded(List<ContentEntity> contents) {
    final downloadable = contents.where(_isDownloadableContent).toList();
    if (downloadable.isEmpty) return false;
    return downloadable.every(
      (c) => c.downloaded && c.downloadPath.isNotEmpty,
    );
  }

  bool _isDownloadableContent(ContentEntity content) {
    if (content.type == 'quiz') return false;
    final hasFile = content.fileUrl?.isNotEmpty ?? false;
    final hasPoster = content.posterUrl?.isNotEmpty ?? false;
    final hasSubtitles = content.subtitlesUrl?.isNotEmpty ?? false;
    return hasFile || hasPoster || hasSubtitles;
  }

  Widget _buildContentCard({
    required BuildContext context,
    required AppLocalizations l10n,
    required String moduleId,
    required ContentEntity content,
    VoidCallback? onVideoPreview,
    VoidCallback? onInfographicPreview,
  }) {
    final previewUrl = _previewUrl(content);
    switch (content.type) {
      case 'video':
        return VideoContentCard(
          content: content,
          moduleId: moduleId,
          l10n: l10n,
          previewUrl: previewUrl,
          onPreviewTap: onVideoPreview ?? () {},
        );
      case 'infographic':
        return InfographicContentCard(
          content: content,
          moduleId: moduleId,
          l10n: l10n,
          previewUrl: previewUrl,
          onPreviewTap: onInfographicPreview ?? () {},
        );
      case 'quiz':
        return _quizButton(context, l10n, moduleId);
      default:
        return DefaultContentCard(
          content: content,
          moduleId: moduleId,
          l10n: l10n,
          previewUrl: previewUrl,
        );
    }
  }

  Widget _buildScaffold(
    BuildContext context,
    Widget body,
  ) {
    return Scaffold(
      body: body,
    );
  }

  Widget _quizButton(
    BuildContext context,
    AppLocalizations l10n,
    String moduleId,
  ) {
    return ActionButtonWidget(
      text: l10n.quizTitle,
      onPressed: () => context.push('/module/$moduleId/quiz'),
    );
  }

  String? _previewUrl(ContentEntity content) {
    final localPoster = contentLocalPath(
      content,
      DownloadAssetType.poster,
      ensureExists: true,
    );
    final localFile = contentLocalPath(
      content,
      DownloadAssetType.file,
      ensureExists: true,
    );

    switch (content.type) {
      case 'video':
        final url = localPoster ??
            _youtubeThumbnail(content.youtubeUrl) ??
            _absUrl(content.posterUrl) ??
            localFile ??
            _absUrl(content.fileUrl);
        if (url == null) {
          debugPrint(
              'ModulePage: missing preview for video id=${content.id} youtube=${content.youtubeUrl} poster=${content.posterUrl} file=${content.fileUrl}');
        }
        return url;
      case 'infographic':
        final url = localPoster ??
            localFile ??
            _absUrl(content.posterUrl) ??
            _absUrl(content.fileUrl);
        if (url == null) {
          debugPrint(
              'ModulePage: missing preview for infographic id=${content.id} poster=${content.posterUrl} file=${content.fileUrl}');
        }
        return url;
      default:
        final url = localPoster ??
            localFile ??
            _absUrl(content.posterUrl) ??
            _absUrl(content.fileUrl);
        return url;
    }
  }

  String? _youtubeVideoId(String? url) {
    if (url == null || url.isEmpty) return null;
    final uri = Uri.tryParse(url);
    if (uri == null) return null;
    String? videoId;
    if (uri.host.contains('youtu.be')) {
      videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
    } else if (uri.queryParameters['v']?.isNotEmpty ?? false) {
      videoId = uri.queryParameters['v'];
    } else if (uri.pathSegments.length >= 2 &&
        uri.pathSegments.first == 'embed') {
      videoId = uri.pathSegments[1];
    }
    return (videoId == null || videoId.isEmpty) ? null : videoId;
  }

  bool _isPdf(String? url) {
    if (url == null || url.isEmpty) return false;
    return url.toLowerCase().endsWith('.pdf');
  }

  String? _youtubeThumbnail(String? url) {
    final videoId = _youtubeVideoId(url);
    if (videoId == null) return null;
    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }

  String? _absUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    final base = Api.baseUploadUrl.endsWith('/')
        ? Api.baseUploadUrl.substring(0, Api.baseUploadUrl.length - 1)
        : Api.baseUploadUrl;
    return path.startsWith('/') ? '$base$path' : '$base/$path';
  }

  Future<void> _showVideoPreview(
    BuildContext context,
    ContentEntity content,
  ) async {
    // Check if content is downloaded locally
    final localFile = contentLocalPath(
      content,
      DownloadAssetType.file,
      ensureExists: true,
    );
    final hasLocalFile = localFile != null;

    final youtubeUrl = content.youtubeUrl;
    final hasYoutube = youtubeUrl != null && youtubeUrl.isNotEmpty;

    final networkFileUrl = _absUrl(content.fileUrl);
    final hasNetworkFile = networkFileUrl != null;

    // Debug logging
    debugPrint('_showVideoPreview: content.id=${content.id}');
    debugPrint('_showVideoPreview: content.fileUrl=${content.fileUrl}');
    debugPrint('_showVideoPreview: content.youtubeUrl=${content.youtubeUrl}');
    debugPrint(
        '_showVideoPreview: content.downloadPath=${content.downloadPath}');
    debugPrint(
        '_showVideoPreview: localFile=$localFile, hasLocalFile=$hasLocalFile');
    debugPrint(
        '_showVideoPreview: hasYoutube=$hasYoutube, hasNetworkFile=$hasNetworkFile');

    // No video source available
    if (!hasLocalFile && !hasYoutube && !hasNetworkFile) return;

    // Get subtitles URL (local or network)
    final localSubtitles = contentLocalPath(
      content,
      DownloadAssetType.subtitles,
      ensureExists: true,
    );
    final subtitlesUrl = localSubtitles ?? _absUrl(content.subtitlesUrl);

    // Priority:
    // 1. If downloaded locally -> use local file
    // 2. If no local file -> check internet before showing online content

    if (hasLocalFile) {
      // Play from local storage (offline mode or downloaded content)
      await showDialog<void>(
        context: context,
        barrierColor: Colors.black.withOpacity(0.9),
        builder: (_) => NetworkVideoPreviewDialog(
          videoUrl: localFile,
          subtitlesUrl: subtitlesUrl,
        ),
      );
      return;
    }

    // No local file - need internet. Check connectivity first.
    final hasInternet = await _checkInternetConnection();
    if (!hasInternet) {
      if (context.mounted) {
        // Check if video can be downloaded at all
        final canDownload = hasNetworkFile;
        final message = canDownload
            ? 'Відео недоступне офлайн. Завантажте контент для перегляду без інтернету.'
            : 'Це відео доступне тільки онлайн через YouTube і не може бути завантажене.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    if (hasYoutube) {
      // Play from YouTube (online mode, preferred for streaming)
      final videoId = _youtubeVideoId(youtubeUrl);
      if (videoId != null) {
        await showDialog<void>(
          context: context,
          barrierColor: Colors.black.withOpacity(0.9),
          builder: (_) => YoutubePreviewDialog(
            videoId: videoId,
            subtitlesUrl: subtitlesUrl,
          ),
        );
        return;
      }
    }

    if (hasNetworkFile) {
      // Stream from network file URL (fallback if no YouTube)
      await showDialog<void>(
        context: context,
        barrierColor: Colors.black.withOpacity(0.9),
        builder: (_) => NetworkVideoPreviewDialog(
          videoUrl: networkFileUrl,
          subtitlesUrl: subtitlesUrl,
        ),
      );
    }
  }

  /// Simple internet connectivity check
  Future<bool> _checkInternetConnection() async {
    try {
      final response = await http
          .get(
            Uri.parse('https://www.google.com'),
          )
          .timeout(const Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<void> _showInfographicPreview(
    BuildContext context,
    ContentEntity content,
  ) async {
    final localPoster = contentLocalPath(
      content,
      DownloadAssetType.poster,
      ensureExists: true,
    );
    final localFile = contentLocalPath(
      content,
      DownloadAssetType.file,
      ensureExists: true,
    );
    final url = localPoster ??
        localFile ??
        _absUrl(content.posterUrl) ??
        _absUrl(content.fileUrl);

    if (url != null && _isPdf(url)) {
      await showDialog<void>(
        context: context,
        barrierColor: Colors.black.withOpacity(0.9),
        builder: (_) => PdfPreviewDialog(title: content.title, pdfUrl: url),
      );
      return;
    }

    final heroTag = 'content-${content.id}';
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (_) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Hero(
              tag: heroTag,
              child: InteractiveViewer(
                child: PreviewImageBody(
                  imagePath: 'assets/images/placeholder.png',
                  networkUrl: url,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
