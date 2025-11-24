import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/entities/content_entity.dart';
import '../../core/db/entities/module_entity.dart';
import '../../core/db/isar_service.dart';
import '../../core/sync/sync_manager.dart';
import '../../l10n/app_localizations.dart';

final moduleProvider =
    FutureProvider.family<ModuleEntity?, String>((ref, moduleId) async {
  final service = IsarService();
  var module = await service.getModuleById(moduleId);

  if (module == null) {
    await ref.read(syncManagerProvider).bootstrap();
    module = await service.getModuleById(moduleId);
  }

  return module;
});

final moduleContentsProvider =
    FutureProvider.family<List<ContentEntity>, String>((ref, moduleId) async {
  final service = IsarService();
  var contents = await service.getContentsByModuleId(moduleId);

  if (contents.isEmpty) {
    await ref.read(syncManagerProvider).bootstrap();
    contents = await service.getContentsByModuleId(moduleId);
  }

  return contents;
});

class ModulePage extends ConsumerWidget {
  const ModulePage({super.key, required this.moduleId});

  final String moduleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final moduleAsync = ref.watch(moduleProvider(moduleId));
    final contentsAsync = ref.watch(moduleContentsProvider(moduleId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moduleScreenTitle)),
      body: moduleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('${l10n.retry}: $error')),
        data: (module) {
          if (module == null) {
            return Center(child: Text(l10n.loading));
          }

          return contentsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('${l10n.retry}: $error')),
            data: (contents) {
              if (contents.isEmpty) {
                return Center(child: Text(l10n.loading));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: contents.length,
                itemBuilder: (context, index) {
                  final content = contents[index];
                  return Card(
                    child: ListTile(
                      leading: _contentIcon(content.type),
                      title: Text(content.title),
                      subtitle: Text(_contentLabel(l10n, content.type)),
                      onTap: () => context.go(
                        '/module/${module.id}/${content.type}',
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Icon _contentIcon(String type) {
    switch (type) {
      case 'video':
        return const Icon(Icons.play_circle_fill);
      case 'infographic':
        return const Icon(Icons.image);
      case 'quiz':
        return const Icon(Icons.quiz);
      default:
        return const Icon(Icons.article);
    }
  }

  String _contentLabel(AppLocalizations l10n, String type) {
    switch (type) {
      case 'video':
        return l10n.videoTitle;
      case 'infographic':
        return l10n.infographicTitle;
      case 'quiz':
        return l10n.quizTitle;
      default:
        return type;
    }
  }
}
