import 'package:dio/dio.dart';

/// Extracts a user-friendly error message from a DioException.
/// Handles common API shapes like {errors: []}, {message: ''}, or string bodies.
String? extractDioErrorMessage(DioException e) {
  final message = _extractFromData(e.response?.data);
  if (message != null && message.isNotEmpty) {
    return message;
  }

  final statusMessage = e.response?.statusMessage;
  if (statusMessage != null && statusMessage.isNotEmpty) {
    return statusMessage;
  }

  final dioMessage = e.message;
  if (dioMessage != null && dioMessage.isNotEmpty) {
    return dioMessage;
  }

  return null;
}

String? _extractFromData(dynamic data) {
  if (data is Map<String, dynamic>) {
    final errors = _stringFromErrors(data['errors']);
    if (errors != null) return errors;

    final message = data['message'] ?? data['error'] ?? data['detail'];
    if (message is String && message.trim().isNotEmpty) {
      return message.trim();
    }

    final nested = data['data'];
    final nestedMessage = _extractFromData(nested);
    if (nestedMessage != null) return nestedMessage;
  } else if (data is List) {
    final messages = data
        .whereType<String>()
        .map((msg) => msg.trim())
        .where((msg) => msg.isNotEmpty)
        .toList();
    if (messages.isNotEmpty) {
      return messages.join('\n');
    }
  } else if (data is String) {
    final message = data.trim();
    if (message.isNotEmpty && !_looksLikeHtml(message)) return message;
  }
  return null;
}

String? _stringFromErrors(dynamic errors) {
  if (errors is List) {
    final messages = errors
        .whereType<String>()
        .map((msg) => msg.trim())
        .where((msg) => msg.isNotEmpty)
        .toList();
    if (messages.isNotEmpty) {
      return messages.join('\n');
    }
  } else if (errors is String && errors.trim().isNotEmpty) {
    return errors.trim();
  }
  return null;
}

bool _looksLikeHtml(String text) {
  final lower = text.toLowerCase();
  return lower.contains('<html') ||
      lower.contains('<!doctype') ||
      lower.contains('<head') ||
      lower.contains('<body') ||
      lower.contains('</html>');
}
