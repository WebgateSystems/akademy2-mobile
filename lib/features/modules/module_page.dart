import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/base_page_with_toolbar.dart';
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

final moduleDataProvider =
    FutureProvider.family<_ModuleData, String>((ref, moduleId) async {
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

class ModulePage extends ConsumerWidget {
  const ModulePage({super.key, required this.moduleId});

  final String moduleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final moduleAsync = ref.watch(moduleDataProvider(moduleId));

    return moduleAsync.when(
      loading: () => _buildScaffold(
        context,
        const Center(child: CircularProgressIndicator()),
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

        return _buildScaffold(
          context,
          BasePageWithToolbar(
            title: title,
            stickChildrenToBottom: true,
            isOneToolbarRow: true,
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

  Widget _buildContentCard({
    required BuildContext context,
    required AppLocalizations l10n,
    required String moduleId,
    required ContentEntity content,
    VoidCallback? onVideoPreview,
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
    switch (content.type) {
      case 'video':
        final url =
            _youtubeThumbnail(content.youtubeUrl) ?? _absUrl(content.posterUrl);
        if (url == null) {
          debugPrint(
              'ModulePage: missing preview for video id=${content.id} youtube=${content.youtubeUrl} poster=${content.posterUrl} file=${content.fileUrl}');
        }
        return url;
      case 'infographic':
        final url = _absUrl(content.posterUrl) ?? _absUrl(content.fileUrl);
        if (url == null) {
          debugPrint(
              'ModulePage: missing preview for infographic id=${content.id} poster=${content.posterUrl} file=${content.fileUrl}');
        }
        return url;
      default:
        final url = _absUrl(content.posterUrl) ?? _absUrl(content.fileUrl);
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
    final fileUrl = _absUrl(content.fileUrl);
    final youtubeUrl = content.youtubeUrl;
    if (fileUrl == null && (youtubeUrl == null || youtubeUrl.isEmpty)) return;

    // If we have a direct file, show in-app fullscreen player.
    if (fileUrl != null) {
      await showDialog<void>(
        context: context,
        barrierColor: Colors.black.withOpacity(0.9),
        builder: (_) => _NetworkVideoPreviewDialog(videoUrl: fileUrl),
      );
      return;
    }

    // Otherwise, try in-app YouTube player.
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
      onTap: () => context.push('/module/$moduleId/${content.type}'),
    );
  }
}

class _InfographicContentCard extends StatelessWidget {
  const _InfographicContentCard({
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
    return _PreviewCard(
      thumbnail: PreviewImage(
        imagePath: 'assets/images/placeholder.png',
        networkUrl: previewUrl,
        heroTag: 'content-${content.id}',
      ),
      title: content.title,
      subtitle: l10n.infographicTitle,
      onTap: () => context.push('/module/$moduleId/${content.type}'),
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
      final isSvg = networkUrl!.toLowerCase().endsWith('.svg');
      if (isSvg) {
        return SvgPicture.network(
          networkUrl!,
          fit: fit,
          placeholderBuilder: (_) =>
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      }
      return Image.network(
        networkUrl!,
        fit: fit,
        errorBuilder: (_, __, ___) {
          return Image.asset(imagePath, fit: fit);
        },
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: AppColors.surfacePrimary(context),
            child: const Center(child: CircularProgressIndicator()),
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
    try {
      final controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await controller.initialize();
      controller.play();
      setState(() {
        _controller = controller;
        _loading = false;
      });
    } catch (_) {
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
              ? const CircularProgressIndicator()
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
