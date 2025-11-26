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
  String get profileTitle => 'Konto';

  @override
  String get profilePlaceholder => 'Ekran profilu (M1)';

  @override
  String inviteToken(Object token) {
    return 'Token zaproszenia: $token';
  }

  @override
  String get createAnAccount => 'Utwórz konto';

  @override
  String get firstNameField => 'Imię';

  @override
  String get lastNameField => 'Nazwisko';

  @override
  String get dateOfBirthField => 'Data urodzenia';

  @override
  String get emailField => 'Email';

  @override
  String get phoneField => 'Telefon';

  @override
  String get dateOfBirthHintField => 'DD.MM.YYYY';

  @override
  String get emailHintField => 'emily.corner@gmail.com';

  @override
  String get phoneHintField => '+48 XXX XXX XXX';

  @override
  String get iAgreeToReceive =>
      'Podając mój adres e-mail, zgadzam się na otrzymywanie komunikatów od Akademii 2.0. Rozumiem, że mogę zrezygnować w dowolnym momencie.';

  @override
  String get createAccountButton => 'Utwórz konto';

  @override
  String get verifyPhoneTitle => 'Zweryfikuj swój numer telefonu';

  @override
  String verifyPhoneSubtitle(String phone) {
    return 'Wysłaliśmy czterocyfrowy kod na Twój telefon\n$phone.';
  }

  @override
  String get verifyPhoneInvalidCode =>
      'Nieprawidłowy kod weryfikacyjny. Poproś o nowy.';

  @override
  String verifyPhoneResendCountdown(String seconds) {
    return 'Wyślij ponownie (za 0:$seconds)';
  }

  @override
  String get verifyPhoneResendButton => 'Wyślij kod ponownie';

  @override
  String get verifyPhoneCodeResentSnack => 'Kod został wysłany ponownie';

  @override
  String get verifyYourAccount => 'Zweryfikuj swoje konto';

  @override
  String verifyEmailMessage(Object email) {
    return 'Wysłaliśmy link potwierdzający na $email. Otwórz swoją skrzynkę i kliknij link, aby zakończyć rejestrację.';
  }

  @override
  String get checkSpam => 'Nie widzisz go? Sprawdź folder spam.';

  @override
  String get next => 'Dalej';

  @override
  String get pinCreateTitle => 'Wymyśl 4-cyfrowy kod';

  @override
  String get pinCreateSubtitle =>
      'Ten kod będzie potrzebny do logowania w aplikacji Academy 2.0.';

  @override
  String get pinConfirmTitle => 'Powtórz 4-cyfrowy kod';

  @override
  String get pinConfirmSubtitle => 'Potwierdź swój kod.';

  @override
  String get pinConfirmMismatchSubtitle =>
      'Kody nie są jednakowe. Spróbuj ponownie.';

  @override
  String get pinMismatchInline => 'Kody nie są jednakowe';

  @override
  String get enableBiometricTitle => 'Włącz logowanie biometryczne';

  @override
  String get enableBiometricSubtitle =>
      'Zezwól na logowanie odciskiem palca lub skanem twarzy, aby szybko i bezpiecznie uzyskiwać dostęp do aplikacji.';

  @override
  String get enableBiometricEnable => 'Włącz';

  @override
  String get enableBiometricNotNow => 'Nie teraz';

  @override
  String get enableBiometricSelectOption => 'Wybierz co najmniej jedną opcję';

  @override
  String get enableBiometricNotAvailable =>
      'Uwierzytelnianie biometryczne nie jest dostępne na tym urządzeniu.';

  @override
  String enableBiometricFailed(String error) {
    return 'Nie udało się włączyć biometrii: $error';
  }

  @override
  String get joinGroupTitle => 'Dołącz do swojej grupy';

  @override
  String get joinGroupSubtitle =>
      'Ostatni krok. Wpisz kod lub zeskanuj kod QR, aby dołączyć 🚀';

  @override
  String get joinGroupHint => 'PPSW1286GR';

  @override
  String get joinGroupCodeCaptured => 'Kod zeskanowany';

  @override
  String joinGroupSubmitError(String error) {
    return 'Nie udało się wysłać kodu: $error';
  }

  @override
  String get waitApprovalTitle => 'Poczekaj na zatwierdzenie nauczyciela';

  @override
  String get waitApprovalSubtitle =>
      'Twój nauczyciel wkrótce rozpatrzy Twoje zgłoszenie – chwilę poczekaj!';

  @override
  String get waitApprovalRetryButton => 'Wyślij ponownie';

  @override
  String get bottomNavCourses => 'Kursy';

  @override
  String get bottomNavSchoolVideos => 'Filmy szkolne';

  @override
  String get bottomNavAccount => 'Konto';

  @override
  String get coursesTitle => 'Kursy';

  @override
  String get chooseSubjectSubtitle =>
      'Wybierz przedmiot, aby rozpocząć swoją edukacyjną przygodę!';

  @override
  String get schoolVideosTitle => 'Filmy szkolne';

  @override
  String get schoolVideosSubtitle =>
      'Oglądaj filmy tworzone przez uczniów i dodawaj własne.';

  @override
  String get schoolVideosFilterAll => 'Wszystkie';

  @override
  String get schoolVideosSearchHint => 'Szukaj filmów';

  @override
  String get schoolVideosEmpty => 'Brak filmów.';

  @override
  String get schoolVideosGroupUnknown => 'Inne filmy';

  @override
  String schoolVideosStatusLabel(String status) {
    return 'Status: $status';
  }

  @override
  String get schoolVideosStatusPending => 'Oczekuje na akceptację';

  @override
  String get schoolVideosStatusApproved => 'Zatwierdzony';

  @override
  String get schoolVideosPendingTitle =>
      'Poczekaj na zatwierdzenie nauczyciela';

  @override
  String get schoolVideosPendingMessage =>
      'Twój nauczyciel wkrótce rozpatrzy Twoje zgłoszenie – chwilę poczekaj!';

  @override
  String schoolVideosError(String error) {
    return 'Błąd: $error';
  }

  @override
  String get profileFirstName => 'Imię';

  @override
  String get profileLastName => 'Nazwisko';

  @override
  String get profileDob => 'Data urodzenia';

  @override
  String get profileEmail => 'Email';

  @override
  String get profilePhone => 'Telefon';

  @override
  String get profilePin => 'Kod PIN';

  @override
  String get profileTheme => 'Motyw';

  @override
  String get profileLanguage => 'Język';

  @override
  String get profileThemeLight => 'Jasny';

  @override
  String get profileThemeDark => 'Ciemny';

  @override
  String get profileLangEn => 'Angielski';

  @override
  String get profileLangUk => 'Ukraiński';

  @override
  String get profileLangPl => 'Polski';

  @override
  String get profileSaveButton => 'Zapisz zmiany';

  @override
  String get profileLogoutButton => 'Wyloguj się';

  @override
  String get profileDeleteButton => 'Usuń konto';

  @override
  String get profileLogoutTitle => 'Wyloguj się';

  @override
  String get profileLogoutMessage =>
      'Czy chcesz wylogować się ze swojego konta?';

  @override
  String get profileLogoutCancel => 'Anuluj';

  @override
  String get profileLogoutConfirm => 'Wyloguj się';

  @override
  String get profileSaveSuccess => 'Profil zapisany';

  @override
  String profileSaveFailed(String error) {
    return 'Nie udało się zapisać: $error';
  }

  @override
  String profileDeleteFailed(String error) {
    return 'Nie udało się usunąć: $error';
  }
}
