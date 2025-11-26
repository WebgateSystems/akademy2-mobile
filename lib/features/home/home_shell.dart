import 'package:academy_2_app/app/theme/tokens.dart';
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
        child: CustomBottomBar(
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
      ),
    );
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
