class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const session = 'v1/session';
  static const authRefresh = 'v1/auth/refresh';
  static const authLogout = 'v1/auth/logout';
  static const forgotPassword = 'v1/passwords/forgot';

  // Registration
  static const registerFlow = 'v1/register/flow';
  static const registerProfile = 'v1/register/profile';
  static const registerVerifyPhone = 'v1/register/verify_phone';
  static const registerSetPin = 'v1/register/set_pin';
  static const registerConfirmPin = 'v1/register/confirm_pin';

  // Students
  static const studentDashboard = 'v1/student/dashboard';
  static String studentSubject(String subjectId) =>
      'v1/student/subjects/$subjectId';
  static String studentLearningModule(String moduleId) =>
      'v1/student/learning_modules/$moduleId';
  static const studentQuizResults = 'v1/student/quiz_results';
  static const studentEnrollmentsJoin = 'v1/student/enrollments/join';
  static String studentEnrollmentStatus(String requestId) =>
      'v1/student/enrollments/join/$requestId/status';
  static String studentEnrollmentCancel(String requestId) =>
      'v1/student/enrollments/$requestId/cancel';
  static String quizCertificates(String requestId) =>
      'v1/certificates/$requestId/download';

  // Videos
  static const studentVideos = 'v1/student/videos';
  static const studentVideosMy = 'v1/student/videos/my';
  static const studentVideoSubjects = 'v1/student/videos/subjects';
  static String studentVideo(String id) => 'v1/student/videos/$id';
  static String studentVideoLike(String id) => 'v1/student/videos/$id/like';

  // Catalog
  static const subjects = 'v1/subjects';
  static const modules = 'v1/modules';
  static const contents = 'v1/contents';
  static const videos = 'v1/videos';
  static String video(String id) => 'v1/videos/$id';

  // Account & classes
  static const accountUpdate = 'v1/account/update';
  static const accountDelete = 'v1/account/delete';
  static const classesJoin = 'v1/classes/join';
  static String classesJoinStatus(String requestId) =>
      'v1/classes/join/$requestId/status';

  // Management/profile
  static String managementStudent(String userId) =>
      '/api/v1/management/students/$userId';
  static String student(String userId) => 'v1/students/$userId';
}
