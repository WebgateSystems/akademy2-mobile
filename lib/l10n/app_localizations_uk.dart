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
  String get profileTitle => 'Акаунт';

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

  @override
  String get verifyPhoneTitle => 'Підтвердіть номер телефону';

  @override
  String verifyPhoneSubtitle(String phone) {
    return 'Ми надіслали 4-значний код на ваш телефон\n$phone.';
  }

  @override
  String get verifyPhoneInvalidCode =>
      'Неправильний код підтвердження. Запросіть новий.';

  @override
  String verifyPhoneResendCountdown(String seconds) {
    return 'Надіслати ще раз (через 0:$seconds)';
  }

  @override
  String get verifyPhoneResendButton => 'Надіслати код ще раз';

  @override
  String get verifyPhoneCodeResentSnack => 'Код повторно надіслано';

  @override
  String get verifyYourAccount => 'Підтвердіть свій акаунт';

  @override
  String verifyEmailMessage(Object email) {
    return 'Ми надіслали підтверджувальне посилання на $email. Відкрийте пошту та перейдіть за посиланням, щоб завершити реєстрацію.';
  }

  @override
  String get checkSpam => 'Не знайшли? Перевірте папку «Спам».';

  @override
  String get next => 'Далі';

  @override
  String get pinCreateTitle => 'Придумайте 4-значний код';

  @override
  String get pinCreateSubtitle =>
      'Цей код буде потрібен для входу в застосунок Academy 2.0.';

  @override
  String get pinConfirmTitle => 'Повторіть 4-значний код';

  @override
  String get pinConfirmSubtitle => 'Підтвердіть свій код.';

  @override
  String get pinConfirmMismatchSubtitle =>
      'Коди не збігаються. Спробуйте ще раз.';

  @override
  String get pinMismatchInline => 'Коди не збігаються';

  @override
  String get enableBiometricTitle => 'Увімкнути біометричний вхід';

  @override
  String get enableBiometricSubtitle =>
      'Дозвольте вхід за відбитком пальця або скануванням обличчя, щоб швидко й безпечно отримувати доступ до застосунку.';

  @override
  String get enableBiometricEnable => 'Увімкнути';

  @override
  String get enableBiometricNotNow => 'Не зараз';

  @override
  String get enableBiometricSelectOption => 'Виберіть принаймні один варіант';

  @override
  String get enableBiometricNotAvailable =>
      'Біометрична автентифікація недоступна на цьому пристрої.';

  @override
  String enableBiometricFailed(String error) {
    return 'Не вдалося увімкнути біометрію: $error';
  }

  @override
  String get joinGroupTitle => 'Приєднайтеся до своєї групи';

  @override
  String get joinGroupSubtitle =>
      'Останній крок. Введіть код або відскануйте QR-код, щоб приєднатися 🚀';

  @override
  String get joinGroupHint => 'PPSW1286GR';

  @override
  String get joinGroupCodeCaptured => 'Код зчитано';

  @override
  String joinGroupSubmitError(String error) {
    return 'Не вдалося надіслати код: $error';
  }

  @override
  String get waitApprovalTitle => 'Зачекайте на підтвердження вчителя';

  @override
  String get waitApprovalSubtitle =>
      'Ваш учитель незабаром розгляне ваш запит — трошки зачекайте!';

  @override
  String get waitApprovalRetryButton => 'Надіслати ще раз';

  @override
  String get bottomNavCourses => 'Курси';

  @override
  String get bottomNavSchoolVideos => 'Шкільні відео';

  @override
  String get bottomNavAccount => 'Акаунт';

  @override
  String get coursesTitle => 'Курси';

  @override
  String get chooseSubjectSubtitle =>
      'Обери предмет, щоб розпочати свою навчальну подорож!';

  @override
  String get schoolVideosTitle => 'Шкільні відео';

  @override
  String get schoolVideosSubtitle =>
      'Дивіться відео, створені учнями, і додавайте свої.';

  @override
  String get schoolVideosFilterAll => 'Усі';

  @override
  String get schoolVideosSearchHint => 'Шукати відео';

  @override
  String get schoolVideosEmpty => 'Відео ще немає.';

  @override
  String get schoolVideosGroupUnknown => 'Інші відео';

  @override
  String schoolVideosStatusLabel(String status) {
    return 'Статус: $status';
  }

  @override
  String get schoolVideosStatusPending => 'Очікує на підтвердження';

  @override
  String get schoolVideosStatusApproved => 'Схвалено';

  @override
  String get schoolVideosPendingTitle => 'Зачекайте на підтвердження вчителя';

  @override
  String get schoolVideosPendingMessage =>
      'Ваш учитель незабаром розгляне ваш запит — трошки зачекайте!';

  @override
  String schoolVideosError(String error) {
    return 'Помилка: $error';
  }

  @override
  String get profileFirstName => 'Ім\'я';

  @override
  String get profileLastName => 'Прізвище';

  @override
  String get profileDob => 'Дата народження';

  @override
  String get profileEmail => 'Email';

  @override
  String get profilePhone => 'Телефон';

  @override
  String get profilePin => 'PIN код';

  @override
  String get profileTheme => 'Тема';

  @override
  String get profileLanguage => 'Мова';

  @override
  String get profileThemeLight => 'Світла';

  @override
  String get profileThemeDark => 'Темна';

  @override
  String get profileLangEn => 'Англійська';

  @override
  String get profileLangUk => 'Українська';

  @override
  String get profileLangPl => 'Польська';

  @override
  String get profileSaveButton => 'Зберегти зміни';

  @override
  String get profileLogoutButton => 'Вийти';

  @override
  String get profileDeleteButton => 'Видалити акаунт';

  @override
  String get profileLogoutTitle => 'Вийти';

  @override
  String get profileLogoutMessage => 'Вийти з акаунту?';

  @override
  String get profileLogoutCancel => 'Скасувати';

  @override
  String get profileLogoutConfirm => 'Вийти';

  @override
  String get profileSaveSuccess => 'Профіль збережено';

  @override
  String profileSaveFailed(String error) {
    return 'Не вдалося зберегти: $error';
  }

  @override
  String profileDeleteFailed(String error) {
    return 'Не вдалося видалити: $error';
  }

  @override
  String get unverifiedEmailAddress => 'Неперевірена адреса електронної пошти.';

  @override
  String get unverifiedPhoneNubmer => 'Неперевірений номер телефону.';
}
