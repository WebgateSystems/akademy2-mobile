import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_uk.dart';


abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl'),
    Locale('uk')
  ];

  String get appTitle;

  String get loginTitle;

  String get loginPhoneRequired;

  String get loginPhoneInvalid;

  String get loginCreateAccountPrompt;

  String get loginCreateAccountCta;

  String loginFailed(String error);

  String get loginPinTitle;

  String get loginPinSubtitle;

  String get unlockPinTitle;

  String unlockPinSubtitle(String phone);

  String get passwordField;

  String get subjectsTitle;

  String get joinTitle;

  String get loading;

  String get retry;

  String get noSubjects;

  String get modulesTitle;

  String get moduleSingleFlow;

  String get moduleMultiStep;

  String get moduleScreenTitle;

  String moduleNotFound(String moduleId);

  String get moduleDownloadNoFiles;

  String get moduleOfflineVideoUnavailable;

  String get moduleYoutubeOnly;

  String get videoTitle;

  String get infographicTitle;

  String get quizTitle;

  String get resultTitle;

  String get downloadsTitle;

  String get downloadsPlaceholder;

  String get profileTitle;

  String get profilePlaceholder;

  String inviteToken(Object token);

  String get createAnAccount;

  String get firstNameField;

  String get lastNameField;

  String get dateOfBirthField;

  String get emailField;

  String get phoneField;

  String get dateOfBirthHintField;

  String get emailHintField;

  String get phoneHintField;

  String get iAgreeToReceive;

  String get createAccountButton;

  String get verifyPhoneTitle;

  String verifyPhoneSubtitle(String phone);

  String get verifyPhoneInvalidCode;

  String verifyPhoneResendCountdown(String seconds);

  String get verifyPhoneResendButton;

  String get verifyPhoneCodeResentSnack;

  String get verifyYourAccount;

  String verifyEmailMessage(Object email);

  String get checkSpam;

  String get next;

  String get pinCreateTitle;

  String get pinCreateSubtitle;

  String get pinConfirmTitle;

  String get pinConfirmSubtitle;

  String get pinConfirmMismatchSubtitle;

  String get pinMismatchInline;

  String get enableBiometricTitle;

  String get enableBiometricSubtitle;

  String get enableBiometricEnable;

  String get enableBiometricNotNow;

  String get enableBiometricSelectOption;

  String get enableBiometricNotAvailable;

  String enableBiometricFailed(String error);

  String get joinGroupTitle;

  String get joinGroupSubtitle;

  String get joinGroupHint;

  String get joinGroupCodeCaptured;

  String joinGroupSubmitError(String error);

  String get waitApprovalTitle;

  String get waitApprovalSubtitle;

  String get waitApprovalRetryButton;

  String get bottomNavCourses;

  String get bottomNavSchoolVideos;

  String get bottomNavAccount;

  String get coursesTitle;

  String get chooseSubjectSubtitle;

  String get schoolVideosTitle;

  String get schoolVideosSubtitle;

  String get schoolVideosFilterAll;

  String get schoolVideosSearchHint;

  String get schoolVideosEmpty;

  String get schoolVideosGroupUnknown;

  String schoolVideosStatusLabel(String status);

  String get schoolVideosStatusPending;

  String get schoolVideosStatusApproved;

  String get schoolVideosPendingTitle;

  String get schoolVideosPendingMessage;

  String schoolVideosError(String error);

  String get profileFirstName;

  String get profileLastName;

  String get profileDob;

  String get profileEmail;

  String get profilePhone;

  String get profilePin;

  String get profileTheme;

  String get profileLanguage;

  String get profileThemeLight;

  String get profileThemeDark;

  String get profileLangEn;

  String get profileLangUk;

  String get profileLangPl;

  String get profileSaveButton;

  String get profileLogoutButton;

  String get profileDeleteButton;

  String get profileLogoutTitle;

  String get profileLogoutMessage;

  String get profileLogoutCancel;

  String get profileLogoutConfirm;

  String get profileDeleteTitle;

  String get profileDeleteMessage;

  String get profileDeleteCancel;

  String get profileDeleteConfirm;

  String get profileSaveSuccess;

  String profileSaveFailed(String error);

  String profileDeleteFailed(String error);

  String get unverifiedEmailAddress;

  String get unverifiedPhoneNubmer;

  String get useAnotherAccount;

  String get addBirthdate;

  String get addButton;

  String get noContent;

  String get quizResultCongratsTitle;

  String quizResultScore(Object score, Object total);

  String get quizResultCongratsBody;

  String get quizResultTryTitle;

  String get quizResultTryBody;

  String get quizResultSkip;

  String get quizResultDownload;

  String quizScoreLabel(Object score);

  String get editVideoTitle;

  String get editVideoTitleLabel;

  String get editVideoDescriptionLabel;

  String get editVideoSaveButton;

  String get offlineBanner;

  String get syncingBanner;

  String get syncedBanner;

  String get loginPinInvalid;

  String get loginUserNotFound;

  String get networkError;
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
