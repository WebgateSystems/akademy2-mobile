import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/circular_progress_widget.dart';
import 'package:academy_2_app/core/services/student_api_service.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:vector_graphics/vector_graphics.dart' as vg;
import 'package:vector_graphics_compiler/vector_graphics_compiler.dart'
    as vg_compiler;

class SubjectTile extends StatelessWidget {
  final DashboardSubject subject;
  final VoidCallback? onTap;

  const SubjectTile({
    super.key,
    required this.subject,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final completed = subject.completionRate > 0 && subject.averageScore > 0;
    final cardColor = AppColors.subjectCardColor(context, subject, completed);
    final rezultCardColor = AppColors.subjectCardColor(context, subject, false);

    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.w),
            child: Card(
              elevation: 0,
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _SubjectIcon(url: subject.iconUrl),
                    SizedBox(height: 12.h),
                    Center(
                      child: Text(
                        subject.title,
                        style: AppTextStyles.h4(context),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (completed)
            Positioned(
              left: 16.r,
              top: 0,
              child: ResultQuizWidget(
                bgColor: rezultCardColor,
                bestScore: subject.completionRate,
              ),
            ),
        ],
      ),
    );
  }
}

class ResultQuizWidget extends StatelessWidget {
  const ResultQuizWidget({
    super.key,
    required this.bgColor,
    required int bestScore,
  }) : _bestScore = bestScore;

  final int _bestScore;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        AppLocalizations.of(context)!.quizScoreLabel(_bestScore),
        style: AppTextStyles.h5(context).copyWith(
          color: AppColors.contentPrimary(context),
        ),
      ),
    );
  }
}

class _SubjectIcon extends StatelessWidget {
  const _SubjectIcon({
    this.url,
  });

  final String? url;

  @override
  Widget build(BuildContext context) {
    final size = 56.w;
    final bg = AppColors.surfaceIcon(context);
    final fullUrl = (url == null || url!.isEmpty) ? null : url;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: fullUrl == null
                ? Icon(
                    Icons.book,
                    size: size * 0.5,
                    color: AppColors.contentSecondary(context),
                  )
                : _CroppedSubjectIcon(
                    url: fullUrl,
                    placeholder: const CircularProgressWidget(),
                    size: size * 0.5,
                  ),
          ),
        ),
      ),
    );
  }
}

class _CroppedSubjectIcon extends StatefulWidget {
  const _CroppedSubjectIcon({
    required this.url,
    required this.placeholder,
    required this.size,
  });

  final String url;
  final Widget placeholder;
  final double size;

  @override
  State<_CroppedSubjectIcon> createState() => _CroppedSubjectIconState();
}

class _CroppedSubjectIconState extends State<_CroppedSubjectIcon> {
  static final _memoryCache = <String, Uint8List?>{};

