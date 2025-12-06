import 'dart:typed_data';

import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/base_page_with_toolbar.dart';
import 'package:academy_2_app/app/view/circular_progress_widget.dart';
import 'package:academy_2_app/core/services/pdf_cache_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PdfPreviewDialog extends StatefulWidget {
  const PdfPreviewDialog({
    super.key,
    required this.title,
    required this.pdfUrl,
  });

  final String title;
  final String pdfUrl;

  @override
  State<PdfPreviewDialog> createState() => _PdfPreviewDialogState();
}

class _PdfPreviewDialogState extends State<PdfPreviewDialog> {
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

  Future<void> _loadPdf() async {
    final data = await PdfCacheService.instance.getPdfData(widget.pdfUrl);

    if (!mounted) return;

    if (data == null) {
      setState(() {
        _error = 'Failed to load PDF';
        _loading = false;
      });
    } else {
      setState(() {
        _pdfData = data;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BasePageWithToolbar(
        title: widget.title,
        showBackButton: true,
        stickChildrenToBottom: true,
        paddingBottom: 20.w,
        rightIcon: Text(
          '$_currentPage / $_totalPages',
          style: AppTextStyles.b2(context),
        ),
        children: [
          SizedBox(height: 16.h),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return Expanded(child: const Center(child: CircularProgressWidget()));
    }

    if (_error != null) {
      return Expanded(
        child: Center(
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
        ),
      );
    }

    if (_pdfData == null) {
      return Expanded(
        child: Center(
          child: Text('No PDF data', style: AppTextStyles.b2(context)),
        ),
      );
    }

    return Expanded(
      child: PDFView(
        pdfData: _pdfData,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: true,
        fitPolicy: FitPolicy.BOTH,
        backgroundColor: Colors.transparent,
        onRender: (pages) {
          setState(() {
            _totalPages = pages ?? 0;
          });
        },
        onPageChanged: (page, total) {
          setState(() {
            _currentPage = (page ?? 0) + 1;
            _totalPages = total ?? 0;
          });
        },
        onError: (error) {
          debugPrint('PDF error: $error');
        },
      ),
    );
  }
}
