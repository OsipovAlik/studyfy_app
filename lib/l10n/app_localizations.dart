import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hy.dart';
import 'app_localizations_ru.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('fr'),
    Locale('hy'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Studyfy'**
  String get appTitle;

  /// No description provided for @landingBadge.
  ///
  /// In en, this message translates to:
  /// **'Built for language schools'**
  String get landingBadge;

  /// No description provided for @landingHeroLead.
  ///
  /// In en, this message translates to:
  /// **'Everything your school needs to'**
  String get landingHeroLead;

  /// No description provided for @landingHeroWordTeach.
  ///
  /// In en, this message translates to:
  /// **'teach'**
  String get landingHeroWordTeach;

  /// No description provided for @landingHeroWordSchedule.
  ///
  /// In en, this message translates to:
  /// **'schedule'**
  String get landingHeroWordSchedule;

  /// No description provided for @landingHeroWordTest.
  ///
  /// In en, this message translates to:
  /// **'test'**
  String get landingHeroWordTest;

  /// No description provided for @landingHeroWordGrow.
  ///
  /// In en, this message translates to:
  /// **'grow'**
  String get landingHeroWordGrow;

  /// No description provided for @landingHeroWordSuffix.
  ///
  /// In en, this message translates to:
  /// **''**
  String get landingHeroWordSuffix;

  /// No description provided for @landingHeroSub.
  ///
  /// In en, this message translates to:
  /// **'Organize subjects and levels, build image-rich tests, schedule weekly sessions and see every student\'s results — all in one calm, beautiful place.'**
  String get landingHeroSub;

  /// No description provided for @landingChipSessions.
  ///
  /// In en, this message translates to:
  /// **'Group & individual sessions'**
  String get landingChipSessions;

  /// No description provided for @landingChipTests.
  ///
  /// In en, this message translates to:
  /// **'Tests with images & video'**
  String get landingChipTests;

  /// No description provided for @landingChipGrading.
  ///
  /// In en, this message translates to:
  /// **'Instant grading'**
  String get landingChipGrading;

  /// No description provided for @landingMockTimetable.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get landingMockTimetable;

  /// No description provided for @landingMockToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get landingMockToday;

  /// No description provided for @landingMockGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get landingMockGroup;

  /// No description provided for @landingMockIndividual.
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get landingMockIndividual;

  /// No description provided for @landingMockResult.
  ///
  /// In en, this message translates to:
  /// **'Test result'**
  String get landingMockResult;

  /// No description provided for @landingMockCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct answers'**
  String get landingMockCorrect;

  /// No description provided for @landingMockQuestion.
  ///
  /// In en, this message translates to:
  /// **'What is “apple” in French?'**
  String get landingMockQuestion;

  /// No description provided for @landingFeatureTestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tests & questions'**
  String get landingFeatureTestsTitle;

  /// No description provided for @landingFeatureTestsDesc.
  ///
  /// In en, this message translates to:
  /// **'Multiple-choice or free-text questions, each with an optional image and video.'**
  String get landingFeatureTestsDesc;

  /// No description provided for @landingFeatureTimetableTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly timetable'**
  String get landingFeatureTimetableTitle;

  /// No description provided for @landingFeatureTimetableDesc.
  ///
  /// In en, this message translates to:
  /// **'Recurring group and individual slots, with today\'s session and what\'s next at a glance.'**
  String get landingFeatureTimetableDesc;

  /// No description provided for @landingRolesTitle.
  ///
  /// In en, this message translates to:
  /// **'Made for everyone, in their own way'**
  String get landingRolesTitle;

  /// No description provided for @landingTeachersTitle.
  ///
  /// In en, this message translates to:
  /// **'For teachers'**
  String get landingTeachersTitle;

  /// No description provided for @landingTeachersPoint1.
  ///
  /// In en, this message translates to:
  /// **'Manage subjects, levels and tests'**
  String get landingTeachersPoint1;

  /// No description provided for @landingTeachersPoint2.
  ///
  /// In en, this message translates to:
  /// **'Register students and build groups'**
  String get landingTeachersPoint2;

  /// No description provided for @landingTeachersPoint3.
  ///
  /// In en, this message translates to:
  /// **'Schedule weekly sessions'**
  String get landingTeachersPoint3;

  /// No description provided for @landingTeachersPoint4.
  ///
  /// In en, this message translates to:
  /// **'Review every result in detail'**
  String get landingTeachersPoint4;

  /// No description provided for @landingStudentsTitle.
  ///
  /// In en, this message translates to:
  /// **'For students'**
  String get landingStudentsTitle;

  /// No description provided for @landingStudentsPoint1.
  ///
  /// In en, this message translates to:
  /// **'See your weekly timetable'**
  String get landingStudentsPoint1;

  /// No description provided for @landingStudentsPoint2.
  ///
  /// In en, this message translates to:
  /// **'Know when your next session is'**
  String get landingStudentsPoint2;

  /// No description provided for @landingStudentsPoint3.
  ///
  /// In en, this message translates to:
  /// **'Review your results question by question'**
  String get landingStudentsPoint3;

  /// No description provided for @landingCtaTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to get started?'**
  String get landingCtaTitle;

  /// No description provided for @landingCtaSub.
  ///
  /// In en, this message translates to:
  /// **'Sign in and organize your school.'**
  String get landingCtaSub;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @registrationButton.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registrationButton;

  /// No description provided for @registrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Get in touch'**
  String get registrationTitle;

  /// No description provided for @registrationSub.
  ///
  /// In en, this message translates to:
  /// **'Leave your email and phone number and we\'ll contact you soon.'**
  String get registrationSub;

  /// No description provided for @registrationEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get registrationEmailLabel;

  /// No description provided for @registrationPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get registrationPhoneLabel;

  /// No description provided for @registrationPhonePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'+374 55 123456'**
  String get registrationPhonePlaceholder;

  /// No description provided for @registrationSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get registrationSubmit;

  /// No description provided for @registrationSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get registrationSending;

  /// No description provided for @registrationSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you!'**
  String get registrationSuccessTitle;

  /// No description provided for @registrationSuccessText.
  ///
  /// In en, this message translates to:
  /// **'We\'ve received your request and will contact you soon.'**
  String get registrationSuccessText;

  /// No description provided for @registrationClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get registrationClose;

  /// No description provided for @registrationInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get registrationInvalidEmail;

  /// No description provided for @registrationInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number (e.g. +374 55 123456).'**
  String get registrationInvalidPhone;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorServerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Server unavailable. Please try again.'**
  String get errorServerUnavailable;

  /// No description provided for @registrationTooMany.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Try again in {time}.'**
  String registrationTooMany(String time);

  /// No description provided for @durationSeconds.
  ///
  /// In en, this message translates to:
  /// **'{n} seconds'**
  String durationSeconds(int n);

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{n} minutes'**
  String durationMinutes(int n);

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @loginComingSoon.
  ///
  /// In en, this message translates to:
  /// **'The sign-in screen is coming next.'**
  String get loginComingSoon;

  /// No description provided for @onboardingReplay.
  ///
  /// In en, this message translates to:
  /// **'Watch the intro again'**
  String get onboardingReplay;

  /// No description provided for @loginWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back 👋'**
  String get loginWelcome;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your learning journey.'**
  String get loginSubtitle;

  /// No description provided for @loginEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmail;

  /// No description provided for @loginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// No description provided for @loginForgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot?'**
  String get loginForgot;

  /// No description provided for @passwordShow.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get passwordShow;

  /// No description provided for @passwordHide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get passwordHide;

  /// No description provided for @loginRemember.
  ///
  /// In en, this message translates to:
  /// **'Keep me signed in'**
  String get loginRemember;

  /// No description provided for @loginSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSignIn;

  /// No description provided for @loginSigningIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in…'**
  String get loginSigningIn;

  /// No description provided for @loginInvalid.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get loginInvalid;

  /// No description provided for @loginUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Server unavailable. Please try again.'**
  String get loginUnavailable;

  /// No description provided for @loginTooMany.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get loginTooMany;

  /// No description provided for @loginRetryIn.
  ///
  /// In en, this message translates to:
  /// **'Try again in {time}'**
  String loginRetryIn(String time);

  /// No description provided for @loginResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get loginResetPassword;

  /// No description provided for @loginResetUnlocks.
  ///
  /// In en, this message translates to:
  /// **'Resetting your password unlocks your account right away.'**
  String get loginResetUnlocks;

  /// No description provided for @loginInactive.
  ///
  /// In en, this message translates to:
  /// **'Your organization is inactive. Please contact support.'**
  String get loginInactive;

  /// No description provided for @loginResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset. Log in with the new one.'**
  String get loginResetSuccess;

  /// No description provided for @loginWordLearn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get loginWordLearn;

  /// No description provided for @loginWordDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get loginWordDiscover;

  /// No description provided for @loginWordGrow.
  ///
  /// In en, this message translates to:
  /// **'Grow'**
  String get loginWordGrow;

  /// No description provided for @loginWordAchieve.
  ///
  /// In en, this message translates to:
  /// **'Achieve'**
  String get loginWordAchieve;

  /// No description provided for @forgotTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get forgotTitle;

  /// No description provided for @forgotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a 6-digit code to reset it.'**
  String get forgotSubtitle;

  /// No description provided for @forgotEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get forgotEmailLabel;

  /// No description provided for @forgotSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get forgotSubmit;

  /// No description provided for @forgotSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get forgotSending;

  /// No description provided for @forgotBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get forgotBackToLogin;

  /// No description provided for @forgotTooMany.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again in {minutes} minutes.'**
  String forgotTooMany(int minutes);

  /// No description provided for @forgotStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Enter the code'**
  String get forgotStep2Title;

  /// No description provided for @forgotStep2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Check {email} for a 6-digit code, then set your new password.'**
  String forgotStep2Subtitle(String email);

  /// No description provided for @forgotChangeEmail.
  ///
  /// In en, this message translates to:
  /// **'Use a different email'**
  String get forgotChangeEmail;

  /// No description provided for @forgotCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Code from the email'**
  String get forgotCodeLabel;

  /// No description provided for @forgotCodePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'000000'**
  String get forgotCodePlaceholder;

  /// No description provided for @forgotCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code from the email.'**
  String get forgotCodeInvalid;

  /// No description provided for @forgotPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get forgotPasswordLabel;

  /// No description provided for @forgotConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get forgotConfirmLabel;

  /// No description provided for @forgotPasswordRule.
  ///
  /// In en, this message translates to:
  /// **'8–32 characters: letters, digits and !@#\$%^&*.'**
  String get forgotPasswordRule;

  /// No description provided for @forgotMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match.'**
  String get forgotMismatch;

  /// No description provided for @forgotSubmitReset.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get forgotSubmitReset;

  /// No description provided for @forgotResetting.
  ///
  /// In en, this message translates to:
  /// **'Resetting…'**
  String get forgotResetting;

  /// No description provided for @forgotResendCode.
  ///
  /// In en, this message translates to:
  /// **'Send a new code'**
  String get forgotResendCode;

  /// No description provided for @forgotResendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'Send a new code ({seconds}s)'**
  String forgotResendCodeIn(int seconds);

  /// No description provided for @forgotResendSent.
  ///
  /// In en, this message translates to:
  /// **'A new code is on its way.'**
  String get forgotResendSent;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String homeWelcome(String name);

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out of Studyfy?'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmDescription.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need to sign in again to access your account.'**
  String get logoutConfirmDescription;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @forgotCodeIncorrect.
  ///
  /// In en, this message translates to:
  /// **'The code is incorrect or has expired. Check the email or request a new one.'**
  String get forgotCodeIncorrect;

  /// No description provided for @loginAdminNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Administrator accounts are managed on the Studyfy website. This app is for teachers and students.'**
  String get loginAdminNotSupported;

  /// No description provided for @loginSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session has ended. Please sign in again.'**
  String get loginSessionExpired;

  /// No description provided for @roleTeacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get roleTeacher;

  /// No description provided for @roleStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get roleStudent;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get roleAdmin;

  /// No description provided for @loginNewSchool.
  ///
  /// In en, this message translates to:
  /// **'New school? Get in touch'**
  String get loginNewSchool;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get loginPasswordRequired;
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
      <String>['en', 'fr', 'hy', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'hy':
      return AppLocalizationsHy();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
