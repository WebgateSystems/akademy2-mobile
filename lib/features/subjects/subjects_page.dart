import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/toolbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/entities/subject_entity.dart';
import '../../core/db/isar_service.dart';
import '../../core/sync/sync_manager.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/subject_tile.dart';

final subjectsProvider = FutureProvider<List<SubjectEntity>>((ref) async {
  final service = IsarService();
  await service.init(); // ensure DB open before queries
  var subjects = await service.getSubjects();

  // Ensure we have data in the local cache
  if (subjects.isEmpty) {
    await ref.read(syncManagerProvider).bootstrap();
    subjects = await service.getSubjects();
  }

  return subjects;
});

class SubjectsPage extends ConsumerStatefulWidget {
  const SubjectsPage({super.key});

  @override
  ConsumerState<SubjectsPage> createState() => _SubjectsPageState();
}

class _SubjectsPageState extends ConsumerState<SubjectsPage> {
  Future<void> _refresh() async {
    await ref.read(syncManagerProvider).bootstrap();
    ref.invalidate(subjectsProvider);
  }

  Future<void> _handleSubjectTap(SubjectEntity subject) async {
    if (!mounted) return;
    // Navigate according to tech spec:
    // If subject has exactly one module → go directly to its video flow.
    // Otherwise → go to modules list for the subject.
    final service = IsarService();
    await service.init();
    final modules = await service.getModulesBySubjectId(subject.id);
    if (modules.length == 1) {
      final moduleId = modules.first.id;
      // НОВА ЛОГІКА: навіть для singleFlow модулів спочатку показуємо ModulePage (список контенту).
      context.push('/module/$moduleId');
    } else {
      // Multi-module – відкриваємо список модулів.
      context.push('/subject/${subject.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final subjectsAsync = ref.watch(subjectsProvider);

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
                    mainAxisSpacing: 10.w,
                    crossAxisSpacing: 10.w,
                    childAspectRatio: 1,
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
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text('${l10n.retry}: $error'),
      ),
    );
  }
}
