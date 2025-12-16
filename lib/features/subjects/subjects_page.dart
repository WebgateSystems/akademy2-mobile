import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/circular_progress_widget.dart'
    show CircularProgressWidget;
import 'package:academy_2_app/app/view/toolbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/student_api_service.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/subject_tile.dart';

class SubjectsPage extends ConsumerStatefulWidget {
  const SubjectsPage({super.key});

  @override
  ConsumerState<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends ConsumerState<SubjectsPage> {
  ProviderSubscription<AsyncValue<List<DashboardSubject>>>? _dashboardSub;
  bool _navigatedToWaitApproval = false;

  @override
  void initState() {
    super.initState();
    _dashboardSub = ref.listenManual<AsyncValue<List<DashboardSubject>>>(
      dashboardSubjectsProvider,
      (_, next) {
        next.whenOrNull(
          error: (err, _) => _handleDashboardError(err),
        );
      },
    );
  }

  @override
  void dispose() {
    _dashboardSub?.close();
    super.dispose();
  }

  void _handleDashboardError(Object error) {
    if (error is StudentAccessRequiredException && !_navigatedToWaitApproval) {
      _navigatedToWaitApproval = true;
      if (mounted) {
        context.go('/wait-approval');
      }
    }
  }

  Future<void> _refresh() async {
    ref.invalidate(dashboardSubjectsProvider);
  }

  Future<void> _handleSubjectTap(DashboardSubject subject) async {
    if (!mounted) return;
    if (subject.totalModules == 1) {
      try {
        final detail = await ref
            .read(studentApiServiceProvider)
            .fetchSubjectDetail(subject.id);
        final modules = detail.allModules;
        if (modules.length == 1 && mounted) {
          context.push('/module/${modules.first.id}');
          return;
        }
      } catch (e, st) {
        debugPrint('SubjectsPage: failed to preload module - $e\n$st');
      }
    }
    if (mounted) {
      context.push('/subject/${subject.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final subjectsAsync = ref.watch(dashboardSubjectsProvider);

    return subjectsAsync.when(
      data: (data) {
        if (data.isEmpty) {
          return Center(child: Text(l10n.noSubjects));
        }
        return RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: 44.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16.h),
                          ToolbarWidget(
                            title: l10n.coursesTitle,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            l10n.chooseSubjectSubtitle,
                            style: AppTextStyles.b1(context).copyWith(
                              color: AppColors.contentSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 2.w,
                    crossAxisSpacing: 12.w,
                    childAspectRatio: 0.9,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final subject = data[index];
                      return SubjectTile(
                        subject: subject,
                        onTap: () => _handleSubjectTap(subject),
                      );
                    },
                    childCount: data.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressWidget()),
      error: (error, _) {
        if (error is StudentAccessRequiredException) {
          return const SizedBox.shrink();
        }
        return Center(
          child: Text('${l10n.retry}: $error'),
        );
      },
    );
  }
}
