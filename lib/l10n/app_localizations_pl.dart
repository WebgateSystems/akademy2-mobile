// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Akademia 2.0';

  @override
  String get loginTitle => 'Zaloguj się';

  @override
  String get emailField => 'Email';

  @override
  String get passwordField => 'Hasło';

  @override
  String get subjectsTitle => 'Przedmioty';

  @override
  String get joinTitle => 'Dołącz do klasy';

  @override
  String get loading => 'Ładowanie...';

  @override
  String get retry => 'Spróbuj ponownie';

  @override
  String get noSubjects => 'Brak przedmiotów';

  @override
  String get modulesTitle => 'Moduły';

  @override
  String get moduleSingleFlow => 'Tryb pojedynczy';

  @override
  String get moduleMultiStep => 'Wiele kroków';

  @override
  String get moduleScreenTitle => 'Moduł';

  @override
  String get videoTitle => 'Wideo';

  @override
  String get infographicTitle => 'Infografika';

  @override
  String get quizTitle => 'Quiz';

  @override
  String get resultTitle => 'Wynik';

  @override
  String get downloadsTitle => 'Pobrane';

  @override
  String get downloadsPlaceholder => 'Ekran pobrań (M1)';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profilePlaceholder => 'Ekran profilu (M1)';

  @override
  String inviteToken(Object token) {
    return 'Token zaproszenia: $token';
  }
}
