import 'dart:async';

import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/base_wait_approval_page.dart';
import 'package:academy_2_app/app/view/circular_progress_widget.dart';
import 'package:academy_2_app/app/view/edit_text_widget.dart';
import 'package:academy_2_app/app/view/toolbar_widget.dart';
import 'package:academy_2_app/features/modules/dialogs/network_video_preview_dialog.dart';
import 'package:academy_2_app/features/modules/dialogs/youtube_preview_dialog.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import 'edit_video_page.dart';
import 'video_models.dart';
import 'video_service.dart';

final _subjectFiltersProvider = StateProvider<Set<String>>((ref) => {});
final _searchProvider = StateProvider<String>((ref) => '');

final videosProvider = FutureProvider<VideosResponse>((ref) async {
  final subjectIds = ref.watch(_subjectFiltersProvider);
  final query = ref.watch(_searchProvider);
  final service = VideoService();
  return await service.fetchVideos(
    page: 1,
    subjectId: subjectIds.length == 1 ? subjectIds.first : null,
    query: query.isEmpty ? null : query,
  );
});

class SchoolVideosPage extends ConsumerStatefulWidget {
  const SchoolVideosPage({super.key});

  @override
  ConsumerState<SchoolVideosPage> createState() => _SchoolVideosPageState();
}

class _SchoolVideosPageState extends ConsumerState<SchoolVideosPage> {
  late final TextEditingController _searchController;
  late final ScrollController _scrollController;
  final Map<String, int> _likesCount = {};
  final Set<String> _likedIds = {};
  final Map<String, VideoDetail> _videoDetails = {};

