import 'package:academy_2_app/app/view/circular_progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/student_api_service.dart';
import '../../l10n/app_localizations.dart';

class ModulesPage extends ConsumerWidget {
  const ModulesPage({super.key, required this.subjectId});

  final String subjectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final subjectAsync = ref.watch(subjectDetailProvider(subjectId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.modulesTitle)),
      body: subjectAsync.when(
        data: (subject) {
          final allModules = subject.allModules;
          if (allModules.isEmpty) {
            return Center(child: Text(l10n.loading));
          }

          if (subject.units.length > 1) {
            return _buildGroupedList(context, subject, l10n);
          }

          return _buildFlatList(context, allModules, l10n);
        },
        loading: () => const Center(child: CircularProgressWidget()),
        error: (error, _) => Center(child: Text('${l10n.retry}: $error')),
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
}
