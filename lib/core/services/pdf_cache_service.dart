import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Singleton service for caching PDF data to avoid multiple downloads
class PdfCacheService {
  PdfCacheService._();
  static final PdfCacheService instance = PdfCacheService._();

  final Map<String, Uint8List> _cache = {};
  final Map<String, Future<Uint8List?>> _loadingFutures = {};

  /// Get PDF data from cache or load it
  Future<Uint8List?> getPdfData(String url) async {
    // Return from cache if available
    if (_cache.containsKey(url)) {
      return _cache[url];
    }

    // If already loading, wait for the same future
    if (_loadingFutures.containsKey(url)) {
      return _loadingFutures[url];
    }

    // Start loading
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

  /// Check if PDF is already cached
  bool isCached(String url) => _cache.containsKey(url);

  /// Clear specific URL from cache
  void clearUrl(String url) => _cache.remove(url);

  /// Clear all cached PDFs
  void clearAll() => _cache.clear();
}
