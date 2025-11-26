import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/edit_text_widget.dart';
import 'package:academy_2_app/app/view/toolbar_widget.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/db/entities/subject_entity.dart';
import '../../core/db/isar_service.dart';
import '../../core/sync/sync_manager.dart';
import 'video_models.dart';
import 'video_service.dart';

final _subjectFiltersProvider = StateProvider<Set<String>>((ref) => {});
final _searchProvider = StateProvider<String>((ref) => '');

final videosProvider = FutureProvider<List<SchoolVideo>>((ref) async {
  final subjectIds = ref.watch(_subjectFiltersProvider);
  final query = ref.watch(_searchProvider);
  final service = VideoService();
  final fetched = await service.fetchVideos(
    subjectId: subjectIds.length == 1 ? subjectIds.first : null,
    query: query.isEmpty ? null : query,
  );
  if (subjectIds.isEmpty) return fetched;
  return fetched.where((v) => subjectIds.contains(v.subjectId)).toList();
});

final subjectsListProvider = FutureProvider<List<SubjectEntity>>((ref) async {
  final service = IsarService();
  var subjects = await service.getSubjects();
  if (subjects.isEmpty) {
    await ref.read(syncManagerProvider).bootstrap();
    subjects = await service.getSubjects();
  }
  return subjects;
});

class SchoolVideosPage extends ConsumerStatefulWidget {
  const SchoolVideosPage({super.key});

  @override
  ConsumerState<SchoolVideosPage> createState() => _SchoolVideosPageState();
}

class _SchoolVideosPageState extends ConsumerState<SchoolVideosPage> {
  late final TextEditingController _searchController;
  final Map<String, int> _likesCount = {};
  final Set<String> _likedIds = {};

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: ref.read(_searchProvider));
    _searchController.addListener(() {
      ref.read(_searchProvider.notifier).state = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _ensurePermissions() async {
    await [Permission.camera, Permission.photos, Permission.storage].request();
  }

  void _toggleLike(String videoId, int currentLikes, bool isLiked) {
    setState(() {
      if (isLiked) {
        _likedIds.remove(videoId);
        _likesCount[videoId] = (currentLikes - 1).clamp(0, 1000000);
      } else {
        _likedIds.add(videoId);
        _likesCount[videoId] = currentLikes + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final videos = ref.watch(videosProvider);
    final subjects = ref.watch(subjectsListProvider);
    final selectedSubject = ref.watch(_subjectFiltersProvider);
    final searchValue = ref.watch(_searchProvider);
    if (_searchController.text != searchValue) {
      _searchController.value = TextEditingValue(
        text: searchValue,
        selection: TextSelection.collapsed(offset: searchValue.length),
      );
    }

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
          subjects.when(
            data: (list) {
              return SingleChildScrollView(
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
                    ...list.map(
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
              );
            },
            loading: () => SizedBox(
                height: 48.w,
                child: Center(child: CircularProgressIndicator())),
            error: (_, __) => const SizedBox.shrink(),
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
                    child: videos.when(
                      data: (list) {
                        if (list.isEmpty) {
                          return Center(child: Text(l10n.schoolVideosEmpty));
                        }
                        final subjectsMap = {
                          for (final s
                              in subjects.valueOrNull ?? <SubjectEntity>[])
                            s.id: s
                        };
                        final Map<String, List<SchoolVideo>> grouped = {};
                        for (final video in list) {
                          grouped
                              .putIfAbsent(video.subjectId, () => [])
                              .add(video);
                        }
                        final groups = grouped.entries.toList();

                        return ListView.builder(
                          itemCount: groups.length,
                          itemBuilder: (context, index) {
                            final entry = groups[index];
                            final title = subjectsMap[entry.key]?.title ??
                                l10n.schoolVideosGroupUnknown;
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: AppTextStyles.h3(context),
                                  ),
                                  SizedBox(height: 8.h),
                                  ...entry.value.map(
                                    (video) {
                                      final statusText =
                                          video.status == 'pending'
                                              ? l10n.schoolVideosStatusPending
                                              : l10n.schoolVideosStatusApproved;
                                      final likeCount = _likesCount.putIfAbsent(
                                          video.id, () => video.likes ?? 0);
                                      if (video.liked) {
                                        _likedIds.add(video.id);
                                      }
                                      final isLiked =
                                          _likedIds.contains(video.id) ||
                                              video.liked;
                                      return Card(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: AppColors.borderPrimary(
                                                context),
                                            width: 1.w,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                        ),
                                        color:
                                            AppColors.surfacePrimary(context),
                                        margin: EdgeInsets.only(bottom: 16.h),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          onTap: () {
                                            if (video.status == 'pending') {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    _PendingDialog(l10n: l10n),
                                              );
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(6.w),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                _VideoPreview(
                                                  url: video.thumbnailUrl
                                                          .isNotEmpty
                                                      ? video.thumbnailUrl
                                                      : video.url,
                                                ),
                                                SizedBox(width: 12.w),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        video.title,
                                                        style: AppTextStyles.h4(
                                                            context),
                                                      ),
                                                      SizedBox(height: 4.h),
                                                      Text(
                                                        video.description,
                                                        style: AppTextStyles.b2(
                                                                context)
                                                            .copyWith(
                                                          color: AppColors
                                                              .contentSecondary(
                                                                  context),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (video.status == 'pending')
                                                  IconButton(
                                                    icon: Image.asset(
                                                      'assets/images/ic_close.png',
                                                      color: AppColors
                                                          .contentPrimary(
                                                              context),
                                                      width: 18.w,
                                                      height: 18.w,
                                                    ),
                                                    onPressed: () async {
                                                      await VideoService()
                                                          .deleteVideo(
                                                              video.id);
                                                      ref.invalidate(
                                                          videosProvider);
                                                    },
                                                  )
                                                else
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        icon: Icon(
                                                          isLiked
                                                              ? Icons.favorite
                                                              : Icons
                                                                  .favorite_border,
                                                          color: isLiked
                                                              ? Colors.red
                                                              : AppColors
                                                                  .contentSecondary(
                                                                      context),
                                                        ),
                                                        onPressed: () =>
                                                            _toggleLike(
                                                                video.id,
                                                                likeCount,
                                                                isLiked),
                                                      ),
                                                      Text(
                                                        '$likeCount',
                                                        style: AppTextStyles.b3(
                                                                context)
                                                            .copyWith(
                                                          color: AppColors
                                                              .contentSecondary(
                                                                  context),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) =>
                          Center(child: Text(l10n.schoolVideosError('$e'))),
                    ),
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
            ref.invalidate(videosProvider);
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
}

class _PendingDialog extends StatelessWidget {
  const _PendingDialog({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(l10n.schoolVideosPendingTitle),
      content: Text(l10n.schoolVideosPendingMessage),
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
        color: AppColors.surfacePrimary(context),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.borderPrimary(context)),
      ),
      child: Icon(Icons.play_arrow,
          color: AppColors.contentSecondary(context), size: 28.w),
    );

    if (url.isEmpty) return placeholder;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
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
