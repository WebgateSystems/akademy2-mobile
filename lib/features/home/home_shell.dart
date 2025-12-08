import 'dart:async';

import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/core/services/quiz_sync_service.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../profile/profile_page.dart';
import '../subjects/subjects_page.dart';
import '../videos/school_videos_page.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  SyncStatus _syncStatus = SyncStatus.online;
  bool _hasPendingQueue = false;
  StreamSubscription<SyncStatus>? _syncSubscription;
  StreamSubscription<bool>? _pendingSubscription;

  @override
  void initState() {
    super.initState();
    QuizSyncService.instance.init();
    _checkPendingQueue();
    _syncSubscription = QuizSyncService.instance.statusStream.listen((status) {
      if (mounted) {
        setState(() => _syncStatus = status);
      }
    });
    _pendingSubscription =
        QuizSyncService.instance.pendingStream.listen((hasPending) {
      if (mounted) {
        setState(() => _hasPendingQueue = hasPending);
      }
    });
  }

  @override
  void dispose() {
    _syncSubscription?.cancel();
    _pendingSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final pages = [
      const SubjectsPage(),
      const SchoolVideosPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_index]),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SyncBanner(
              status: _syncStatus,
              hasPendingQueue: _hasPendingQueue,
            ),
            CustomBottomBar(
              currentIndex: _index,
              onTap: (i) {
                setState(() => _index = i);
              },
              items: [
                CustomBottomItem(
                  icon: 'assets/images/ic_courses.png',
                  label: l10n.bottomNavCourses,
                ),
                CustomBottomItem(
                  icon: 'assets/images/ic_school_videos.png',
                  label: l10n.bottomNavSchoolVideos,
                ),
                CustomBottomItem(
                  icon: 'assets/images/ic_account.png',
                  label: l10n.bottomNavAccount,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkPendingQueue() async {
    final hasPending = await QuizSyncService.instance.hasPendingItems();
    if (mounted) {
      setState(() => _hasPendingQueue = hasPending);
    }
  }
}

class CustomBottomItem {
  final String icon;
  final String label;

  CustomBottomItem({
    required this.icon,
    required this.label,
  });
}

class CustomBottomBar extends StatelessWidget {
  final List<CustomBottomItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.h,
      padding: EdgeInsets.only(bottom: 12.h, top: 8.h),
      decoration: BoxDecoration(
        color: AppColors.background(context),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(items.length, (i) {
          final item = items[i];
          final selected = i == currentIndex;

          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => onTap(i),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  item.icon,
                  width: 24.w,
                  height: 24.w,
                  color: selected
                      ? AppColors.contentAccent(context)
                      : AppColors.contentSecondary(context),
                ),
                SizedBox(height: 6.h),
                Text(
                  item.label,
                  style: selected
                      ? AppTextStyles.b3(context)
                          .copyWith(color: AppColors.contentAccent(context))
                      : AppTextStyles.b3(context)
                          .copyWith(color: AppColors.contentSecondary(context)),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _SyncBanner extends StatelessWidget {
  const _SyncBanner({
    required this.status,
    required this.hasPendingQueue,
  });

  final SyncStatus status;
  final bool hasPendingQueue;

  @override
  Widget build(BuildContext context) {
    if (status == SyncStatus.online || !hasPendingQueue) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;

    String message;
    Color bgColor;
    String icon;

    switch (status) {
      case SyncStatus.offline:
        message = l10n.offlineBanner;
        bgColor = AppColors.surfaceActive(context);
        icon = 'assets/images/ic_wifi_off.png';
        break;
      case SyncStatus.syncing:
        message = l10n.syncingBanner;
        bgColor = AppColors.surfaceSucceess(context);
        icon = 'assets/images/ic_syncing.png';
        break;
      case SyncStatus.synced:
        message = l10n.syncedBanner;
        bgColor = AppColors.surfaceSucceess(context);
        icon = 'assets/images/ic_synced.png';
        break;
      case SyncStatus.online:
        return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      color: bgColor,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(icon,
                    color: AppColors.contentPrimary(context),
                    width: 20.w,
                    height: 20.w),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.b2(context),
            ),
          ),
        ],
      ),
    );
  }
}
