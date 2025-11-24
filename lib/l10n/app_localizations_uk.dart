// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Академія 2.0';

  @override
  String get loginTitle => 'Увійти';

  @override
  String get passwordField => 'Пароль';

  @override
  String get subjectsTitle => 'Предмети';

  @override
  String get joinTitle => 'Приєднання до класу';

  @override
  String get loading => 'Завантаження...';

  @override
  String get retry => 'Спробувати ще раз';

  @override
  String get noSubjects => 'Предметів поки немає';

  @override
  String get modulesTitle => 'Модулі';

  @override
  String get moduleSingleFlow => 'Послідовний потік';

  @override
  String get moduleMultiStep => 'Кілька етапів';

  @override
  String get moduleScreenTitle => 'Модуль';

  @override
  String get videoTitle => 'Відео';

  @override
  String get infographicTitle => 'Інфографіка';

  @override
  String get quizTitle => 'Тест';

  @override
  String get resultTitle => 'Результат';

  @override
  String get downloadsTitle => 'Завантаження';

  @override
  String get downloadsPlaceholder => 'Заглушка завантажень (M1)';

  @override
  String get profileTitle => 'Профіль';

  @override
  String get profilePlaceholder => 'Заглушка профілю (M1)';

  @override
  String inviteToken(Object token) {
    return 'Токен запрошення: $token';
  }

  @override
  String get createAnAccount => 'Створити обліковий запис';

  @override
  String get firstNameField => 'Ім’я';

  @override
  String get lastNameField => 'Прізвище';

  @override
  String get dateOfBirthField => 'Дата народження';

  @override
  String get emailField => 'Email';

  @override
  String get phoneField => 'Телефон';

  @override
  String get dateOfBirthHintField => 'DD.MM.YYYY';

  @override
  String get emailHintField => 'emily.corner@gmail.com';

  @override
  String get phoneHintField => '+48 XXX XXX XXX';

  @override
  String get iAgreeToReceive =>
      'Надаючи свою електронну адресу, я погоджуюся отримувати повідомлення від Академії 2.0. Я розумію, що можу відмовитися в будь-який час.';

  @override
  String get createAccountButton => 'Створити обліковий запис';
}
