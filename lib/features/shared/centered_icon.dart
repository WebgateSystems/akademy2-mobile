import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:vector_graphics/vector_graphics.dart' as vg;
import 'package:vector_graphics_compiler/vector_graphics_compiler.dart'
    as vg_compiler;

class CenteredIcon extends StatefulWidget {
  const CenteredIcon({
    super.key,
    required this.url,
    required this.size,
    required this.placeholder,
    this.fallbackIcon = Icons.book,
    this.fallbackColor,
  });

  final String url;
  final double size;
  final Widget placeholder;
  final IconData fallbackIcon;
  final Color? fallbackColor;

  @override
  State<CenteredIcon> createState() => _CenteredIconState();
}

class _CenteredIconState extends State<CenteredIcon> {
  static final _memoryCache = <String, Uint8List?>{};

  bool _loading = true;
  _IconPreviewData? _previewData;

  @override
  void initState() {
    super.initState();
    _loadPreview();
  }

  @override
  void didUpdateWidget(covariant CenteredIcon oldWidget) {
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
        enableMaskingOptimizer: false,
        enableClippingOptimizer: false,
        enableOverdrawOptimizer: false,
      );
      final pictureInfo = await vg.vg.loadPicture(
        _MemoryBytesLoader(encoded),
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
      // ignore errors
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
    final fileName = safeName.isEmpty ? 'icon.svg' : safeName;
    return File('${dir.path}/subject_icons/$fileName');
  }

  Future<Rect> _getVisibleBounds(ui.Image image) async {
    final byteData =
        await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) {
      return Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
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
                    widget.fallbackIcon,
                    size: widget.size * 0.6,
                    color: widget.fallbackColor ?? Colors.grey,
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
