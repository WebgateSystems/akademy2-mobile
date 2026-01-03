class Api {
  // static const String baseUploadUrl = 'https://akademy.edu.pl';
  static const String baseUploadUrl = 'https://test.akademy.edu.pl';

  static const String baseUrl = '$baseUploadUrl/api';

  static String get normalizedBaseUrl =>
      baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';

  static String privacyPolicyPlUrl =
      'https://cdn.akademy.edu.pl/privacy-policy-pl.html';
  static String privacyPolicyEnUrl =
      'https://cdn.akademy.edu.pl/privacy-policy-en.html';
}
