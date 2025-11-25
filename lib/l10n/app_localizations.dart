import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl'),
    Locale('uk')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Academy 2.0'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @passwordField.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordField;

  /// No description provided for @subjectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get subjectsTitle;

  /// No description provided for @joinTitle.
  ///
  /// In en, this message translates to:
  /// **'Join class'**
  String get joinTitle;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noSubjects.
  ///
  /// In en, this message translates to:
  /// **'No subjects yet'**
  String get noSubjects;

  /// No description provided for @modulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get modulesTitle;

  /// No description provided for @moduleSingleFlow.
  ///
  /// In en, this message translates to:
  /// **'Single flow'**
  String get moduleSingleFlow;

  /// No description provided for @moduleMultiStep.
  ///
  /// In en, this message translates to:
  /// **'Multi-step'**
  String get moduleMultiStep;

  /// No description provided for @moduleScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Module'**
  String get moduleScreenTitle;

  /// No description provided for @videoTitle.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get videoTitle;

  /// No description provided for @infographicTitle.
  ///
  /// In en, this message translates to:
  /// **'Infographic'**
  String get infographicTitle;

  /// No description provided for @quizTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quizTitle;

  /// No description provided for @resultTitle.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get resultTitle;

  /// No description provided for @downloadsTitle.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get downloadsTitle;

  /// No description provided for @downloadsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Downloads placeholder (M1)'**
  String get downloadsPlaceholder;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profilePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Profile placeholder (M1)'**
  String get profilePlaceholder;

  /// No description provided for @inviteToken.
  ///
  /// In en, this message translates to:
  /// **'Invite token: {token}'**
  String inviteToken(Object token);

  /// No description provided for @createAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an Account'**
  String get createAnAccount;

  /// No description provided for @firstNameField.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstNameField;

  /// No description provided for @lastNameField.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastNameField;

  /// No description provided for @dateOfBirthField.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirthField;

  /// No description provided for @emailField.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailField;

  /// No description provided for @phoneField.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneField;

  /// No description provided for @dateOfBirthHintField.
  ///
  /// In en, this message translates to:
  /// **'DD.MM.YYYY'**
  String get dateOfBirthHintField;

  /// No description provided for @emailHintField.
  ///
  /// In en, this message translates to:
  /// **'emily.corner@gmail.com'**
  String get emailHintField;

  /// No description provided for @phoneHintField.
  ///
  /// In en, this message translates to:
  /// **'+48 XXX XXX XXX'**
  String get phoneHintField;

  /// No description provided for @iAgreeToReceive.
  ///
  /// In en, this message translates to:
  /// **'By providing my email I agree to receive communications from Academy 2.0 I understand I can opt out at any time.'**
  String get iAgreeToReceive;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountButton;

  /// No description provided for @verifyPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your phone number'**
  String get verifyPhoneTitle;

  /// No description provided for @verifyPhoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We sent a 4-digit code to your phone\n{phone}.'**
  String verifyPhoneSubtitle(String phone);

  /// No description provided for @verifyPhoneInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid verification code. Please request a new one.'**
  String get verifyPhoneInvalidCode;

  /// No description provided for @verifyPhoneResendCountdown.
  ///
  /// In en, this message translates to:
  /// **'Resend (in 0:{seconds})'**
  String verifyPhoneResendCountdown(String seconds);

  /// No description provided for @verifyPhoneResendButton.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get verifyPhoneResendButton;

  /// No description provided for @verifyPhoneCodeResentSnack.
  ///
  /// In en, this message translates to:
  /// **'Code resent'**
  String get verifyPhoneCodeResentSnack;

  /// No description provided for @verifyYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Verify your account'**
  String get verifyYourAccount;

  /// No description provided for @verifyEmailMessage.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a confirmation link to {email}. Open your inbox and click the link to finish signing up.'**
  String verifyEmailMessage(Object email);

  /// No description provided for @checkSpam.
  ///
  /// In en, this message translates to:
  /// **'Don\'t see it? Check your spam folder.'**
  String get checkSpam;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @pinCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Come up with a 4-digit code'**
  String get pinCreateTitle;

  /// No description provided for @pinCreateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This code will be needed to log in to the Academy 2.0 application.'**
  String get pinCreateSubtitle;

  /// No description provided for @pinConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Repeat a 4-digit code'**
  String get pinConfirmTitle;

  /// No description provided for @pinConfirmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm your code.'**
  String get pinConfirmSubtitle;

  /// No description provided for @pinConfirmMismatchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pins do not match. Try again.'**
  String get pinConfirmMismatchSubtitle;

  /// No description provided for @pinMismatchInline.
  ///
  /// In en, this message translates to:
  /// **'Pins do not match'**
  String get pinMismatchInline;

  /// No description provided for @enableBiometricTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable biometric login'**
  String get enableBiometricTitle;

  /// No description provided for @enableBiometricSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow login with your fingerprint or face scan to quickly and securely access the app.'**
  String get enableBiometricSubtitle;

  /// No description provided for @enableBiometricEnable.
  ///
  /// In en, this message translates to:
  /// **'enable'**
  String get enableBiometricEnable;

  /// No description provided for @enableBiometricNotNow.
  ///
  /// In en, this message translates to:
  /// **'not now'**
  String get enableBiometricNotNow;

  /// No description provided for @enableBiometricSelectOption.
  ///
  /// In en, this message translates to:
  /// **'Select at least one option'**
  String get enableBiometricSelectOption;

  /// No description provided for @enableBiometricNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is not available on this device.'**
  String get enableBiometricNotAvailable;

  /// No description provided for @enableBiometricFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to enable biometrics: {error}'**
  String enableBiometricFailed(String error);

  /// No description provided for @joinGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Join your group'**
  String get joinGroupTitle;

  /// No description provided for @joinGroupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The last step. Enter the code or scan the QR code to join 🚀'**
  String get joinGroupSubtitle;

  /// No description provided for @joinGroupHint.
  ///
  /// In en, this message translates to:
  /// **'PPSW1286GR'**
  String get joinGroupHint;

  /// No description provided for @joinGroupCodeCaptured.
  ///
  /// In en, this message translates to:
  /// **'Code captured'**
  String get joinGroupCodeCaptured;

  /// No description provided for @joinGroupSubmitError.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit code: {error}'**
  String joinGroupSubmitError(String error);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
