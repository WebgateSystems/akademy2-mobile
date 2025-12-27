import 'package:academy_2_app/core/db/entities/content_entity.dart';
import 'package:academy_2_app/features/modules/cards/preview_card.dart';
import 'package:academy_2_app/features/modules/cards/preview_image.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoContentCard extends StatelessWidget {
  const VideoContentCard({
    super.key,
    required this.content,
    required this.moduleId,
    required this.l10n,
    required this.previewUrl,
    required this.onPreviewTap,
  });

  final ContentEntity content;
  final String moduleId;
  final AppLocalizations l10n;
  final String? previewUrl;
  final VoidCallback onPreviewTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PreviewCard(
          thumbnail: PreviewImage(
            imagePath: 'assets/images/placeholder.png',
            networkUrl: previewUrl,
            heroTag: 'content-${content.id}',
            onTapOverride: onPreviewTap,
          ),
          title: content.title,
          subtitle: l10n.videoTitle,
          onTap: onPreviewTap,
        ),
        Positioned(
          top: 76.h,
          left: MediaQuery.of(context).size.width / 2 - 48.w,
          child: InkWell(
            onTap: onPreviewTap,
            child: Image.asset(
              'assets/images/ic_play_arrow_48.png',
              fit: BoxFit.contain,
              width: 48.r,
              height: 48.r,
            ),
          ),
        ),
      ],
    );
  }
}