  _IconPreviewData? _previewData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPreview();
  }

  @override
  void didUpdateWidget(covariant _CroppedSubjectIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _previewData?.dispose();
      _previewData = null;
      _loading = true;
      _loadPreview();
    }
  }

  @override
  void dispose() {
    _previewData?.dispose();
    super.dispose();
  }

  Future<void> _loadPreview() async {
    final data = await _createPreviewData();
    if (!mounted) {
      data?.dispose();
      return;
    }
    setState(() {
      _loading = false;
      _previewData?.dispose();
      _previewData = data;
    });
  }

  Future<_IconPreviewData?> _createPreviewData() async {
    final bytes = await _loadBytes(widget.url);
    if (bytes == null || bytes.isEmpty) return null;

    final lower = widget.url.toLowerCase();
    ui.Image image;
    if (lower.endsWith('.svg')) {
      final svgContent = utf8.decode(bytes, allowMalformed: true);
      final encoded = vg_compiler.encodeSvg(
        xml: svgContent,
        debugName: widget.url,
        theme: const vg_compiler.SvgTheme(),
        enableClippingOptimizer: false,
        enableMaskingOptimizer: false,
        enableOverdrawOptimizer: false,
      );
      final pictureInfo = await vg.vg.loadPicture(
        _MemoryBytesLoader(encoded.buffer.asUint8List()),
        null,
      );
      final width =
          (pictureInfo.size.width <= 0 ? 256 : pictureInfo.size.width).ceil();
      final height =
          (pictureInfo.size.height <= 0 ? 256 : pictureInfo.size.height).ceil();
      image = await pictureInfo.picture.toImage(width, height);
      pictureInfo.picture.dispose();
    } else {
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      image = frame.image;
      codec.dispose();
    }
    final bounds = await _getVisibleBounds(image);
    return _IconPreviewData(image, bounds);
  }

  Future<Uint8List?> _loadBytes(String url) async {
    if (_memoryCache.containsKey(url)) return _memoryCache[url];
    try {
      final file = await _localFileForUrl(url);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        _memoryCache[url] = bytes;
        return bytes;
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        _memoryCache[url] = response.bodyBytes;
        try {
          await file.parent.create(recursive: true);
          await file.writeAsBytes(response.bodyBytes, flush: true);
        } catch (_) {}
        return response.bodyBytes;
      }
    } catch (_) {
      // ignore
    }
    return null;
  }

  Future<File> _localFileForUrl(String url) async {
    final dir = await getApplicationDocumentsDirectory();
    final safeName = url
        .split('/')
        .where((segment) => segment.isNotEmpty)
        .last
        .replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final fileName = safeName.isEmpty ? 'subject_icon.svg' : safeName;
    return File('${dir.path}/subject_icons/$fileName');
  }

  Future<Rect> _getVisibleBounds(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) {
      return Rect.fromLTWH(
        0,
        0,
        image.width.toDouble(),
        image.height.toDouble(),
      );
    }
    final bytes = byteData.buffer.asUint8List();
    int minX = image.width;
    int minY = image.height;
    int maxX = -1;
    int maxY = -1;
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final alpha = bytes[(y * image.width + x) * 4 + 3];
        if (alpha > 16) {
          if (x < minX) minX = x;
          if (x > maxX) maxX = x;
          if (y < minY) minY = y;
          if (y > maxY) maxY = y;
        }
      }
    }

    if (maxX < minX || maxY < minY) {
      return Rect.fromLTWH(
        0,
        0,
        image.width.toDouble(),
        image.height.toDouble(),
      );
    }

    const padding = 6;
    final left = (minX - padding).clamp(0, image.width - 1);
    final top = (minY - padding).clamp(0, image.height - 1);
    final right = (maxX + padding).clamp(0, image.width - 1);
    final bottom = (maxY + padding).clamp(0, image.height - 1);
    return Rect.fromLTRB(
      left.toDouble(),
      top.toDouble(),
      right.toDouble(),
      bottom.toDouble(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: _loading
          ? Center(
              child: SizedBox.square(
                dimension: widget.size * 0.5,
                child: widget.placeholder,
              ),
            )
          : (_previewData == null
              ? Center(
                  child: Icon(
                    Icons.book,
                    size: widget.size * 0.6,
                    color: AppColors.contentSecondary(context),
                  ),
                )
              : CustomPaint(
                  painter: _CroppedIconPainter(
                    data: _previewData!,
                    size: widget.size,
                  ),
                )),
    );
  }
}

class _IconPreviewData {
  _IconPreviewData(this.image, this.bounds);

  final ui.Image image;
  final Rect bounds;

  void dispose() => image.dispose();
}

class _CroppedIconPainter extends CustomPainter {
  _CroppedIconPainter({
    required this.data,
    required this.size,
  });

  final _IconPreviewData data;
  final double size;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final dest = Rect.fromLTWH(0, 0, size, size);
    final paint = Paint()..isAntiAlias = true;
    canvas.drawImageRect(data.image, data.bounds, dest, paint);
  }

  @override
  bool shouldRepaint(covariant _CroppedIconPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.size != size;
  }
}

class _MemoryBytesLoader extends vg.BytesLoader {
  const _MemoryBytesLoader(this.bytes);

  final Uint8List bytes;

  @override
  Future<ByteData> loadBytes(BuildContext? context) =>
      Future.value(bytes.buffer.asByteData());

  @override
  Object cacheKey(BuildContext? context) => this;

  @override
  String toString() => 'InMemoryBytesLoader(${bytes.length} bytes)';
}
