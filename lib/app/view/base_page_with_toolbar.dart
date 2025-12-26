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
  final bool isOneToolbarRow;
  final bool stickChildrenToBottom;
  final double? paddingBottom;
  final Widget? rightIcon;
  final Future<void> Function()? onBack;

  const BasePageWithToolbar({
    super.key,
    this.title = "",
    this.subtitle = "",
    this.showBackButton = true,
    this.isOneToolbarRow = false,
    this.children = const <Widget>[],
    this.stickChildrenToBottom = false,
    this.paddingBottom,
    this.rightIcon,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (context, constraints) {
        final childWidgets = children ?? const <Widget>[];
        final spacerIndex =
            childWidgets.indexWhere((widget) => widget is Spacer);
        final bodyChildren = spacerIndex == -1
            ? childWidgets
            : childWidgets.sublist(0, spacerIndex);
        final footerChildren =
            spacerIndex == -1 ? <Widget>[] : childWidgets.sublist(spacerIndex + 1);
        final hasFlexChild = bodyChildren
            .any((w) => w is Expanded || w is Flexible || w is FlexibleSpaceBar);

        if (stickChildrenToBottom) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: bottomInset),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  SizedBox(height: 32.h),
                  if (showBackButton && !isOneToolbarRow)
                    Padding(
                      padding: EdgeInsets.only(top: 16.h),
                      child: ToolbarWidget(
                        leftIcon: IconButton(
                          icon: Image.asset(
                            'assets/images/ic_chevron_left.png',
                            color: AppColors.contentPrimary(context),
                          ),
                          onPressed: () async {
                            if (onBack != null) {
                              await onBack!();
                            } else {
                              context.pop();
                            }
                          },
                        ),
                      ),
                    ),
                  if (title.isNotEmpty) SizedBox(height: 16.h),
                  if (title.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(
                          right: 20.w,
                          left: (showBackButton && isOneToolbarRow) ? 0 : 20.w),
                      child: ToolbarWidget(
                        leftIcon: (showBackButton && isOneToolbarRow)
                            ? IconButton(
                                icon: Image.asset(
                                  'assets/images/ic_chevron_left.png',
                                  color: AppColors.contentPrimary(context),
                                ),
                                onPressed: () async {
                                  if (onBack != null) {
                                    await onBack!();
                                  } else {
                                    context.pop();
                                  }
                                },
                              )
                            : null,
                        title: title,
                        rightIcon: rightIcon,
                        titleTextStyle: isOneToolbarRow
                            ? AppTextStyles.h3(context).copyWith(
                                color: AppColors.contentPrimary(context),
                              )
                            : null,
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (subtitle.isNotEmpty) SizedBox(height: 16.h),
                          if (subtitle.isNotEmpty)
                            Text(
                              subtitle,
                              style: AppTextStyles.b1(context).copyWith(
                                color: AppColors.contentSecondary(context),
                              ),
                            ),
                          if (hasFlexChild)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...bodyChildren,
                                ],
                              ),
                            )
                          else
                            Expanded(
                              child: SingleChildScrollView(
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: bodyChildren,
                                ),
                              ),
                            ),
                          ...footerChildren,
                          SizedBox(height: paddingBottom ?? 57.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              SizedBox(height: 32.h),
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
