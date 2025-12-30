// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AKAdemy2.0';

  @override
  String get loginTitle => 'Log in';

  @override
  String get loginPhoneRequired => 'Please enter your phone number';

  @override
  String get loginPhoneInvalid => 'Invalid phone number.';

  @override
  String get loginCreateAccountPrompt => 'Don\'t have an account?';

  @override
  String get loginCreateAccountCta => 'Create account';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get splashPartnerDefaultTitle => 'Our partners';

  @override
  String get splashPartnerDefaultDescription =>
      'Tap a partner logo to see more. Details for this organization will appear soon.';

  @override
  String get splashPartnerFsoTitle => 'Fundacja Sebastiana Ody';

  @override
  String get splashPartnerFsoDescription =>
      'Fundacja Sebastiana Ody is a non-governmental organization focused on education in safety, civil defense, and crisis management. The Foundation carries out initiatives to prepare society for extraordinary situations, including training in organizing and coordinating operations, public safety, and civil protection.\n\nIn its work, the Foundation combines expert knowledge with practice, undertaking initiatives related to securing high-risk events, including rocket launches and other undertakings that require advanced planning and safety procedures.';

  @override
  String get splashPartnerFsoLinkLabel => 'Website FSO:';

  @override
  String get splashLinkOpenError => 'Could not open link';

  @override
  String get splashLinkGuardHint =>
      'External link is protected by a parental gate.';

  @override
  String loginFailed(String error) {
    return 'Login failed: $error';
  }

  @override
  String get loginPinTitle => 'Log in with your 4-digit code';

  @override
  String get loginPinSubtitle =>
      'Please enter your 4-digit PIN to continue to the AKAdemy2.0 application.';

  @override
  String get unlockPinTitle => 'Enter your PIN';

  @override
  String unlockPinSubtitle(String phone) {
    return 'Confirm your 4-digit PIN for\n$phone.';
  }

  @override
  String get unlockBiometricWaiting => 'Waiting for biometric confirmation...';

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
  String moduleNotFound(String moduleId) {
    return 'Module $moduleId not found';
  }

  @override
  String get moduleDownloadNoFiles =>
      'No files available for offline. Check that API returns file_url/poster_url.';

  @override
  String get moduleOfflineVideoUnavailable =>
      'Video isn\'t available offline. Download the content to watch without internet.';

  @override
  String get moduleYoutubeOnly =>
      'This video is only available online via YouTube and can\'t be downloaded.';

  @override
  String get videoTitle => 'Video';

  @override
  String get infographicTitle => 'Infographic';

  @override
  String get quizTitle => 'Start Quiz';

  @override
  String get resultTitle => 'Result';

  @override
  String get downloadsTitle => 'Downloads';

  @override
  String get downloadsPlaceholder => 'Downloads placeholder (M1)';

  @override
  String get profileTitle => 'Account';

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
      'By providing my email I agree to receive communications from AKAdemy2.0 I understand I can opt out at any time.';

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
      'This code will be needed to log in to the AKAdemy2.0 application.';

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
  String get waitApprovalCancelButton => 'Cancel pending enrollment';

  @override
  String get waitApprovalCancelDialogTitle => 'Cancel enrollment request';

  @override
  String get waitApprovalCancelDialogMessage =>
      'Are you sure you want to cancel your pending enrollment?';

  @override
  String get waitApprovalCancelDialogCancel => 'Keep enrollment';

  @override
  String get waitApprovalCancelDialogConfirm => 'Cancel';

  @override
  String get waitApprovalCancelSuccess => 'Enrollment request canceled.';

  @override
  String waitApprovalCancelFailed(String error) {
    return 'Could not cancel enrollment: $error';
  }

  @override
  String get networkVideoLoadErrorTitle => 'Failed to load video';

  @override
  String get bottomNavCourses => 'Courses';

  @override
  String get bottomNavSchoolVideos => 'School videos';

  @override
  String get bottomNavAccount => 'Account';

  @override
  String get coursesTitle => 'Courses';

  @override
  String get chooseSubjectSubtitle =>
      'Choose a subject to begin your learning adventure!';

  @override
  String get schoolVideosTitle => 'School videos';

  @override
  String get schoolVideosSubtitle =>
      'Watch videos created by pupils and upload your own.';

  @override
  String get schoolVideosFilterAll => 'All';

  @override
  String get schoolVideosSearchHint => 'Search videos';

  @override
  String get schoolVideosEmpty => 'No videos yet.';

  @override
  String get schoolVideosGroupUnknown => 'Other videos';

  @override
  String schoolVideosStatusLabel(String status) {
    return 'Status: $status';
  }

  @override
  String get schoolVideosStatusPending => 'Pending approval';

  @override
  String get schoolVideosStatusApproved => 'Approved';

  @override
  String get schoolVideosDeleteTitle => 'Delete video';

  @override
  String get schoolVideosDeleteMessage => 'Delete this video?';

  @override
  String get schoolVideosPendingTitle => 'Wait for teacher\'s approval';

  @override
  String get schoolVideosPendingMessage =>
      'Your teacher will review your request soon - hang tight!';

  @override
  String get addVideoPageTitle => 'Add video';

  @override
  String get addVideoPageTopicLabel => 'Choose the topic';

  @override
  String get addVideoPageTitleFieldLabel => 'Title';

  @override
  String get addVideoPageDescriptionFieldLabel => 'Description';

  @override
  String get addVideoPageSubmitButton => 'Add';

  @override
  String addVideoUploadFailed(String error) {
    return 'Failed to upload: $error';
  }

  @override
  String schoolVideosError(String error) {
    return 'Error: $error';
  }

  @override
  String get profileFirstName => 'First name';

  @override
  String get profileLastName => 'Last name';

  @override
  String get profileDob => 'Date of birth';

  @override
  String get profileEmail => 'Email';

  @override
  String get profilePhone => 'Phone';

  @override
  String get profilePin => 'PIN code';

  @override
  String get profilePinDialogTitle => 'Change PIN';

  @override
  String get profilePinDialogMessage =>
      'Enter a new 4-digit PIN and confirm it to keep your account secure.';

  @override
  String get profilePinDialogStepNewPin => 'Enter new PIN';

  @override
  String get profilePinDialogStepConfirmPin => 'Confirm PIN';

  @override
  String get profilePinDialogReady => 'PIN ready - tap Save to continue.';

  @override
  String get profilePinDialogMismatch => 'PINs do not match. Try again.';

  @override
  String get profilePinDialogCancel => 'Cancel';

  @override
  String get profilePinDialogSave => 'Save PIN';

  @override
  String get profilePinDialogReset => 'Start over';

  @override
  String get parentalGateTitle => 'Ask a parent to help';

  @override
  String get parentalGateMessage =>
      'Before opening the link, ask an adult to solve this quick task.';

  @override
  String parentalGateQuestionSum(int a, int b) {
    return 'How much is $a+$b?';
  }

  @override
  String parentalGateQuestionDigits(String sequence) {
    return 'Type these numbers: $sequence';
  }

  @override
  String get parentalGateAnswerHint => 'Answer';

  @override
  String get parentalGateError => 'Incorrect answer. Try again.';

  @override
  String get parentalGateCancel => 'Cancel';

  @override
  String get parentalGateConfirm => 'Continue';

  @override
  String get profileTheme => 'Theme';

  @override
  String get profileLanguage => 'Language';

  @override
  String get profileThemeLight => 'Light';

  @override
  String get profileThemeDark => 'Dark';

  @override
  String get profileLangEn => 'English';

  @override
  String get profileLangUk => 'Ukrainian';

  @override
  String get profileLangPl => 'Polish';

  @override
  String get profileSaveButton => 'Save changes';

  @override
  String get profileLogoutButton => 'Logout';

  @override
  String get profileDeleteButton => 'Delete account';

  @override
  String get profileLogoutTitle => 'Logout';

  @override
  String get profileLogoutMessage => 'Do you want to logout from your account?';

  @override
  String get profileLogoutCancel => 'Cancel';

  @override
  String get profileLogoutConfirm => 'Logout';

  @override
  String get profileDeleteTitle => 'Delete account';

  @override
  String get profileDeleteMessage =>
      'Are you sure you want to delete your account? This action cannot be undone.';

  @override
  String get profileDeleteCancel => 'Cancel';

  @override
  String get profileDeleteConfirm => 'Delete';

  @override
  String get profileSaveSuccess => 'Profile saved';

  @override
  String profileSaveFailed(String error) {
    return 'Save failed: $error';
  }

  @override
  String profileDeleteFailed(String error) {
    return 'Delete failed: $error';
  }

  @override
  String get unverifiedEmailAddress => 'Unverified email address.';

  @override
  String get unverifiedPhoneNubmer => 'Unverified phone nubmer.';

  @override
  String get useAnotherAccount => 'Use another account';

  @override
  String get addBirthdate => 'Add birth date';

  @override
  String get addButton => 'Add';

  @override
  String get noContent => 'No content';

  @override
  String get quizResultCongratsTitle => '🎉 Congratulations!';

  @override
  String quizResultScore(Object score, Object total) {
    return 'You scored $score pts out of $total in the quiz!';
  }

  @override
  String get quizResultCongratsBody =>
      'Great job — you can now download your certificate and show off your result! 🏅';

  @override
  String get quizResultTryTitle => '🎈 Nice try!';

  @override
  String get quizResultTryBody =>
      'No worries — you can try again! Review the materials, revisit the questions, and show what you’ve got. Fingers crossed for your next score! 💪📚';

  @override
  String get quizResultSkip => 'Skip';

  @override
  String get quizResultDownload => 'Download сertificate';

  @override
  String get quizRepeat => 'Repeat Quiz';

  @override
  String get quizResultDownloadMissing =>
      'Certificate is not ready yet. Try again later.';

  @override
  String quizResultDownloadSuccess(String path) {
    return 'Certificate saved to $path';
  }

  @override
  String quizResultDownloadFailed(String error) {
    return 'Unable to download certificate: $error';
  }

  @override
  String get quizResultDownloadPermissionDenied =>
      'Storage permission is required to save the certificate.';

  @override
  String get quizResultDownloadPermissionPermanentlyDenied =>
      'Permission was permanently denied. Enable storage access in settings.';

  @override
  String get quizResultDownloadOpenSettings => 'Open settings';

  @override
  String quizScoreLabel(Object score) {
    return '$score %';
  }

  @override
  String get editVideoTitle => 'Edit video';

  @override
  String get editVideoTitleLabel => 'Title';

  @override
  String get editVideoDescriptionLabel => 'Description';

  @override
  String get editVideoSaveButton => 'Save';

  @override
  String get offlineBanner =>
      'You\'re offline. Some actions will sync automatically when you reconnect.';

  @override
  String get syncingBanner => 'Syncing your data...';

  @override
  String get syncedBanner => 'Connection restored. Your data has been synced.';

  @override
  String get loginPinInvalid => 'Invalid PIN. Please try again.';

  @override
  String get loginUserNotFound =>
      'User not found. Please check your phone number.';

  @override
  String get networkError => 'Network error. Please check your connection.';

  @override
  String get offlineContentTitle => 'Content unavailable offline';

  @override
  String get offlineContentMessage => 'Connect to the internet and try again.';

  @override
  String get ok => 'OK';
}
