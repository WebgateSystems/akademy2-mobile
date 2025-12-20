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
  /// **'AKAdemy2.0'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get loginTitle;

  /// No description provided for @loginPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get loginPhoneRequired;

  /// No description provided for @loginPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number.'**
  String get loginPhoneInvalid;

  /// No description provided for @loginCreateAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get loginCreateAccountPrompt;

  /// No description provided for @loginCreateAccountCta.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get loginCreateAccountCta;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed: {error}'**
  String loginFailed(String error);

  /// No description provided for @loginPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Log in with your 4-digit code'**
  String get loginPinTitle;

  /// No description provided for @loginPinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter your 4-digit PIN to continue to the AKAdemy2.0 application.'**
  String get loginPinSubtitle;

  /// No description provided for @unlockPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN'**
  String get unlockPinTitle;

  /// No description provided for @unlockPinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm your 4-digit PIN for\n{phone}.'**
  String unlockPinSubtitle(String phone);

  /// Text shown while biometric authentication is in progress.
  ///
  /// In en, this message translates to:
  /// **'Waiting for biometric confirmation...'**
  String get unlockBiometricWaiting;

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

  /// No description provided for @moduleNotFound.
  ///
  /// In en, this message translates to:
  /// **'Module {moduleId} not found'**
  String moduleNotFound(String moduleId);

  /// No description provided for @moduleDownloadNoFiles.
  ///
  /// In en, this message translates to:
  /// **'No files available for offline. Check that API returns file_url/poster_url.'**
  String get moduleDownloadNoFiles;

  /// No description provided for @moduleOfflineVideoUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Video isn\'t available offline. Download the content to watch without internet.'**
  String get moduleOfflineVideoUnavailable;

  /// No description provided for @moduleYoutubeOnly.
  ///
  /// In en, this message translates to:
  /// **'This video is only available online via YouTube and can\'t be downloaded.'**
  String get moduleYoutubeOnly;

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
  /// **'Start Quiz'**
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
  /// **'Account'**
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
  /// **'By providing my email I agree to receive communications from AKAdemy2.0 I understand I can opt out at any time.'**
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
  /// **'This code will be needed to log in to the AKAdemy2.0 application.'**
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

  /// No description provided for @waitApprovalTitle.
  ///
  /// In en, this message translates to:
  /// **'Wait for teacher\'s approval'**
  String get waitApprovalTitle;

  /// No description provided for @waitApprovalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your teacher will review your request soon - hang tight!'**
  String get waitApprovalSubtitle;

  /// No description provided for @waitApprovalRetryButton.
  ///
  /// In en, this message translates to:
  /// **'Submit again'**
  String get waitApprovalRetryButton;

  /// No description provided for @waitApprovalCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel pending enrollment'**
  String get waitApprovalCancelButton;

  /// No description provided for @waitApprovalCancelDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel enrollment request'**
  String get waitApprovalCancelDialogTitle;

  /// No description provided for @waitApprovalCancelDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel your pending enrollment?'**
  String get waitApprovalCancelDialogMessage;

  /// No description provided for @waitApprovalCancelDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Keep enrollment'**
  String get waitApprovalCancelDialogCancel;

  /// No description provided for @waitApprovalCancelDialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get waitApprovalCancelDialogConfirm;

  /// No description provided for @waitApprovalCancelSuccess.
  ///
  /// In en, this message translates to:
  /// **'Enrollment request canceled.'**
  String get waitApprovalCancelSuccess;

  /// No description provided for @waitApprovalCancelFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not cancel enrollment: {error}'**
  String waitApprovalCancelFailed(String error);

  /// No description provided for @networkVideoLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load video'**
  String get networkVideoLoadErrorTitle;

  /// No description provided for @bottomNavCourses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get bottomNavCourses;

  /// No description provided for @bottomNavSchoolVideos.
  ///
  /// In en, this message translates to:
  /// **'School videos'**
  String get bottomNavSchoolVideos;

  /// No description provided for @bottomNavAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get bottomNavAccount;

  /// No description provided for @coursesTitle.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get coursesTitle;

  /// No description provided for @chooseSubjectSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a subject to begin your learning adventure!'**
  String get chooseSubjectSubtitle;

  /// No description provided for @schoolVideosTitle.
  ///
  /// In en, this message translates to:
  /// **'School videos'**
  String get schoolVideosTitle;

  /// No description provided for @schoolVideosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Watch videos created by pupils and upload your own.'**
  String get schoolVideosSubtitle;

  /// No description provided for @schoolVideosFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get schoolVideosFilterAll;

  /// No description provided for @schoolVideosSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search videos'**
  String get schoolVideosSearchHint;

  /// No description provided for @schoolVideosEmpty.
  ///
  /// In en, this message translates to:
  /// **'No videos yet.'**
  String get schoolVideosEmpty;

  /// No description provided for @schoolVideosGroupUnknown.
  ///
  /// In en, this message translates to:
  /// **'Other videos'**
  String get schoolVideosGroupUnknown;

  /// No description provided for @schoolVideosStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String schoolVideosStatusLabel(String status);

  /// No description provided for @schoolVideosStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending approval'**
  String get schoolVideosStatusPending;

  /// No description provided for @schoolVideosStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get schoolVideosStatusApproved;

  /// No description provided for @schoolVideosDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete video'**
  String get schoolVideosDeleteTitle;

  /// No description provided for @schoolVideosDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete this video?'**
  String get schoolVideosDeleteMessage;

  /// No description provided for @schoolVideosPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Wait for teacher\'s approval'**
  String get schoolVideosPendingTitle;

  /// No description provided for @schoolVideosPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Your teacher will review your request soon - hang tight!'**
  String get schoolVideosPendingMessage;

  /// No description provided for @addVideoPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Add video'**
  String get addVideoPageTitle;

  /// No description provided for @addVideoPageTopicLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose the topic'**
  String get addVideoPageTopicLabel;

  /// No description provided for @addVideoPageTitleFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get addVideoPageTitleFieldLabel;

  /// No description provided for @addVideoPageDescriptionFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get addVideoPageDescriptionFieldLabel;

  /// No description provided for @addVideoPageSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addVideoPageSubmitButton;

  /// No description provided for @addVideoUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload: {error}'**
  String addVideoUploadFailed(String error);

  /// No description provided for @schoolVideosError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String schoolVideosError(String error);

  /// No description provided for @profileFirstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get profileFirstName;

  /// No description provided for @profileLastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get profileLastName;

  /// No description provided for @profileDob.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get profileDob;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get profilePhone;

  /// No description provided for @profilePin.
  ///
  /// In en, this message translates to:
  /// **'PIN code'**
  String get profilePin;

  /// No description provided for @profilePinDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get profilePinDialogTitle;

  /// No description provided for @profilePinDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter a new 4-digit PIN and confirm it to keep your account secure.'**
  String get profilePinDialogMessage;

  /// No description provided for @profilePinDialogStepNewPin.
  ///
  /// In en, this message translates to:
  /// **'Enter new PIN'**
  String get profilePinDialogStepNewPin;

  /// No description provided for @profilePinDialogStepConfirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm PIN'**
  String get profilePinDialogStepConfirmPin;

  /// No description provided for @profilePinDialogReady.
  ///
  /// In en, this message translates to:
  /// **'PIN ready - tap Save to continue.'**
  String get profilePinDialogReady;

  /// No description provided for @profilePinDialogMismatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match. Try again.'**
  String get profilePinDialogMismatch;

  /// No description provided for @profilePinDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profilePinDialogCancel;

  /// No description provided for @profilePinDialogSave.
  ///
  /// In en, this message translates to:
  /// **'Save PIN'**
  String get profilePinDialogSave;

  /// No description provided for @profilePinDialogReset.
  ///
  /// In en, this message translates to:
  /// **'Start over'**
  String get profilePinDialogReset;

  /// No description provided for @profileTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get profileTheme;

  /// No description provided for @profileLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileLanguage;

  /// No description provided for @profileThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get profileThemeLight;

  /// No description provided for @profileThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get profileThemeDark;

  /// No description provided for @profileLangEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get profileLangEn;

  /// No description provided for @profileLangUk.
  ///
  /// In en, this message translates to:
  /// **'Ukrainian'**
  String get profileLangUk;

  /// No description provided for @profileLangPl.
  ///
  /// In en, this message translates to:
  /// **'Polish'**
  String get profileLangPl;

  /// No description provided for @profileSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get profileSaveButton;

  /// No description provided for @profileLogoutButton.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileLogoutButton;

  /// No description provided for @profileDeleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get profileDeleteButton;

  /// No description provided for @profileLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileLogoutTitle;

  /// No description provided for @profileLogoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Do you want to logout from your account?'**
  String get profileLogoutMessage;

  /// No description provided for @profileLogoutCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileLogoutCancel;

  /// No description provided for @profileLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileLogoutConfirm;

  /// No description provided for @profileDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get profileDeleteTitle;

  /// No description provided for @profileDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get profileDeleteMessage;

  /// No description provided for @profileDeleteCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileDeleteCancel;

  /// No description provided for @profileDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get profileDeleteConfirm;

  /// No description provided for @profileSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get profileSaveSuccess;

  /// No description provided for @profileSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Save failed: {error}'**
  String profileSaveFailed(String error);

  /// No description provided for @profileDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Delete failed: {error}'**
  String profileDeleteFailed(String error);

  /// No description provided for @unverifiedEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Unverified email address.'**
  String get unverifiedEmailAddress;

  /// No description provided for @unverifiedPhoneNubmer.
  ///
  /// In en, this message translates to:
  /// **'Unverified phone nubmer.'**
  String get unverifiedPhoneNubmer;

  /// No description provided for @useAnotherAccount.
  ///
  /// In en, this message translates to:
  /// **'Use another account'**
  String get useAnotherAccount;

  /// No description provided for @addBirthdate.
  ///
  /// In en, this message translates to:
  /// **'Add birth date'**
  String get addBirthdate;

  /// No description provided for @addButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButton;

  /// No description provided for @noContent.
  ///
  /// In en, this message translates to:
  /// **'No content'**
  String get noContent;

  /// No description provided for @quizResultCongratsTitle.
  ///
  /// In en, this message translates to:
  /// **'🎉 Congratulations!'**
  String get quizResultCongratsTitle;

  /// No description provided for @quizResultScore.
  ///
  /// In en, this message translates to:
  /// **'You scored {score} pts out of {total} in the quiz!'**
  String quizResultScore(Object score, Object total);

  /// No description provided for @quizResultCongratsBody.
  ///
  /// In en, this message translates to:
  /// **'Great job — you can now download your certificate and show off your result! 🏅'**
  String get quizResultCongratsBody;

  /// No description provided for @quizResultTryTitle.
  ///
  /// In en, this message translates to:
  /// **'🎈 Nice try!'**
  String get quizResultTryTitle;

  /// No description provided for @quizResultTryBody.
  ///
  /// In en, this message translates to:
  /// **'No worries — you can try again! Review the materials, revisit the questions, and show what you’ve got. Fingers crossed for your next score! 💪📚'**
  String get quizResultTryBody;

  /// No description provided for @quizResultSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get quizResultSkip;

  /// No description provided for @quizResultDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get quizResultDownload;

  /// No description provided for @quizResultDownloadMissing.
  ///
  /// In en, this message translates to:
  /// **'Certificate is not ready yet. Try again later.'**
  String get quizResultDownloadMissing;

  /// No description provided for @quizResultDownloadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Certificate saved to {path}'**
  String quizResultDownloadSuccess(String path);

  /// No description provided for @quizResultDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to download certificate: {error}'**
  String quizResultDownloadFailed(String error);

  /// No description provided for @quizResultDownloadPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Storage permission is required to save the certificate.'**
  String get quizResultDownloadPermissionDenied;

  /// No description provided for @quizResultDownloadPermissionPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission was permanently denied. Enable storage access in settings.'**
  String get quizResultDownloadPermissionPermanentlyDenied;

  /// No description provided for @quizResultDownloadOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get quizResultDownloadOpenSettings;

  /// No description provided for @quizScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'{score} %'**
  String quizScoreLabel(Object score);

  /// No description provided for @editVideoTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit video'**
  String get editVideoTitle;

  /// No description provided for @editVideoTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get editVideoTitleLabel;

  /// No description provided for @editVideoDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get editVideoDescriptionLabel;

  /// No description provided for @editVideoSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get editVideoSaveButton;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Some actions will sync automatically when you reconnect.'**
  String get offlineBanner;

  /// No description provided for @syncingBanner.
  ///
  /// In en, this message translates to:
  /// **'Syncing your data...'**
  String get syncingBanner;

  /// No description provided for @syncedBanner.
  ///
  /// In en, this message translates to:
  /// **'Connection restored. Your data has been synced.'**
  String get syncedBanner;

  /// No description provided for @loginPinInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid PIN. Please try again.'**
  String get loginPinInvalid;

  /// No description provided for @loginUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found. Please check your phone number.'**
  String get loginUserNotFound;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get networkError;

  /// No description provided for @offlineContentTitle.
  ///
  /// In en, this message translates to:
  /// **'Content unavailable offline'**
  String get offlineContentTitle;

  /// No description provided for @offlineContentMessage.
  ///
  /// In en, this message translates to:
  /// **'Connect to the internet and try again.'**
  String get offlineContentMessage;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;
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
