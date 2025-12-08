import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PdfCacheService {
  PdfCacheService._();
  static final PdfCacheService instance = PdfCacheService._();

  final Map<String, Uint8List> _cache = {};
  final Map<String, Future<Uint8List?>> _loadingFutures = {};

  Future<Uint8List?> getPdfData(String url) async {
    if (_cache.containsKey(url)) {
      return _cache[url];
    }

    if (_loadingFutures.containsKey(url)) {
      return _loadingFutures[url];
    }

    final future = _loadPdf(url);
    _loadingFutures[url] = future;

    try {
      final data = await future;
      if (data != null) {
        _cache[url] = data;
      }
      return data;
    } finally {
      _loadingFutures.remove(url);
    }
  }

  Future<Uint8List?> _loadPdf(String url) async {
    try {
      final isLocal = url.startsWith('file://') || url.startsWith('/');

      if (isLocal) {
        final file =
            url.startsWith('file://') ? File(Uri.parse(url).path) : File(url);
        if (!file.existsSync()) {
          return null;
        }
        return await file.readAsBytes();
      } else {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          return response.bodyBytes;
        }
        debugPrint('PDF load failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error loading PDF: $e');
      return null;
    }
  }

  bool isCached(String url) => _cache.containsKey(url);

  void clearUrl(String url) => _cache.remove(url);

  void clearAll() => _cache.clear();
}
