import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/circular_progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/student_api_service.dart';
import '../../l10n/app_localizations.dart';

class ModulesPage extends ConsumerStatefulWidget {
  const ModulesPage({super.key, required this.subjectId});

  final String subjectId;

  @override
  ConsumerState<ModulesPage> createState() => _ModulesPageState();
}

class _ModulesPageState extends ConsumerState<ModulesPage> {
  bool _offlineDialogShown = false;
  bool _navigatedToWaitApproval = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final subjectAsync = ref.watch(subjectDetailProvider(widget.subjectId));

    return Scaffold(
      body: subjectAsync.when(
        data: (subject) {
          final allModules = subject.allModules;
          if (allModules.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showOfflineDialog(context, l10n);
            });
            return const SizedBox();
          }

          if (subject.units.length > 1) {
            return _buildGroupedList(context, subject, l10n);
          }

          return _buildFlatList(context, allModules, l10n);
        },
        loading: () => const Center(child: CircularProgressWidget()),
        error: (error, _) {
          if (error is StudentAccessRequiredException &&
              !_navigatedToWaitApproval) {
            _navigatedToWaitApproval = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                context.go('/wait-approval');
              }
            });
            return const SizedBox();
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showOfflineDialog(context, l10n);
          });
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildGroupedList(
    BuildContext context,
    SubjectDetailData subject,
    AppLocalizations l10n,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: subject.units.length,
      itemBuilder: (context, unitIndex) {
        final unit = subject.units[unitIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (unitIndex > 0) const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                unit.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ...unit.modules
                .map((module) => _buildModuleTile(context, module, l10n)),
          ],
        );
      },
    );
  }

  Widget _buildFlatList(
    BuildContext context,
    List<SubjectModule> modules,
    AppLocalizations l10n,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: modules.length,
      itemBuilder: (context, index) =>
          _buildModuleTile(context, modules[index], l10n),
      separatorBuilder: (_, __) => const Divider(height: 1),
    );
  }

  Widget _buildModuleTile(
    BuildContext context,
    SubjectModule module,
    AppLocalizations l10n,
  ) {
    return ListTile(
      title: Text(module.title),
      subtitle: Text(
        module.completed
            ? (module.score != null ? '✓ ${module.score}%' : '✓')
            : l10n.moduleMultiStep,
      ),
      trailing: module.completed
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.chevron_right),
      onTap: () {
        context.push('/module/${module.id}');
      },
    );
  }

  Future<void> _showOfflineDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    if (_offlineDialogShown) return;
    _offlineDialogShown = true;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _OfflineContentDialog(
        title: l10n.offlineContentTitle,
        message: l10n.offlineContentMessage,
        confirmText: l10n.ok,
      ),
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _OfflineContentDialog extends StatelessWidget {
  const _OfflineContentDialog({
    required this.title,
    required this.message,
    required this.confirmText,
  });

  final String title;
  final String message;
  final String confirmText;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        constraints: BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfacePrimary(context),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.h3(context),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.b1(context)
                  .copyWith(color: AppColors.contentSecondary(context)),
            ),
            const SizedBox(height: 32),
            ActionButtonWidget(
              height: 48.r,
              onPressed: () => Navigator.of(context).pop(),
              text: confirmText,
            ),
          ],
        ),
      ),
    );
  }
}
