import 'package:dio/dio.dart';

import 'fake_backend.dart';

/// MockApiInterceptor intercepts requests to /v1/* and returns mock JSON responses.
/// This allows local testing without a real backend.
class MockApiInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path.startsWith('/v1/')) {
      Response? mock;

      switch (options.path) {
        case '/v1/auth/login':
          mock = await _mockAuthLogin(options);
          break;
        case '/v1/auth/refresh':
          mock = await _mockAuthRefresh(options);
          break;
        case '/v1/auth/logout':
          mock = await _mockAuthLogout(options);
          break;
        case '/v1/subjects':
          mock = await _mockGetSubjects(options);
          break;
        case '/v1/modules':
          mock = await _mockGetModules(options);
          break;
        case '/v1/contents':
          mock = await _mockGetContents(options);
          break;
        case '/v1/videos':
          mock = await _mockVideos(options);
          break;
        case '/v1/account/update':
          mock = await _mockAccountUpdate(options);
          break;
        case '/v1/account/delete':
          mock = await _mockAccountDelete(options);
          break;
        case '/v1/classes/join':
          mock = await _mockJoin(options);
          break;
        default:
          if (options.path.startsWith('/v1/classes/join/') &&
              options.path.endsWith('/status')) {
            mock = await _mockJoinStatus(options);
          } else if (options.path.startsWith('/v1/videos/') &&
              options.method.toUpperCase() == 'DELETE') {
            mock = await _mockDeleteVideo(options);
          }
          break;
      }

      if (mock != null) {
        return handler.resolve(mock);
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

  Future<Response?> _mockAuthLogin(RequestOptions options) async {
    if (options.method.toUpperCase() != 'POST') return null;

    final body = options.data as Map<String, dynamic>?;
    final email = body?['email'] as String? ?? 'test@example.com';
    final password = body?['password'] as String? ?? 'pass';

    return Response(
      requestOptions: options,
      data: FakeBackend.mockLogin(email, password),
      statusCode: 200,
    );
  }

  Future<Response?> _mockAuthRefresh(RequestOptions options) async {
    if (options.method.toUpperCase() != 'POST') return null;

    final body = options.data as Map<String, dynamic>?;
    final refreshToken = body?['refreshToken'] as String? ?? '';

    return Response(
      requestOptions: options,
      data: FakeBackend.mockRefresh(refreshToken),
      statusCode: 200,
    );
  }

  Future<Response?> _mockGetSubjects(RequestOptions options) async {
    if (options.method.toUpperCase() != 'GET') return null;

    final updatedSince = options.queryParameters['updated_since'] as String?;
    return Response(
      requestOptions: options,
      data: FakeBackend.mockSubjects(updatedSince: updatedSince),
      statusCode: 200,
    );
  }

  Future<Response?> _mockGetModules(RequestOptions options) async {
    if (options.method.toUpperCase() != 'GET') return null;

    final subjectId =
        options.queryParameters['subjectId'] as String? ?? 'subject-1';
    return Response(
      requestOptions: options,
      data: FakeBackend.mockModules(subjectId),
      statusCode: 200,
    );
  }

  Future<Response?> _mockGetContents(RequestOptions options) async {
    if (options.method.toUpperCase() != 'GET') return null;

    final moduleId =
        options.queryParameters['moduleId'] as String? ?? 'module-subject-1-1';
    return Response(
      requestOptions: options,
      data: FakeBackend.mockContents(moduleId),
      statusCode: 200,
    );
  }

  Future<Response?> _mockVideos(RequestOptions options) async {
    final method = options.method.toUpperCase();
    if (method == 'GET') {
      final subjectId = options.queryParameters['subjectId'] as String?;
      final q = options.queryParameters['q'] as String?;
      return Response(
        requestOptions: options,
        data: FakeBackend.mockVideos(subjectId: subjectId, query: q),
        statusCode: 200,
      );
    }
    if (method == 'POST') {
      return Response(
        requestOptions: options,
        data: FakeBackend.mockAddVideo(options.data as Map<String, dynamic>),
        statusCode: 200,
      );
    }
    return null;
  }

  Future<Response?> _mockAuthLogout(RequestOptions options) async {
    if (options.method.toUpperCase() != 'POST') return null;

    return Response(
      requestOptions: options,
      data: FakeBackend.mockLogout(),
      statusCode: 200,
    );
  }

  Future<Response?> _mockJoin(RequestOptions options) async {
    if (options.method.toUpperCase() != 'POST') return null;
    final code = (options.data as Map<String, dynamic>?)?['code'] as String? ?? '';
    return Response(
      requestOptions: options,
      data: FakeBackend.mockJoin(code),
      statusCode: 200,
    );
  }

  Future<Response?> _mockJoinStatus(RequestOptions options) async {
    if (options.method.toUpperCase() != 'GET') return null;
    final parts = options.path.split('/');
    final id = parts.length >= 6 ? parts[4] : '';
    return Response(
      requestOptions: options,
      data: FakeBackend.mockJoinStatus(id),
      statusCode: 200,
    );
  }

  Future<Response?> _mockAccountUpdate(RequestOptions options) async {
    if (options.method.toUpperCase() != 'POST') return null;
    return Response(
      requestOptions: options,
      data: FakeBackend.mockAccountUpdate(),
      statusCode: 200,
    );
  }

  Future<Response?> _mockAccountDelete(RequestOptions options) async {
    if (options.method.toUpperCase() != 'DELETE') return null;
    return Response(
      requestOptions: options,
      data: FakeBackend.mockAccountDelete(),
      statusCode: 200,
    );
  }

  Future<Response?> _mockDeleteVideo(RequestOptions options) async {
    final parts = options.path.split('/');
    final id = parts.isNotEmpty ? parts.last : '';
    return Response(
      requestOptions: options,
      data: FakeBackend.mockDeleteVideo(id),
      statusCode: 200,
    );
  }
}
