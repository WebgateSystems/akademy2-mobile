import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/toolbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class BasePageWithToolbar extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget>? children;
  final bool showBackButton;

  final bool stickChildrenToBottom;

  const BasePageWithToolbar({
    super.key,
    this.title = "",
    this.subtitle = "",
    this.showBackButton = true,
    this.children = const <Widget>[],
    this.stickChildrenToBottom = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (stickChildrenToBottom) {
          // Режим "контент притиснутий донизу", без вертикального скролу
          return SizedBox(
            height: constraints.maxHeight,
            child: Column(
              children: [
                SizedBox(height: 44.h),
                if (showBackButton)
                  Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: ToolbarWidget(
                      leftIcon: IconButton(
                        icon: Image.asset(
                          'assets/images/ic_chevron_left.png',
                          color: AppColors.contentPrimary(context),
                        ),
                        onPressed: () => context.pop(),
                      ),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title.isNotEmpty) SizedBox(height: 16.h),
                        if (title.isNotEmpty)
                          ToolbarWidget(
                            title: title,
                          ),
                        if (subtitle.isNotEmpty) SizedBox(height: 16.h),
                        if (subtitle.isNotEmpty)
                          Text(
                            subtitle,
                            style: AppTextStyles.b1(context).copyWith(
                              color: AppColors.contentSecondary(context),
                            ),
                          ),
                        ...?children,
                        SizedBox(height: 64.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 44.h),
              if (showBackButton)
                Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: ToolbarWidget(
                    leftIcon: IconButton(
                      icon: Image.asset(
                        'assets/images/ic_chevron_left.png',
                        color: AppColors.contentPrimary(context),
                      ),
                      onPressed: () => context.pop(),
                    ),
                  ),
                ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (title.isNotEmpty) SizedBox(height: 16.h),
                        if (title.isNotEmpty)
                          ToolbarWidget(
                            title: title,
                          ),
                        if (subtitle.isNotEmpty) SizedBox(height: 16.h),
                        if (subtitle.isNotEmpty)
                          Text(
                            subtitle,
                            style: AppTextStyles.b1(context).copyWith(
                              color: AppColors.contentSecondary(context),
                            ),
                          ),
                        SizedBox(height: 16.h),
                        ...?children,
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
