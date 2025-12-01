import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/base_page_with_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/db/entities/content_entity.dart';
import '../../core/db/entities/module_entity.dart';
import '../../core/db/isar_service.dart';
import '../../core/sync/sync_manager.dart';
import '../../l10n/app_localizations.dart';

class _ModuleData {
  const _ModuleData({required this.module, required this.contents});

  final ModuleEntity module;
  final List<ContentEntity> contents;
}

final moduleDataProvider =
    FutureProvider.family<_ModuleData, String>((ref, moduleId) async {
  final service = IsarService();
  final syncManager = ref.read(syncManagerProvider);
  var bootstrapped = false;

  Future<void> ensureBootstrap() async {
    if (bootstrapped) return;
    bootstrapped = true;
    await syncManager.bootstrap();
  }

  var module = await service.getModuleById(moduleId);
  if (module == null) {
    await ensureBootstrap();
    module = await service.getModuleById(moduleId);
  }

  if (module == null) throw Exception('Module $moduleId not found');

  var contents = await service.getContentsByModuleId(moduleId);
  if (contents.isEmpty) {
    await ensureBootstrap();
    contents = await service.getContentsByModuleId(moduleId);
  }

  return _ModuleData(module: module, contents: contents);
});

class ModulePage extends ConsumerWidget {
  const ModulePage({super.key, required this.moduleId});

  final String moduleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final moduleAsync = ref.watch(moduleDataProvider(moduleId));

    return moduleAsync.when(
      loading: () => _buildScaffold(
        context,
        const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => _buildScaffold(
        context,
        Center(child: Text('${l10n.retry}: $error')),
      ),
      data: (data) {
        final module = data.module;
        final contents = data.contents;
        final title =
            module.title.isEmpty ? l10n.moduleScreenTitle : module.title;

        if (contents.isEmpty) {
          return _buildScaffold(
            context,
            Center(child: Text(l10n.noContent)),
          );
        }

        final quiz = contents.where((c) => c.type == 'quiz').toList();
        final nonQuiz = contents.where((c) => c.type != 'quiz').toList();

        return _buildScaffold(
          context,
          BasePageWithToolbar(
            title: title,
            stickChildrenToBottom: true,
            isOneToolbarRow: true,
            children: [
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.separated(
                  itemCount: nonQuiz.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    final content = nonQuiz[index];
                    return Card(
                      child: ListTile(
                        leading: _contentIcon(content.type),
                        title: Text(content.title),
                        subtitle: Text(_contentLabel(l10n, content.type)),
                        onTap: () => context
                            .push('/module/${module.id}/${content.type}'),
                      ),
                    );
                  },
                ),
              ),
              if (quiz.isNotEmpty) _quizButton(context, l10n, module.id),
            ],
          ),
        );
      },
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

  Widget _buildScaffold(
    BuildContext context,
    Widget body,
  ) {
    return Scaffold(
      body: body,
    );
  }

  Widget _quizButton(
    BuildContext context,
    AppLocalizations l10n,
    String moduleId,
  ) {
    return ActionButtonWidget(
      text: l10n.quizTitle,
      onPressed: () => context.push('/module/$moduleId/quiz'),
    );
  }
}
