import 'package:academy_2_app/app/theme/tokens.dart';
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
                    return _buildContentCard(
                      context: context,
                      l10n: l10n,
                      moduleId: module.id,
                      content: content,
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

  Widget _buildContentCard({
    required BuildContext context,
    required AppLocalizations l10n,
    required String moduleId,
    required ContentEntity content,
  }) {
    switch (content.type) {
      case 'video':
        return _VideoContentCard(
          content: content,
          moduleId: moduleId,
          l10n: l10n,
        );
      case 'infographic':
        return _InfographicContentCard(
          content: content,
          moduleId: moduleId,
          l10n: l10n,
        );
      default:
        return _DefaultContentCard(
          content: content,
          moduleId: moduleId,
          l10n: l10n,
        );
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

class _VideoContentCard extends StatelessWidget {
  const _VideoContentCard({
    required this.content,
    required this.moduleId,
    required this.l10n,
  });

  final ContentEntity content;
  final String moduleId;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return _DescriptionCard(
      icon: const Icon(Icons.play_circle_fill),
      title: content.title,
      subtitle: l10n.videoTitle,
      onTap: () => context.push('/module/$moduleId/${content.type}'),
    );
  }
}

class _InfographicContentCard extends StatelessWidget {
  const _InfographicContentCard({
    required this.content,
    required this.moduleId,
    required this.l10n,
  });

  final ContentEntity content;
  final String moduleId;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return _DescriptionCard(
      icon: const Icon(Icons.image),
      title: content.title,
      subtitle: l10n.infographicTitle,
      onTap: () => context.push('/module/$moduleId/${content.type}'),
    );
  }
}

class _DefaultContentCard extends StatelessWidget {
  const _DefaultContentCard({
    required this.content,
    required this.moduleId,
    required this.l10n,
  });

  final ContentEntity content;
  final String moduleId;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final subtitle = content.type == 'quiz' ? l10n.quizTitle : content.type;
    return _DescriptionCard(
      icon: const Icon(Icons.article),
      title: content.title,
      subtitle: subtitle,
      onTap: () => context.push('/module/$moduleId/${content.type}'),
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  const _DescriptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Icon icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: ListTile(
        title: Text(
          title,
          style: AppTextStyles.h5(context),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.b3(context).copyWith(
            color: AppColors.contentSecondary(context),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
