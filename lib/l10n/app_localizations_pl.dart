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
  String get profileTitle => 'Profil';

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
}
