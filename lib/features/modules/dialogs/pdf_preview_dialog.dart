import 'dart:io';
import 'dart:typed_data';

import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/base_page_with_toolbar.dart';
import 'package:academy_2_app/app/view/circular_progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfPreviewDialog extends StatefulWidget {
  const PdfPreviewDialog(
      {super.key, required this.title, required this.pdfUrl});

  final String title;
  final String pdfUrl;

  @override
  State<PdfPreviewDialog> createState() => _PdfPreviewDialogState();
}

class _PdfPreviewDialogState extends State<PdfPreviewDialog> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  Uint8List? _pdfData;
  bool _loading = true;
  String? _error;
  int _currentPage = 1;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  Future<void> _loadPdf() async {
    try {
      final url = widget.pdfUrl;
      final isLocal = url.startsWith('file://') || url.startsWith('/');

      if (isLocal) {
        final file =
            url.startsWith('file://') ? File(Uri.parse(url).path) : File(url);
        if (!file.existsSync()) {
          setState(() {
            _error = 'File not found';
            _loading = false;
          });
          return;
        }
        _pdfData = await file.readAsBytes();
      } else {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode != 200) {
          if (mounted) {
            setState(() {
              _error = 'Failed to load PDF: ${response.statusCode}';
              _loading = false;
            });
          }
          return;
        }
        _pdfData = response.bodyBytes;
      }

      if (!mounted) return;

      setState(() => _loading = false);
    } catch (e) {
      debugPrint('Error loading PDF: $e');
      if (mounted) {
        setState(() {
          _error = 'Error loading PDF: $e';
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BasePageWithToolbar(
        stickChildrenToBottom: true,
        showBackButton: true,
        paddingBottom: 20.w,
        title: widget.title,
        children: [
          SizedBox(height: 16.h),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return Expanded(
        child: Center(child: CircularProgressWidget()),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error,
                color: AppColors.contentError(context), size: 48.w),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: AppTextStyles.b2(context)
                  .copyWith(color: AppColors.contentError(context)),
            ),
          ],
        ),
      );
    }

    if (_pdfData == null) {
      return Center(
        child: Text('No PDF data', style: AppTextStyles.b2(context)),
      );
    }

    return Expanded(
      child: SfPdfViewer.memory(
        _pdfData!,
        controller: _pdfViewerController,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        enableDoubleTapZooming: true,
        onDocumentLoaded: (PdfDocumentLoadedDetails details) {
          setState(() {
            _totalPages = details.document.pages.count;
          });
        },
        onPageChanged: (PdfPageChangedDetails details) {
          setState(() {
            _currentPage = details.newPageNumber;
          });
        },
      ),
    );
  }
}
