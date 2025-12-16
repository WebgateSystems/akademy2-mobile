import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:downloadsfolder/downloadsfolder.dart';
import 'package:path_provider/path_provider.dart';

import '../network/api_endpoints.dart';
import '../network/dio_provider.dart';

class StoragePermissionDeniedException implements Exception {
  final String? message;

  StoragePermissionDeniedException([this.message]);

  @override
  String toString() => message ?? 'Storage permission denied';
}

class CertificateDownloadException implements Exception {
  final String message;

  CertificateDownloadException(this.message);

  @override
  String toString() => message;
}

class CertificateService {
  CertificateService({Dio? dio}) : _dio = dio ?? DioProviderSingleton.dio;

  final Dio _dio;

  Future<File> downloadCertificate(String certificateId) async {
    if (certificateId.isEmpty) {
      throw CertificateDownloadException('Certificate id is missing');
    }

    final response = await _dio.get<Uint8List>(
      ApiEndpoints.quizCertificates(certificateId),
      options: Options(responseType: ResponseType.bytes),
    );

    final status = response.statusCode ?? 0;
    final data = response.data;
    if (status >= 200 && status < 300 && data != null) {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/certificate_$certificateId.pdf');
      await tempFile.writeAsBytes(data, flush: true);
      final fileName = 'certificate_$certificateId.pdf';
      final copied = await copyFileIntoDownloadFolder(tempFile.path, fileName);
      if (copied != true) {
        throw CertificateDownloadException(
          'Failed to save certificate to the downloads folder',
        );
      }
      final downloadsDir = await getDownloadDirectory();
      return File('${downloadsDir.path}/$fileName');
    }

    final error = _extractErrorMessage(response.data);
    throw CertificateDownloadException(
      error ?? 'Failed to download certificate (${response.statusCode ?? 0})',
    );
  }

  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;
    if (data is String) {
      return data;
    }
    if (data is List<int>) {
      try {
        final decoded = utf8.decode(data);
        final json = jsonDecode(decoded);
        if (json is Map<String, dynamic>) {
          return json['message'] as String? ?? json['error'] as String?;
        }
        return decoded;
      } catch (_) {
        return null;
      }
    }
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ?? data['error'] as String?;
    }
    return null;
  }
}
