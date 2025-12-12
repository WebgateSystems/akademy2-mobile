import 'package:academy_2_app/features/modules/cards/preview_image_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreviewImage extends StatelessWidget {
  const PreviewImage({
    super.key,
    required this.imagePath,
    this.heroTag,
    this.networkUrl,
    this.onTapOverride,
  });

  final String imagePath;
  final String? heroTag;
  final String? networkUrl;
  final VoidCallback? onTapOverride;

  @override
  Widget build(BuildContext context) {
    final preview = ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: PreviewImageBody(
        imagePath: imagePath,
        networkUrl: networkUrl,
      ),
    );

    return GestureDetector(
      onTap: onTapOverride ?? () => _showFullscreen(context),
      child: heroTag != null ? Hero(tag: heroTag!, child: preview) : preview,
    );
  }

  Future<void> _showFullscreen(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      builder: (_) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Hero(
                tag: heroTag ?? imagePath,
                child: InteractiveViewer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24.r),
                    child: PreviewImageBody(
                      imagePath: imagePath,
                      networkUrl: networkUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
