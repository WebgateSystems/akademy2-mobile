import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';


class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Академія 2.0';

  @override
  String get loginTitle => 'Увійти';

  @override
  String get loginPhoneRequired => 'Введіть свій номер телефону';

  @override
  String get loginPhoneInvalid => 'Некоректний номер телефону.';

  @override
  String get loginCreateAccountPrompt => 'Немає облікового запису?';

  @override
  String get loginCreateAccountCta => 'Створити акаунт';

  @override
  String loginFailed(String error) {
    return 'Не вдалося увійти: $error';
  }

  @override
  String get loginPinTitle => 'Увійдіть за 4-значним кодом';

  @override
  String get loginPinSubtitle =>
      'Введіть свій 4-значний PIN, щоб продовжити в застосунку Academy 2.0.';

  @override
  String get unlockPinTitle => 'Введіть свій PIN';

  @override
  String unlockPinSubtitle(String phone) {
    return 'Підтвердіть свій 4-значний PIN для\n$phone.';
  }

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
  String moduleNotFound(String moduleId) {
    return 'Модуль $moduleId не знайдено';
  }

  @override
  String get moduleDownloadNoFiles =>
      'Немає файлів для офлайн. Перевірте, що API повертає file_url/poster_url.';

  @override
  String get moduleOfflineVideoUnavailable =>
      'Відео недоступне офлайн. Завантажте контент для перегляду без інтернету.';

  @override
  String get moduleYoutubeOnly =>
      'Це відео доступне тільки онлайн через YouTube і не може бути завантажене.';

  @override
  String get videoTitle => 'Відео';

  @override
  String get infographicTitle => 'Інфографіка';

  @override
  String get quizTitle => 'Розпочати тест';

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
  String get profileDeleteTitle => 'Видалити акаунт';

  @override
  String get profileDeleteMessage =>
      'Ви впевнені, що хочете видалити свій акаунт? Цю дію неможливо скасувати.';

  @override
  String get profileDeleteCancel => 'Скасувати';

  @override
  String get profileDeleteConfirm => 'Видалити';

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

  @override
  String get useAnotherAccount => 'Використати інший акаунт';

  @override
  String get addBirthdate => 'Додати дату народження';

  @override
  String get addButton => 'Додати';

  @override
  String get noContent => 'Немає контенту';

  @override
  String get quizResultCongratsTitle => '🎉 Вітаємо!';

  @override
  String quizResultScore(Object score, Object total) {
    return 'Ти набрав(ла) $score балів із $total можливих у квізі!';
  }

  @override
  String get quizResultCongratsBody =>
      'Чудова робота — можеш завантажити сертифікат і похвалитися результатом! 🏅';

  @override
  String get quizResultTryTitle => '🎈 Гарна спроба!';

  @override
  String get quizResultTryBody =>
      'Нічого страшного — спробуй ще раз! Передивись матеріали, повернись до запитань і покажи, на що здатен(на). Тиснемо кулаки за твій наступний результат! 💪📚';

  @override
  String get quizResultSkip => 'Пропустити';

  @override
  String get quizResultDownload => 'Завантажити';

  @override
  String quizScoreLabel(Object score) {
    return '$score бал(ів)';
  }

  @override
  String get editVideoTitle => 'Редагувати відео';

  @override
  String get editVideoTitleLabel => 'Назва';

  @override
  String get editVideoDescriptionLabel => 'Опис';

  @override
  String get editVideoSaveButton => 'Зберегти';

  @override
  String get offlineBanner =>
      'Ви офлайн. Деякі дії синхронізуються автоматично після відновлення з\'єднання.';

  @override
  String get syncingBanner => 'Синхронізація даних...';

  @override
  String get syncedBanner => 'З\'єднання відновлено. Ваші дані синхронізовано.';

  @override
  String get loginPinInvalid => 'Невірний PIN-код. Спробуйте ще раз.';

  @override
  String get loginUserNotFound =>
      'Користувача не знайдено. Перевірте номер телефону.';

  @override
  String get networkError => 'Помилка мережі. Перевірте з\'єднання.';
}
