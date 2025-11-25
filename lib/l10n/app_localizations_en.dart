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

  @override
  String get createAnAccount => 'Create an Account';

  @override
  String get firstNameField => 'First name';

  @override
  String get lastNameField => 'Last name';

  @override
  String get dateOfBirthField => 'Date of birth';

  @override
  String get emailField => 'Email';

  @override
  String get phoneField => 'Phone';

  @override
  String get dateOfBirthHintField => 'DD.MM.YYYY';

  @override
  String get emailHintField => 'emily.corner@gmail.com';

  @override
  String get phoneHintField => '+48 XXX XXX XXX';

  @override
  String get iAgreeToReceive =>
      'By providing my email I agree to receive communications from Academy 2.0 I understand I can opt out at any time.';

  @override
  String get createAccountButton => 'Create account';

  @override
  String get verifyPhoneTitle => 'Verify your phone number';

  @override
  String verifyPhoneSubtitle(String phone) {
    return 'We sent a 4-digit code to your phone\n$phone.';
  }

  @override
  String get verifyPhoneInvalidCode =>
      'Invalid verification code. Please request a new one.';

  @override
  String verifyPhoneResendCountdown(String seconds) {
    return 'Resend (in 0:$seconds)';
  }

  @override
  String get verifyPhoneResendButton => 'Resend code';

  @override
  String get verifyPhoneCodeResentSnack => 'Code resent';

  @override
  String get verifyYourAccount => 'Verify your account';

  @override
  String verifyEmailMessage(Object email) {
    return 'We\'ve sent a confirmation link to $email. Open your inbox and click the link to finish signing up.';
  }

  @override
  String get checkSpam => 'Don\'t see it? Check your spam folder.';

  @override
  String get next => 'Next';

  @override
  String get pinCreateTitle => 'Come up with a 4-digit code';

  @override
  String get pinCreateSubtitle =>
      'This code will be needed to log in to the Academy 2.0 application.';

  @override
  String get pinConfirmTitle => 'Repeat a 4-digit code';

  @override
  String get pinConfirmSubtitle => 'Confirm your code.';

  @override
  String get pinConfirmMismatchSubtitle => 'Pins do not match. Try again.';

  @override
  String get pinMismatchInline => 'Pins do not match';

  @override
  String get enableBiometricTitle => 'Enable biometric login';

  @override
  String get enableBiometricSubtitle =>
      'Allow login with your fingerprint or face scan to quickly and securely access the app.';

  @override
  String get enableBiometricEnable => 'enable';

  @override
  String get enableBiometricNotNow => 'not now';

  @override
  String get enableBiometricSelectOption => 'Select at least one option';

  @override
  String get enableBiometricNotAvailable =>
      'Biometric authentication is not available on this device.';

  @override
  String enableBiometricFailed(String error) {
    return 'Failed to enable biometrics: $error';
  }

  @override
  String get joinGroupTitle => 'Join your group';

  @override
  String get joinGroupSubtitle =>
      'The last step. Enter the code or scan the QR code to join 🚀';

  @override
  String get joinGroupHint => 'PPSW1286GR';

  @override
  String get joinGroupCodeCaptured => 'Code captured';

  @override
  String joinGroupSubmitError(String error) {
    return 'Failed to submit code: $error';
  }

  @override
  String get waitApprovalTitle => 'Wait for teacher\'s approval';

  @override
  String get waitApprovalSubtitle =>
      'Your teacher will review your request soon - hang tight!';

  @override
  String get waitApprovalRetryButton => 'Submit again';

  @override
  String get bottomNavCourses => 'Courses';

  @override
  String get bottomNavSchoolVideos => 'School videos';

  @override
  String get bottomNavAccount => 'Account';
}
