class Api {
  // Replace with dart-define in CI / runtime
  static const String baseUploadUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://test.akademy.edu.pl',
  );

  // Replace with dart-define in CI / runtime
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://test.akademy.edu.pl/api',
  );

  static String get normalizedBaseUrl =>
      baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
}
