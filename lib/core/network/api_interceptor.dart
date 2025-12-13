import 'package:dio/dio.dart';

import 'api_endpoints.dart';
import 'backend.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final path = _normalizePath(options.path);

    if (path.startsWith('v1/')) {
      Response? resp;

      switch (path) {
        case ApiEndpoints.session:
          resp = await _sessionLogin(options);
          break;
        case ApiEndpoints.authRefresh:
          resp = await _authRefresh(options);
          break;
        case ApiEndpoints.authLogout:
          resp = await _authLogout(options);
          break;
        case ApiEndpoints.subjects:
          resp = await _getSubjects(options);
          break;
        case ApiEndpoints.modules:
          resp = await _getModules(options);
          break;
        case ApiEndpoints.contents:
          resp = await _getContents(options);
          break;
        case ApiEndpoints.videos:
        case ApiEndpoints.studentVideos:
          resp = await _videos(options);
          break;
        case ApiEndpoints.studentVideosMy:
          resp = await _videos(options);
          break;
        case ApiEndpoints.accountUpdate:
          resp = await _accountUpdate(options);
          break;
        case ApiEndpoints.accountDelete:
          resp = await _accountDelete(options);
          break;
        case ApiEndpoints.classesJoin:
          resp = await _join(options);
          break;
        default:
          if (path.startsWith('${ApiEndpoints.classesJoin}/') &&
              path.endsWith('/status')) {
            resp = await _joinStatus(options);
          } else if (path.startsWith('${ApiEndpoints.videos}/') &&
              options.method.toUpperCase() == 'DELETE') {
            resp = await _deleteVideo(options);
          }
          break;
      }

      if (resp != null) {
        return handler.resolve(resp);
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  Future<Response?> _sessionLogin(RequestOptions options) async {
    if (options.method.toUpperCase() != 'POST') return null;

    final body = options.data as Map<String, dynamic>?;
    final user = body?['user'] as Map<String, dynamic>?;
    final phone = user?['email'] as String? ?? '+48000000000';
    final pin = user?['password'] as String? ?? '0000';

    return Response(
      requestOptions: options,
      data: Backend.login(phone, pin),
      statusCode: 200,
    );
  }

  Future<Response?> _authRefresh(RequestOptions options) async {
    if (options.method.toUpperCase() != 'POST') return null;

    final body = options.data as Map<String, dynamic>?;
    final refreshToken = body?['refreshToken'] as String? ?? '';

    return Response(
      requestOptions: options,
      data: Backend.refresh(refreshToken),
      statusCode: 200,
    );
  }

  Future<Response?> _getSubjects(RequestOptions options) async {
    if (options.method.toUpperCase() != 'GET') return null;

    final updatedSince = options.queryParameters['updated_since'] as String?;
    return Response(
      requestOptions: options,
      data: Backend.getSubjects(updatedSince: updatedSince),
      statusCode: 200,
    );
  }

  Future<Response?> _getModules(RequestOptions options) async {
    if (options.method.toUpperCase() != 'GET') return null;

    final subjectId =
        options.queryParameters['subjectId'] as String? ?? 'subject-1';
    return Response(
      requestOptions: options,
      data: Backend.getModules(subjectId),
      statusCode: 200,
    );
  }

  Future<Response?> _getContents(RequestOptions options) async {
    if (options.method.toUpperCase() != 'GET') return null;

    final moduleId =
        options.queryParameters['moduleId'] as String? ?? 'module-subject-1-1';
    return Response(
      requestOptions: options,
      data: Backend.getContents(moduleId),
      statusCode: 200,
    );
  }

  Future<Response?> _videos(RequestOptions options) async {
    final method = options.method.toUpperCase();
    if (method == 'GET') {
      final subjectId = options.queryParameters['subject_id'] as String? ??
          options.queryParameters['subjectId'] as String?;
      final q = options.queryParameters['query'] as String? ??
          options.queryParameters['q'] as String?;
      final page = int.tryParse('${options.queryParameters['page'] ?? 1}') ?? 1;
      var perPage =
          int.tryParse('${options.queryParameters['per_page'] ?? 20}') ?? 20;

      final response =
          Backend.getVideos(subjectId: subjectId, query: q)['videos']
              as List<dynamic>;
      if (perPage <= 0) {
        perPage = response.isEmpty ? 1 : response.length;
      }

      final start = (page - 1) * perPage;
      final paged = response.skip(start).take(perPage).toList();
      final totalPages =
          response.isEmpty ? 0 : (response.length / perPage).ceil();

      return Response(
        requestOptions: options,
        data: {
          'success': true,
          'data': paged,
          'meta': {
            'page': page,
            'per_page': perPage,
            'total': response.length,
            'total_pages': totalPages,
          },
        },
        statusCode: 200,
      );
    }
    if (method == 'POST') {
      return Response(
        requestOptions: options,
        data: Backend.addVideo(options.data as Map<String, dynamic>),
        statusCode: 200,
      );
    }
    return null;
  }

  Future<Response?> _authLogout(RequestOptions options) async {
    if (options.method.toUpperCase() != 'POST') return null;

    return Response(
      requestOptions: options,
      data: Backend.logout(),
      statusCode: 200,
    );
  }

  Future<Response?> _join(RequestOptions options) async {
    if (options.method.toUpperCase() != 'POST') return null;
    final code =
        (options.data as Map<String, dynamic>?)?['code'] as String? ?? '';
    return Response(
      requestOptions: options,
      data: Backend.join(code),
      statusCode: 200,
    );
  }

  Future<Response?> _joinStatus(RequestOptions options) async {
    if (options.method.toUpperCase() != 'GET') return null;
    final parts = _normalizePath(options.path)
        .split('/')
        .where((segment) => segment.isNotEmpty)
        .toList();
    final id = parts.length >= 4 ? parts[3] : '';
    return Response(
      requestOptions: options,
      data: Backend.joinStatus(id),
      statusCode: 200,
    );
  }

  Future<Response?> _accountUpdate(RequestOptions options) async {
    if (options.method.toUpperCase() != 'POST') return null;
    return Response(
      requestOptions: options,
      data: Backend.accountUpdate(),
      statusCode: 200,
    );
  }

  Future<Response?> _accountDelete(RequestOptions options) async {
    if (options.method.toUpperCase() != 'DELETE') return null;
    return Response(
      requestOptions: options,
      data: Backend.accountDelete(),
      statusCode: 200,
    );
  }

  Future<Response?> _deleteVideo(RequestOptions options) async {
    final parts = _normalizePath(options.path)
        .split('/')
        .where((segment) => segment.isNotEmpty)
        .toList();
    final id = parts.isNotEmpty ? parts.last : '';
    return Response(
      requestOptions: options,
      data: Backend.deleteVideo(id),
      statusCode: 200,
    );
  }

  String _normalizePath(String path) => path.replaceFirst(RegExp('^/+'), '');
}