  final List<SchoolVideo> _videos = [];
  List<VideoSubjectFilter> _subjects = [];
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: ref.read(_searchProvider));
    _searchController.addListener(_onSearchChanged);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSubjects();
      _loadVideos(reset: true);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> _loadSubjects() async {
    try {
      final service = VideoService();
      final subjects = await service.fetchSubjects();
      setState(() {
        _subjects = subjects;
      });
    } catch (e) {
    }
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(_searchProvider.notifier).state = _searchController.text;
      _loadVideos(reset: true);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreVideos();
    }
  }

  Future<void> _loadVideos({bool reset = false}) async {
    if (reset) {
      setState(() {
        _videos.clear();
        _videoDetails.clear();
        _currentPage = 1;
        _hasMore = true;
      });
    }

    if (!_hasMore || _isLoadingMore) return;

    setState(() => _isLoadingMore = true);

    try {
      final subjectIds = ref.read(_subjectFiltersProvider);
      final query = ref.read(_searchProvider);
      final service = VideoService();

      final response = await service.fetchVideos(
        page: _currentPage,
        subjectId: subjectIds.length == 1 ? subjectIds.first : null,
        query: query.isEmpty ? null : query,
      );

      final newVideos = <SchoolVideo>[];
      for (final video in response.data) {
        if (subjectIds.isNotEmpty && !subjectIds.contains(video.subjectId)) {
          continue;
        }
        newVideos.add(video);
      }

      setState(() {
        _videos.addAll(newVideos);
        _hasMore = response.meta.hasMore;
        _currentPage++;
        _isLoadingMore = false;
      });

      _fetchVideoDetails(newVideos.map((v) => v.id).toList());
    } catch (e) {
      setState(() => _isLoadingMore = false);
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.schoolVideosError('$e'))),
        );
      }
    }
  }

  Future<void> _fetchVideoDetails(List<String> videoIds) async {
    final service = VideoService();
    for (final id in videoIds) {
      try {
        final detail = await service.fetchVideoById(id);
        if (mounted) {
          setState(() {
            _videoDetails[id] = detail;
          });
        }
      } catch (e) {
      }
    }
  }

  Future<void> _loadMoreVideos() async {
    if (!_hasMore || _isLoadingMore) return;
    await _loadVideos();
  }

  Future<void> _ensurePermissions() async {
    await [Permission.camera, Permission.photos, Permission.storage].request();
  }

  Future<void> _onEditVideo(SchoolVideo video) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => EditVideoPage(video: video),
      ),
    );
    if (result == true) {
      _loadVideos(reset: true);
    }
  }

  Future<void> _onVideoTap(SchoolVideo video) async {
    final detail = _videoDetails[video.id];

    if (detail != null) {
      if (detail.isPending) {
        showDialog(
          context: context,
          builder: (context) => const _PendingDialog(),
        );
      } else {
        _showVideoPreview(video);
      }
      return;
    }

    try {
      final service = VideoService();
      final fetchedDetail = await service.fetchVideoById(video.id);
      if (!mounted) return;

      setState(() {
        _videoDetails[video.id] = fetchedDetail;
      });

      if (fetchedDetail.isPending) {
        showDialog(
          context: context,
          builder: (context) => const _PendingDialog(),
        );
      } else {
        _showVideoPreview(video);
      }
    } catch (e) {
      _showVideoPreview(video);
    }
  }

  void _showVideoPreview(SchoolVideo video) {
    final youtubeUrl = video.youtubeUrl;
    final hasYoutube = youtubeUrl.isNotEmpty;
    final hasFile = video.fileUrl.isNotEmpty;

    if (hasYoutube) {
      final videoId = _youtubeVideoId(youtubeUrl);
      if (videoId != null) {
        showDialog<void>(
          context: context,
          barrierColor: Colors.black.withOpacity(0.9),
          builder: (_) => YoutubePreviewDialog(videoId: videoId),
        );
        return;
      }
    }

    if (hasFile) {
      showDialog<void>(
        context: context,
        barrierColor: Colors.black.withOpacity(0.9),
        builder: (_) => NetworkVideoPreviewDialog(videoUrl: video.fileUrl),
      );
    }
  }

  String? _youtubeVideoId(String url) {
    final patterns = [
      RegExp(r'youtu\.be/([a-zA-Z0-9_-]+)'),
      RegExp(r'youtube\.com/watch\?v=([a-zA-Z0-9_-]+)'),
      RegExp(r'youtube\.com/embed/([a-zA-Z0-9_-]+)'),
      RegExp(r'youtube\.com/v/([a-zA-Z0-9_-]+)'),
    ];
    for (final pattern in patterns) {
      final match = pattern.firstMatch(url);
      if (match != null) return match.group(1);
    }
    return null;
  }

  Future<void> _toggleLike(
      String videoId, int currentLikes, bool isLiked) async {
    setState(() {
      if (isLiked) {
        _likedIds.remove(videoId);
        _likesCount[videoId] = (currentLikes - 1).clamp(0, 1000000);
      } else {
        _likedIds.add(videoId);
        _likesCount[videoId] = currentLikes + 1;
      }
    });

    try {
      final service = VideoService();
      await service.toggleLike(videoId);
    } catch (e) {
      setState(() {
        if (isLiked) {
          _likedIds.add(videoId);
          _likesCount[videoId] = currentLikes;
        } else {
          _likedIds.remove(videoId);
          _likesCount[videoId] = currentLikes;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedSubject = ref.watch(_subjectFiltersProvider);

    ref.listen(_subjectFiltersProvider, (_, __) {
      _loadVideos(reset: true);
    });

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 44.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                ToolbarWidget(
                  title: l10n.schoolVideosTitle,
                ),
                SizedBox(height: 16.h),
                Text(
                  l10n.schoolVideosSubtitle,
                  style: AppTextStyles.b1(context).copyWith(
                    color: AppColors.contentSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          if (_subjects.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 20.w),
                  _FilterChip(
                    label: l10n.schoolVideosFilterAll,
                    selected: selectedSubject.isEmpty,
                    onTap: () =>
                        ref.read(_subjectFiltersProvider.notifier).state = {},
                  ),
                  ..._subjects.map(
                    (s) => Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: _FilterChip(
                        label: s.title,
                        selected: selectedSubject.contains(s.id),
                        onTap: () {
                          final current =
                              ref.read(_subjectFiltersProvider.notifier);
                          final next = {...current.state};
                          if (next.contains(s.id)) {
                            next.remove(s.id);
                          } else {
                            next.add(s.id);
                          }
                          current.state = next;
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                ],
              ),
            ),
          SizedBox(height: 16.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  EditTextWidget(
                    controller: _searchController,
                    hint: l10n.schoolVideosSearchHint,
                    suffixIcon: Image.asset(
                      'assets/images/ic_search.png',
                      width: 22.w,
                      height: 22.w,
                      color: AppColors.contentPlaceholder(context),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: _buildVideosList(l10n),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.surfaceAccent(context),
        foregroundColor: AppColors.contentOnAccentPrimary(context),
        shape: CircleBorder(),
        onPressed: () async {
          await _ensurePermissions();
          if (!context.mounted) return;
          final result = await context.push('/videos/add');
          if (result == true) {
            _loadVideos(reset: true);
          }
        },
        child: Image.asset(
          'assets/images/ic_add.png',
          width: 24.w,
          height: 24.w,
          color: AppColors.contentOnAccentPrimary(context),
        ),
      ),
    );
  }

  Widget _buildVideosList(AppLocalizations l10n) {
    if (_videos.isEmpty && _isLoadingMore) {
      return const Center(child: CircularProgressWidget());
    }

    if (_videos.isEmpty) {
      return Center(child: Text(l10n.schoolVideosEmpty));
    }

    final Map<String, List<SchoolVideo>> grouped = {};
    for (final video in _videos) {
      grouped.putIfAbsent(video.subjectId, () => []).add(video);
    }
    final groups = grouped.entries.toList();

    final subjectsMap = {for (final s in _subjects) s.id: s.title};

    return ListView.builder(
      controller: _scrollController,
      itemCount: groups.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == groups.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: const Center(child: CircularProgressWidget()),
          );
        }

        final entry = groups[index];
        final title = subjectsMap[entry.key] ?? l10n.schoolVideosGroupUnknown;

        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GroupTitleWidget(title: title),
              SizedBox(height: 8.h),
              ...entry.value.map((video) {
                final likeCount =
                    _likesCount.putIfAbsent(video.id, () => video.likesCount);
                if (video.likedByMe) {
                  _likedIds.add(video.id);
                }
                final isLiked = _likedIds.contains(video.id);
                final detail = _videoDetails[video.id];
                return _getVideoCard(
                    context, video, isLiked, likeCount, detail);
              }),
            ],
          ),
        );
      },
    );
  }

  Card _getVideoCard(BuildContext context, SchoolVideo video, bool isLiked,
      int likeCount, VideoDetail? detail) {
    final isMyPendingVideo =
        detail != null && detail.author?.isMe == true && detail.isPending;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: AppColors.borderPrimary(context),
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      color: AppColors.surfacePrimary(context),
      margin: EdgeInsets.only(bottom: 16.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: isMyPendingVideo
            ? () => _onEditVideo(video)
            : () => _onVideoTap(video),
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _onVideoTap(video),
                child: _VideoPreview(
                  url: video.thumbnailUrl.isNotEmpty
                      ? video.thumbnailUrl
                      : video.fileUrl,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      style: AppTextStyles.h4(context),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      video.description,
                      style: AppTextStyles.b2(context).copyWith(
                        color: AppColors.contentSecondary(context),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (video.author != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        video.author!.name,
                        style: AppTextStyles.b3(context).copyWith(
                          color: AppColors.contentTertiary(context),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isMyPendingVideo)
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    minWidth: 32.w,
                    minHeight: 32.w,
                  ),
                  icon: Image.asset(
                    'assets/images/ic_close.png',
                    color: AppColors.contentError(context),
                    width: 20.w,
                    height: 20.w,
                  ),
                  onPressed: () async {
                    await VideoService().deleteVideo(video.id);
                    _loadVideos(reset: true);
                  },
                )
              else
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: 32.w,
                        minHeight: 32.w,
                      ),
                      icon: isLiked
                          ? Image.asset(
                              'assets/images/ic_favorite.png',
                              color: AppColors.contentAccent(context),
                            )
                          : Image.asset(
                              'assets/images/ic_favorite_border.png',
                              color: AppColors.contentAccent(context),
                            ),
                      onPressed: () =>
                          _toggleLike(video.id, likeCount, isLiked),
                    ),
                    Text(
                      '$likeCount',
                      style: AppTextStyles.b3(context).copyWith(
                        color: AppColors.contentSecondary(context),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupTitleWidget extends StatelessWidget {
  const GroupTitleWidget({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        CircleAvatar(
          radius: 32.w / 2,
          backgroundColor: AppColors.surfaceIcon(context),
          child: null,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.h3(context),
          ),
        ),
      ],
    );
  }
}

class _VideoPreview extends StatelessWidget {
  const _VideoPreview({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/placeholder.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Image.asset(
        'assets/images/ic_play_arrow.png',
        width: 20.w,
        height: 20.w,
      ),
    );

    if (url.isEmpty) return placeholder;

    return ClipRRect(
      borderRadius: BorderRadius.circular(4.r),
      child: SizedBox(
        width: 56.w,
        height: 56.w,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => placeholder,
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final background = selected
        ? AppColors.surfaceAccent(context)
        : AppColors.surfacePrimary(context);
    final textColor = selected
        ? AppColors.contentOnAccentPrimary(context)
        : AppColors.contentPrimary(context);

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(4.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(4.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 8.h),
          child: Text(
            label,
            style: AppTextStyles.b2(context).copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}

class _PendingDialog extends StatefulWidget {
  const _PendingDialog();

  @override
  State<_PendingDialog> createState() => _PendingDialogState();
}

class _PendingDialogState extends State<_PendingDialog> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BaseWaitApprovalPage(
      title: l10n.schoolVideosPendingTitle,
      subtitle: l10n.schoolVideosPendingMessage,
    );
  }
}
