import 'package:academy_2_app/core/db/entities/content_entity.dart';
import 'package:academy_2_app/features/modules/cards/preview_card.dart';
import 'package:academy_2_app/features/modules/cards/preview_image.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DefaultContentCard extends StatelessWidget {
  const DefaultContentCard({
    super.key,
    required this.content,
    required this.moduleId,
    required this.l10n,
    required this.previewUrl,
  });

  final ContentEntity content;
  final String moduleId;
  final AppLocalizations l10n;
  final String? previewUrl;

  @override
  Widget build(BuildContext context) {
    final subtitle = content.type == 'quiz' ? l10n.quizTitle : content.type;
    return PreviewCard(
      thumbnail: PreviewImage(
        imagePath: 'assets/images/placeholder.png',
        networkUrl: previewUrl,
        heroTag: 'content-${content.id}',
      ),
      title: content.title,
      subtitle: subtitle,
      onTap: () => context.push('/module/$moduleId/${content.type}'),
    );
  }
}
