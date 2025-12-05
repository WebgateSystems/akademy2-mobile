import 'dart:io';

import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/circular_progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PreviewImageBody extends StatefulWidget {
  const PreviewImageBody({
    required this.imagePath,
    this.networkUrl,
    this.fit = BoxFit.cover,
  });

  final String imagePath;
  final String? networkUrl;
  final BoxFit fit;

  @override
  State<PreviewImageBody> createState() => _PreviewImageBodyState();
}

class _PreviewImageBodyState extends State<PreviewImageBody> {
  @override
  Widget build(BuildContext context) {
    if (widget.networkUrl != null &&
        widget.networkUrl!.toLowerCase().endsWith('.pdf')) {
      // For PDF show a simple preview with PDF icon
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Icon(
            Icons.picture_as_pdf,
            size: 96,
          ),
        ),
      );
    }

    if (widget.networkUrl != null && widget.networkUrl!.isNotEmpty) {
      final url = widget.networkUrl!;
      final isLocal = url.startsWith('file://') || url.startsWith('/');
      final isSvg = url.toLowerCase().endsWith('.svg');

      if (isLocal) {
        final file =
            url.startsWith('file://') ? File(Uri.parse(url).path) : File(url);
        if (!file.existsSync()) {
          return Image.asset(widget.imagePath, fit: widget.fit);
        }
        if (isSvg) {
          return SvgPicture.file(
            file,
            fit: widget.fit,
            placeholderBuilder: (_) =>
                const Center(child: CircularProgressWidget()),
          );
        }
        return Image.file(
          file,
          fit: widget.fit,
          errorBuilder: (_, __, ___) =>
              Image.asset(widget.imagePath, fit: widget.fit),
        );
      }

      if (isSvg) {
        return SvgPicture.network(
          url,
          fit: widget.fit,
          placeholderBuilder: (_) =>
              const Center(child: CircularProgressWidget()),
        );
      }

      return Image.network(
        url,
        fit: widget.fit,
        errorBuilder: (_, __, ___) {
          return Image.asset(widget.imagePath, fit: widget.fit);
        },
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: AppColors.surfacePrimary(context),
            child: const Center(child: CircularProgressWidget()),
          );
        },
      );
    }

    return Image.asset(widget.imagePath, fit: widget.fit);
  }
}
