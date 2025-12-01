import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/entities/module_entity.dart';
import '../../core/db/isar_service.dart';
import '../../core/sync/sync_manager.dart';
import '../../l10n/app_localizations.dart';

final modulesProvider =
    FutureProvider.family<List<ModuleEntity>, String>((ref, subjectId) async {
  final service = IsarService();
  await service.init(); // ensure DB is ready
  var modules = await service.getModulesBySubjectId(subjectId);

  if (modules.isEmpty) {
    await ref.read(syncManagerProvider).bootstrap();
    modules = await service.getModulesBySubjectId(subjectId);
  }

  return modules;
});

class ModulesPage extends ConsumerStatefulWidget {
  const ModulesPage({super.key, required this.subjectId});

  final String subjectId;

  @override
  ConsumerState<ModulesPage> createState() => _ModulesPageState();
}

class _ModulesPageState extends ConsumerState<ModulesPage> {
  // ModulesPage тепер показує список лише при multi-module предметах.
  // Single-module предмети перенаправляються ще на рівні SubjectsPage.

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final modulesAsync = ref.watch(modulesProvider(widget.subjectId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.modulesTitle)),
      body: modulesAsync.when(
        data: (modules) {
          if (modules.isEmpty) {
            // Тимчасово показуємо loading або варто додати локалізований ключ типу noModules
            return Center(child: Text(l10n.loading));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: modules.length,
            itemBuilder: (context, index) {
              final module = modules[index];
              return ListTile(
                title: Text(module.title),
                subtitle: Text(
                  module.singleFlow
                      ? l10n.moduleSingleFlow
                      : l10n.moduleMultiStep,
                ),
                trailing: const Icon(Icons.chevron_right),
                // НОВА НАВІГАЦІЯ: завжди переходимо спершу на ModulePage (список контенту),
                // навіть якщо singleFlow. Авторедіректи забрані для прозорості UX.
                onTap: () {
                  final base = '/module/${module.id}';
                  context.push(base);
                },
              );
            },
            separatorBuilder: (_, __) => const Divider(height: 1),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('${l10n.retry}: $error')),
      ),
    );
  }
}
