import 'dart:io';

import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/base_page_with_toolbar.dart';
import 'package:academy_2_app/app/view/circular_progress_widget.dart';
import 'package:academy_2_app/core/download/download_manager.dart';
import 'package:academy_2_app/core/network/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
        return _VideoContentCard(
          content: content,
          moduleId: moduleId,
          l10n: l10n,
          previewUrl: previewUrl,
          onPreviewTap: onVideoPreview ?? () {},
        );
      case 'infographic':
        return _InfographicContentCard(
          content: content,
          moduleId: moduleId,
          l10n: l10n,
          previewUrl: previewUrl,
          onPreviewTap: onInfographicPreview ?? () {},
        );
      case 'quiz':
        return _quizButton(context, l10n, moduleId);
      default:
        return _DefaultContentCard(
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
    final localFile = contentLocalPath(
      content,
      DownloadAssetType.file,
      ensureExists: true,
    );
    final fileUrl = localFile ?? _absUrl(content.fileUrl);
    final youtubeUrl = content.youtubeUrl;
    if (fileUrl == null && (youtubeUrl == null || youtubeUrl.isEmpty)) return;

    if (fileUrl != null) {
      await showDialog<void>(
        context: context,
        barrierColor: Colors.black.withOpacity(0.9),
        builder: (_) => _NetworkVideoPreviewDialog(videoUrl: fileUrl),
      );
      return;
    }

    if (youtubeUrl != null && youtubeUrl.isNotEmpty) {
      final videoId = _youtubeVideoId(youtubeUrl);
      if (videoId == null) return;
      await showDialog<void>(
        context: context,
        barrierColor: Colors.black.withOpacity(0.9),
        builder: (_) => _YoutubePreviewDialog(videoId: videoId),
      );
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
                child: _PreviewImageBody(
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

class _VideoContentCard extends StatelessWidget {
  const _VideoContentCard({
    required this.content,
    required this.moduleId,
    required this.l10n,
    required this.previewUrl,
    required this.onPreviewTap,
  });

  final ContentEntity content;
  final String moduleId;
  final AppLocalizations l10n;
  final String? previewUrl;
  final VoidCallback onPreviewTap;

  @override
  Widget build(BuildContext context) {
    return _PreviewCard(
      thumbnail: PreviewImage(
        imagePath: 'assets/images/placeholder.png',
        networkUrl: previewUrl,
        heroTag: 'content-${content.id}',
        onTapOverride: onPreviewTap,
      ),
      title: content.title,
      subtitle: l10n.videoTitle,
      onTap: onPreviewTap,
    );
  }
}

class _InfographicContentCard extends StatelessWidget {
  const _InfographicContentCard({
    required this.content,
    required this.moduleId,
    required this.l10n,
    required this.previewUrl,
    required this.onPreviewTap,
  });

  final ContentEntity content;
  final String moduleId;
  final AppLocalizations l10n;
  final String? previewUrl;
  final VoidCallback onPreviewTap;

  @override
  Widget build(BuildContext context) {
    return _PreviewCard(
      thumbnail: PreviewImage(
        imagePath: 'assets/images/placeholder.png',
        networkUrl: previewUrl,
        heroTag: 'content-${content.id}',
        onTapOverride: onPreviewTap,
      ),
      title: content.title,
      subtitle: l10n.infographicTitle,
      onTap: onPreviewTap,
    );
  }
}

class _DefaultContentCard extends StatelessWidget {
  const _DefaultContentCard({
    required this.content,
    required this.moduleId,
    required this.l10n,
    required this.previewUrl,
  });

  final ContentEntity content;
  final String moduleId;
  final AppLocalizations l10n;
  final String? previewUrl;

  @override
  Widget build(BuildContext context) {
    final subtitle = content.type == 'quiz' ? l10n.quizTitle : content.type;
    return _PreviewCard(
      thumbnail: PreviewImage(
        imagePath: 'assets/images/placeholder.png',
        networkUrl: previewUrl,
        heroTag: 'content-${content.id}',
      ),
      title: content.title,
      subtitle: subtitle,
      onTap: () => context.push('/module/$moduleId/${content.type}'),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.thumbnail,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Column(
        children: [
          SizedBox(height: 200.h, width: double.infinity, child: thumbnail),
          SizedBox(height: 8.h),
          ListTile(
            title: Text(
              title,
              style: AppTextStyles.h5(context),
            ),
            subtitle: Text(
              subtitle,
              style: AppTextStyles.b3(context).copyWith(
                color: AppColors.contentSecondary(context),
              ),
            ),
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class PreviewImage extends StatelessWidget {
  const PreviewImage({
    super.key,
    required this.imagePath,
    this.heroTag,
    this.networkUrl,
    this.onTapOverride,
  });

  final String imagePath;
  final String? heroTag;
  final String? networkUrl;
  final VoidCallback? onTapOverride;

  @override
  Widget build(BuildContext context) {
    final preview = ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: _PreviewImageBody(
        imagePath: imagePath,
        networkUrl: networkUrl,
      ),
    );

    return GestureDetector(
      onTap: onTapOverride ?? () => _showFullscreen(context),
      child: heroTag != null ? Hero(tag: heroTag!, child: preview) : preview,
    );
  }

  Future<void> _showFullscreen(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (_) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Hero(
                tag: heroTag ?? imagePath,
                child: InteractiveViewer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.r),
                    child: _PreviewImageBody(
                      imagePath: imagePath,
                      networkUrl: networkUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PreviewImageBody extends StatelessWidget {
  const _PreviewImageBody({
    required this.imagePath,
    this.networkUrl,
    this.fit = BoxFit.cover,
  });

  final String imagePath;
  final String? networkUrl;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (networkUrl != null && networkUrl!.isNotEmpty) {
      final url = networkUrl!;
      final isLocal = url.startsWith('file://') || url.startsWith('/');
      final isSvg = url.toLowerCase().endsWith('.svg');

      if (isLocal) {
        final file =
            url.startsWith('file://') ? File(Uri.parse(url).path) : File(url);
        if (!file.existsSync()) {
          return Image.asset(imagePath, fit: fit);
        }
        if (isSvg) {
          return SvgPicture.file(
            file,
            fit: fit,
            placeholderBuilder: (_) =>
                const Center(child: CircularProgressWidget()),
          );
        }
        return Image.file(
          file,
          fit: fit,
          errorBuilder: (_, __, ___) => Image.asset(imagePath, fit: fit),
        );
      }

      if (isSvg) {
        return SvgPicture.network(
          url,
          fit: fit,
          placeholderBuilder: (_) =>
              const Center(child: CircularProgressWidget()),
        );
      }
      return Image.network(
        url,
        fit: fit,
        errorBuilder: (_, __, ___) {
          return Image.asset(imagePath, fit: fit);
        },
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: AppColors.surfacePrimary(context),
            child: const Center(child: CircularProgressWidget()),
          );
        },
      );
    }

    return Image.asset(imagePath, fit: fit);
  }
}

class _NetworkVideoPreviewDialog extends StatefulWidget {
  const _NetworkVideoPreviewDialog({required this.videoUrl});

  final String videoUrl;

  @override
  State<_NetworkVideoPreviewDialog> createState() =>
      _NetworkVideoPreviewDialogState();
}

class _NetworkVideoPreviewDialogState
    extends State<_NetworkVideoPreviewDialog> {
  VideoPlayerController? _controller;
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    VideoPlayerController? controller;
    try {
      final uri = Uri.tryParse(widget.videoUrl);
      final isNetwork =
          uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
      controller = isNetwork
          ? VideoPlayerController.networkUrl(uri)
          : VideoPlayerController.file(
              widget.videoUrl.startsWith('file://') && uri != null
                  ? File.fromUri(uri)
                  : File(widget.videoUrl),
            );
      await controller.initialize();
      controller.play();
      if (!mounted) {
        controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _loading = false;
      });
    } catch (_) {
      controller?.dispose();
      if (!mounted) return;
      setState(() {
        _error = true;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.9),
        body: Center(
          child: _loading
              ? const CircularProgressWidget()
              : _error || _controller == null
                  ? const Icon(Icons.error, color: Colors.white)
                  : AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    ),
        ),
      ),
    );
  }
}

class _YoutubePreviewDialog extends StatefulWidget {
  const _YoutubePreviewDialog({required this.videoId});

  final String videoId;

  @override
  State<_YoutubePreviewDialog> createState() => _YoutubePreviewDialogState();
}

class _YoutubePreviewDialogState extends State<_YoutubePreviewDialog> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        forceHD: true,
        enableCaption: true,
        useHybridComposition: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.9),
        body: Center(
          child: YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.redAccent,
            ),
            builder: (context, player) {
              return AspectRatio(
                aspectRatio: 16 / 9,
                child: player,
              );
            },
          ),
        ),
      ),
    );
  }
}
