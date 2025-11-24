// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Academy 2.0';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get emailField => 'Email';

  @override
  String get passwordField => 'Password';

  @override
  String get subjectsTitle => 'Subjects';

  @override
  String get joinTitle => 'Join class';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get noSubjects => 'No subjects yet';

  @override
  String get modulesTitle => 'Modules';

  @override
  String get moduleSingleFlow => 'Single flow';

  @override
  String get moduleMultiStep => 'Multi-step';

  @override
  String get moduleScreenTitle => 'Module';

  @override
  String get videoTitle => 'Video';

  @override
  String get infographicTitle => 'Infographic';

  @override
  String get quizTitle => 'Quiz';

  @override
  String get resultTitle => 'Result';

  @override
  String get downloadsTitle => 'Downloads';

  @override
  String get downloadsPlaceholder => 'Downloads placeholder (M1)';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profilePlaceholder => 'Profile placeholder (M1)';

  @override
  String inviteToken(Object token) {
    return 'Invite token: $token';
  }
}
