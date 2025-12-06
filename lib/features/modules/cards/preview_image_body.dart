import 'dart:io';
import 'dart:typed_data';

import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/circular_progress_widget.dart';
import 'package:academy_2_app/core/services/pdf_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/svg.dart';

class PreviewImageBody extends StatefulWidget {
  const PreviewImageBody({
    super.key,
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
  Uint8List? _pdfData;
  bool _isLoadingPdf = false;
  bool _pdfLoadError = false;

  @override
  void initState() {
    super.initState();
    _loadPdfIfNeeded();
  }

  @override
  void didUpdateWidget(PreviewImageBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.networkUrl != widget.networkUrl) {
      _loadPdfIfNeeded();
    }
  }

  Future<void> _loadPdfIfNeeded() async {
    final url = widget.networkUrl;
    if (url == null || !url.toLowerCase().endsWith('.pdf')) return;

    setState(() {
      _isLoadingPdf = true;
      _pdfLoadError = false;
    });

    final data = await PdfCacheService.instance.getPdfData(url);

    if (mounted) {
      setState(() {
        _pdfData = data;
        _pdfLoadError = data == null;
        _isLoadingPdf = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.networkUrl != null &&
        widget.networkUrl!.toLowerCase().endsWith('.pdf')) {
      // Loading state
      if (_isLoadingPdf) {
        return Container(
          color: Colors.grey[200],
          child: const Center(child: CircularProgressWidget()),
        );
      }

      // Error state - show PDF icon
      if (_pdfLoadError || _pdfData == null) {
        return Container(
          color: Colors.grey[300],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.picture_as_pdf, size: 48, color: Colors.red[700]),
                const SizedBox(height: 8),
                Text(
                  'PDF',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Show PDF first page preview
      // Use Stack with transparent overlay to capture taps while showing PDF
      return ClipRRect(
        child: Stack(
          children: [
            PDFView(
              pdfData: _pdfData,
              enableSwipe: false,
              pageFling: false,
              autoSpacing: false,
              fitPolicy: FitPolicy.BOTH,
              onError: (error) {
                debugPrint('PDF preview error: $error');
              },
            ),
            // Transparent overlay to pass taps to parent GestureDetector
            Positioned.fill(
              child: Container(color: Colors.transparent),
            ),
          ],
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
