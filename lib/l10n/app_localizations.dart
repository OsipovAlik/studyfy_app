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

  /// No description provided for @tabSubjects.
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get tabSubjects;

  /// No description provided for @tabSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get tabSessions;

  /// No description provided for @tabHomework.
  ///
  /// In en, this message translates to:
  /// **'Homework'**
  String get tabHomework;

  /// No description provided for @tabMyHomework.
  ///
  /// In en, this message translates to:
  /// **'My homework'**
  String get tabMyHomework;

  /// No description provided for @profileRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get profileRole;

  /// No description provided for @profileSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get profileSchool;

  /// No description provided for @profileEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profileMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since'**
  String get profileMemberSince;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// Theme option that follows the device setting.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get termsOfUse;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Another week of amazing progress. Keep going!'**
  String get homeSubtitle;

  /// No description provided for @homeTimetableTitle.
  ///
  /// In en, this message translates to:
  /// **'This week\'s timetable'**
  String get homeTimetableTitle;

  /// No description provided for @homeTimetableSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recurring sessions by day.'**
  String get homeTimetableSubtitle;

  /// No description provided for @homeTimetableViewCalendar.
  ///
  /// In en, this message translates to:
  /// **'View full calendar'**
  String get homeTimetableViewCalendar;

  /// No description provided for @homeTimetableNextSession.
  ///
  /// In en, this message translates to:
  /// **'Next session'**
  String get homeTimetableNextSession;

  /// No description provided for @homeTimetableEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet'**
  String get homeTimetableEmptyTitle;

  /// No description provided for @homeTimetableLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load the timetable.'**
  String get homeTimetableLoadError;

  /// No description provided for @homeTimetableLiveNow.
  ///
  /// In en, this message translates to:
  /// **'Happening now'**
  String get homeTimetableLiveNow;

  /// No description provided for @sessionToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get sessionToday;

  /// No description provided for @sessionNoSessionsDay.
  ///
  /// In en, this message translates to:
  /// **'No sessions'**
  String get sessionNoSessionsDay;

  /// No description provided for @sessionMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning (before 12:00)'**
  String get sessionMorning;

  /// No description provided for @sessionAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon (12:00–17:00)'**
  String get sessionAfternoon;

  /// No description provided for @sessionEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening (from 17:00)'**
  String get sessionEvening;

  /// No description provided for @sessionJoinCall.
  ///
  /// In en, this message translates to:
  /// **'Join call'**
  String get sessionJoinCall;

  /// No description provided for @sessionTypeGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get sessionTypeGroup;

  /// No description provided for @sessionTypeIndividual.
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get sessionTypeIndividual;

  /// No description provided for @sessionUnknownGroup.
  ///
  /// In en, this message translates to:
  /// **'Group #{id}'**
  String sessionUnknownGroup(int id);

  /// No description provided for @sessionUnknownStudent.
  ///
  /// In en, this message translates to:
  /// **'Student #{id}'**
  String sessionUnknownStudent(int id);

  /// No description provided for @weekdayMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayMonday;

  /// No description provided for @weekdayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekdayTuesday;

  /// No description provided for @weekdayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekdayWednesday;

  /// No description provided for @weekdayThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekdayThursday;

  /// No description provided for @weekdayFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekdayFriday;

  /// No description provided for @weekdaySaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdaySaturday;

  /// No description provided for @weekdaySunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdaySunday;

  /// No description provided for @sessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessionsTitle;

  /// No description provided for @sessionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly recurring group and individual sessions.'**
  String get sessionsSubtitle;

  /// No description provided for @sessionsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet'**
  String get sessionsEmptyTitle;

  /// No description provided for @sessionsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load sessions.'**
  String get sessionsLoadError;

  /// No description provided for @callPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Video call'**
  String get callPageTitle;

  /// No description provided for @callLobbyTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to join?'**
  String get callLobbyTitle;

  /// No description provided for @callLobbySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check your camera and microphone before you go in.'**
  String get callLobbySubtitle;

  /// No description provided for @callGroupSession.
  ///
  /// In en, this message translates to:
  /// **'Group session'**
  String get callGroupSession;

  /// No description provided for @callIndividualSession.
  ///
  /// In en, this message translates to:
  /// **'Individual session'**
  String get callIndividualSession;

  /// No description provided for @callWeekly.
  ///
  /// In en, this message translates to:
  /// **'Every {day} at {time}'**
  String callWeekly(String day, String time);

  /// No description provided for @callJoinNow.
  ///
  /// In en, this message translates to:
  /// **'Join now'**
  String get callJoinNow;

  /// No description provided for @callJoining.
  ///
  /// In en, this message translates to:
  /// **'Joining…'**
  String get callJoining;

  /// No description provided for @callJoinAs.
  ///
  /// In en, this message translates to:
  /// **'You\'ll join as {name}'**
  String callJoinAs(String name);

  /// No description provided for @callHostNote.
  ///
  /// In en, this message translates to:
  /// **'You\'ll join as the host of this class.'**
  String get callHostNote;

  /// No description provided for @callOneDeviceNote.
  ///
  /// In en, this message translates to:
  /// **'Joining here ends your call on any other tab or device.'**
  String get callOneDeviceNote;

  /// No description provided for @callCameraOff.
  ///
  /// In en, this message translates to:
  /// **'Your camera is off'**
  String get callCameraOff;

  /// No description provided for @callCameraBlocked.
  ///
  /// In en, this message translates to:
  /// **'Camera access is blocked. Allow it in your phone\'s settings so others can see you.'**
  String get callCameraBlocked;

  /// No description provided for @callMicBlocked.
  ///
  /// In en, this message translates to:
  /// **'Microphone access is blocked. Allow it in your phone\'s settings so others can hear you.'**
  String get callMicBlocked;

  /// No description provided for @callDeviceBusy.
  ///
  /// In en, this message translates to:
  /// **'Your camera or microphone couldn\'t start. It may be in use by another app.'**
  String get callDeviceBusy;

  /// No description provided for @callTurnOnMic.
  ///
  /// In en, this message translates to:
  /// **'Turn on microphone'**
  String get callTurnOnMic;

  /// No description provided for @callTurnOffMic.
  ///
  /// In en, this message translates to:
  /// **'Turn off microphone'**
  String get callTurnOffMic;

  /// No description provided for @callTurnOnCamera.
  ///
  /// In en, this message translates to:
  /// **'Turn on camera'**
  String get callTurnOnCamera;

  /// No description provided for @callTurnOffCamera.
  ///
  /// In en, this message translates to:
  /// **'Turn off camera'**
  String get callTurnOffCamera;

  /// No description provided for @callSwitchCamera.
  ///
  /// In en, this message translates to:
  /// **'Switch camera'**
  String get callSwitchCamera;

  /// No description provided for @callSwitchCameraError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t switch camera.'**
  String get callSwitchCameraError;

  /// No description provided for @callShowParticipants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get callShowParticipants;

  /// No description provided for @callLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave call'**
  String get callLeave;

  /// No description provided for @callLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get callLive;

  /// No description provided for @callYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get callYou;

  /// No description provided for @callHost.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get callHost;

  /// No description provided for @callInCall.
  ///
  /// In en, this message translates to:
  /// **'{count} in call'**
  String callInCall(int count);

  /// No description provided for @callAloneTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re the only one here'**
  String get callAloneTitle;

  /// No description provided for @callAloneDescription.
  ///
  /// In en, this message translates to:
  /// **'Others will appear as soon as they join.'**
  String get callAloneDescription;

  /// No description provided for @callReconnecting.
  ///
  /// In en, this message translates to:
  /// **'Connection lost. Reconnecting…'**
  String get callReconnecting;

  /// No description provided for @callPoorConnection.
  ///
  /// In en, this message translates to:
  /// **'Poor connection'**
  String get callPoorConnection;

  /// No description provided for @callMuted.
  ///
  /// In en, this message translates to:
  /// **'Muted'**
  String get callMuted;

  /// No description provided for @callJoinedToast.
  ///
  /// In en, this message translates to:
  /// **'{name} joined'**
  String callJoinedToast(String name);

  /// No description provided for @callLeftToast.
  ///
  /// In en, this message translates to:
  /// **'{name} left'**
  String callLeftToast(String name);

  /// No description provided for @callMutedByHost.
  ///
  /// In en, this message translates to:
  /// **'The host muted your microphone.'**
  String get callMutedByHost;

  /// No description provided for @callMediaError.
  ///
  /// In en, this message translates to:
  /// **'Your camera or microphone couldn\'t start.'**
  String get callMediaError;

  /// No description provided for @callLeftTitle.
  ///
  /// In en, this message translates to:
  /// **'You left the call'**
  String get callLeftTitle;

  /// No description provided for @callLeftDescription.
  ///
  /// In en, this message translates to:
  /// **'You can rejoin at any time.'**
  String get callLeftDescription;

  /// No description provided for @callDuplicateTitle.
  ///
  /// In en, this message translates to:
  /// **'You joined from another tab or device'**
  String get callDuplicateTitle;

  /// No description provided for @callDuplicateDescription.
  ///
  /// In en, this message translates to:
  /// **'A call can only be open in one place at a time, so this one was disconnected.'**
  String get callDuplicateDescription;

  /// No description provided for @callRemovedTitle.
  ///
  /// In en, this message translates to:
  /// **'You were removed from the call'**
  String get callRemovedTitle;

  /// No description provided for @callRemovedDescription.
  ///
  /// In en, this message translates to:
  /// **'The host removed you from this call.'**
  String get callRemovedDescription;

  /// No description provided for @callEndedTitle.
  ///
  /// In en, this message translates to:
  /// **'The call has ended'**
  String get callEndedTitle;

  /// No description provided for @callEndedDescription.
  ///
  /// In en, this message translates to:
  /// **'The host closed this room.'**
  String get callEndedDescription;

  /// No description provided for @callLostTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection lost'**
  String get callLostTitle;

  /// No description provided for @callLostDescription.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t reconnect you to the call.'**
  String get callLostDescription;

  /// No description provided for @callForbiddenTitle.
  ///
  /// In en, this message translates to:
  /// **'You can\'t join this call'**
  String get callForbiddenTitle;

  /// No description provided for @callForbiddenDescription.
  ///
  /// In en, this message translates to:
  /// **'Only this session\'s teachers and students can join.'**
  String get callForbiddenDescription;

  /// No description provided for @callUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Video calls aren\'t available yet'**
  String get callUnavailableTitle;

  /// No description provided for @callUnavailableDescription.
  ///
  /// In en, this message translates to:
  /// **'Video calls aren\'t set up on the server. Please try again later.'**
  String get callUnavailableDescription;

  /// No description provided for @callErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t join the call'**
  String get callErrorTitle;

  /// No description provided for @callErrorDescription.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get callErrorDescription;

  /// No description provided for @callNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Session not found'**
  String get callNotFoundTitle;

  /// No description provided for @callNotFoundDescription.
  ///
  /// In en, this message translates to:
  /// **'It may have been deleted, or you\'re not part of it.'**
  String get callNotFoundDescription;

  /// No description provided for @callRejoin.
  ///
  /// In en, this message translates to:
  /// **'Rejoin'**
  String get callRejoin;

  /// No description provided for @callTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get callTryAgain;

  /// No description provided for @sessionsSegmentGroups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get sessionsSegmentGroups;

  /// No description provided for @sessionsFilterAllTypes.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get sessionsFilterAllTypes;

  /// No description provided for @sessionsFilterAllDays.
  ///
  /// In en, this message translates to:
  /// **'All days'**
  String get sessionsFilterAllDays;

  /// No description provided for @sessionsNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No sessions match these filters.'**
  String get sessionsNoMatches;

  /// No description provided for @groupsTitle.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groupsTitle;

  /// No description provided for @groupsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reusable rosters of students.'**
  String get groupsSubtitle;

  /// No description provided for @groupsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No groups yet'**
  String get groupsEmptyTitle;

  /// No description provided for @groupsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load groups.'**
  String get groupsLoadError;

  /// No description provided for @groupMembers.
  ///
  /// In en, this message translates to:
  /// **'{count} members'**
  String groupMembers(int count);

  /// No description provided for @tabStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get tabStudents;

  /// No description provided for @studentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get studentsTitle;

  /// No description provided for @studentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Students of your partner.'**
  String get studentsSubtitle;

  /// No description provided for @studentsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No students yet'**
  String get studentsEmptyTitle;

  /// No description provided for @studentsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load students.'**
  String get studentsLoadError;

  /// No description provided for @sessionsAddSession.
  ///
  /// In en, this message translates to:
  /// **'Add session'**
  String get sessionsAddSession;

  /// No description provided for @sessionsAddModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Add session'**
  String get sessionsAddModalTitle;

  /// No description provided for @sessionsEditModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit session'**
  String get sessionsEditModalTitle;

  /// No description provided for @sessionsCreate.
  ///
  /// In en, this message translates to:
  /// **'Create session'**
  String get sessionsCreate;

  /// No description provided for @sessionsSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get sessionsSave;

  /// No description provided for @sessionsSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get sessionsSaving;

  /// No description provided for @sessionsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get sessionsEdit;

  /// No description provided for @sessionsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get sessionsDelete;

  /// No description provided for @sessionsDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this session?'**
  String get sessionsDeleteConfirmTitle;

  /// No description provided for @sessionsDeleteConfirmDescription.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be undone.'**
  String get sessionsDeleteConfirmDescription;

  /// No description provided for @sessionsDeleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting…'**
  String get sessionsDeleting;

  /// No description provided for @sessionsCreateError.
  ///
  /// In en, this message translates to:
  /// **'Could not create session.'**
  String get sessionsCreateError;

  /// No description provided for @sessionsUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Could not update session.'**
  String get sessionsUpdateError;

  /// No description provided for @sessionsDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Could not delete session.'**
  String get sessionsDeleteError;

  /// No description provided for @sessionsServerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Server unavailable. Please try again.'**
  String get sessionsServerUnavailable;

  /// No description provided for @sessionsNoGroups.
  ///
  /// In en, this message translates to:
  /// **'Create a group first to schedule a group session.'**
  String get sessionsNoGroups;

  /// No description provided for @sessionsNoStudents.
  ///
  /// In en, this message translates to:
  /// **'Register a student first to schedule an individual session.'**
  String get sessionsNoStudents;

  /// No description provided for @sessionsTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get sessionsTypeLabel;

  /// No description provided for @sessionsGroupLabel.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get sessionsGroupLabel;

  /// No description provided for @sessionsStudentLabel.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get sessionsStudentLabel;

  /// No description provided for @sessionsDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day of the week'**
  String get sessionsDayLabel;

  /// No description provided for @sessionsTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get sessionsTimeLabel;

  /// No description provided for @groupsAddGroup.
  ///
  /// In en, this message translates to:
  /// **'Add group'**
  String get groupsAddGroup;

  /// No description provided for @groupsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Click “Add group” to create your first one.'**
  String get groupsEmptyDescription;

  /// No description provided for @groupsNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get groupsNameLabel;

  /// No description provided for @groupsNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g. Beginners Tuesday'**
  String get groupsNamePlaceholder;

  /// No description provided for @groupsMembersLabel.
  ///
  /// In en, this message translates to:
  /// **'Students (optional)'**
  String get groupsMembersLabel;

  /// No description provided for @groupsNoStudentsHint.
  ///
  /// In en, this message translates to:
  /// **'No students registered yet.'**
  String get groupsNoStudentsHint;

  /// No description provided for @groupsAddModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Add group'**
  String get groupsAddModalTitle;

  /// No description provided for @groupsRenameModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename group'**
  String get groupsRenameModalTitle;

  /// No description provided for @groupsCreate.
  ///
  /// In en, this message translates to:
  /// **'Create group'**
  String get groupsCreate;

  /// No description provided for @groupsSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get groupsSave;

  /// No description provided for @groupsSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get groupsSaving;

  /// No description provided for @groupsRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get groupsRename;

  /// No description provided for @groupsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get groupsDelete;

  /// No description provided for @groupsDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String groupsDeleteConfirmTitle(String name);

  /// No description provided for @groupsDeleteConfirmDescription.
  ///
  /// In en, this message translates to:
  /// **'This also deletes the group\'s sessions. This can\'t be undone.'**
  String get groupsDeleteConfirmDescription;

  /// No description provided for @groupsDeleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting…'**
  String get groupsDeleting;

  /// No description provided for @groupsCreateError.
  ///
  /// In en, this message translates to:
  /// **'Could not create group.'**
  String get groupsCreateError;

  /// No description provided for @groupsUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Could not update group.'**
  String get groupsUpdateError;

  /// No description provided for @groupsDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Could not delete group.'**
  String get groupsDeleteError;

  /// No description provided for @groupsServerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Server unavailable. Please try again.'**
  String get groupsServerUnavailable;

  /// No description provided for @groupDetailMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get groupDetailMembersTitle;

  /// No description provided for @groupDetailNoMembers.
  ///
  /// In en, this message translates to:
  /// **'No students in this group yet.'**
  String get groupDetailNoMembers;

  /// No description provided for @groupDetailAddMember.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get groupDetailAddMember;

  /// No description provided for @groupDetailSelectStudent.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get groupDetailSelectStudent;

  /// No description provided for @groupDetailAllAdded.
  ///
  /// In en, this message translates to:
  /// **'All students are already in this group.'**
  String get groupDetailAllAdded;

  /// No description provided for @groupDetailAddMemberError.
  ///
  /// In en, this message translates to:
  /// **'Could not add student.'**
  String get groupDetailAddMemberError;

  /// No description provided for @groupDetailRemoveMember.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get groupDetailRemoveMember;

  /// No description provided for @groupDetailRemoveMemberError.
  ///
  /// In en, this message translates to:
  /// **'Could not remove student.'**
  String get groupDetailRemoveMemberError;

  /// No description provided for @groupDetailNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Group not found'**
  String get groupDetailNotFoundTitle;

  /// No description provided for @groupDetailNotFoundDescription.
  ///
  /// In en, this message translates to:
  /// **'It may have already been deleted.'**
  String get groupDetailNotFoundDescription;

  /// No description provided for @homeStatsNewThisWeek.
  ///
  /// In en, this message translates to:
  /// **'+{count} this week'**
  String homeStatsNewThisWeek(int count);

  /// No description provided for @homeActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'This week\'s activity'**
  String get homeActivityTitle;

  /// No description provided for @homeActivityEmpty.
  ///
  /// In en, this message translates to:
  /// **'No attempts yet this week.'**
  String get homeActivityEmpty;

  /// No description provided for @homeActivityDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get homeActivityDetails;

  /// No description provided for @homeActivityAttempts.
  ///
  /// In en, this message translates to:
  /// **'{count} attempts'**
  String homeActivityAttempts(int count);

  /// No description provided for @homeActivityTotal.
  ///
  /// In en, this message translates to:
  /// **'Attempts'**
  String get homeActivityTotal;

  /// No description provided for @homeActivityAverage.
  ///
  /// In en, this message translates to:
  /// **'Avg. score'**
  String get homeActivityAverage;

  /// No description provided for @homeActivityBest.
  ///
  /// In en, this message translates to:
  /// **'Best score'**
  String get homeActivityBest;

  /// No description provided for @resultsRecentTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent results'**
  String get resultsRecentTitle;

  /// No description provided for @resultsViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get resultsViewAll;

  /// No description provided for @resultsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get resultsPageTitle;

  /// No description provided for @resultsPageSubtitleTeacher.
  ///
  /// In en, this message translates to:
  /// **'Test attempts by your students.'**
  String get resultsPageSubtitleTeacher;

  /// No description provided for @resultsPageSubtitleStudent.
  ///
  /// In en, this message translates to:
  /// **'Your test attempts.'**
  String get resultsPageSubtitleStudent;

  /// No description provided for @resultsFilterAllStudents.
  ///
  /// In en, this message translates to:
  /// **'All students'**
  String get resultsFilterAllStudents;

  /// No description provided for @resultsFilterAllTests.
  ///
  /// In en, this message translates to:
  /// **'All tests'**
  String get resultsFilterAllTests;

  /// No description provided for @resultsAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get resultsAverage;

  /// No description provided for @resultsBest.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get resultsBest;

  /// No description provided for @resultsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No results yet.'**
  String get resultsEmptyTitle;

  /// No description provided for @resultsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load results.'**
  String get resultsLoadError;

  /// No description provided for @resultsUnknownTest.
  ///
  /// In en, this message translates to:
  /// **'Test #{id}'**
  String resultsUnknownTest(int id);

  /// No description provided for @resultDetailYourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your answer'**
  String get resultDetailYourAnswer;

  /// No description provided for @resultDetailCorrectAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct answer'**
  String get resultDetailCorrectAnswer;

  /// No description provided for @resultDetailCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get resultDetailCorrect;

  /// No description provided for @resultDetailIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect'**
  String get resultDetailIncorrect;

  /// No description provided for @resultDetailNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Result not found'**
  String get resultDetailNotFoundTitle;

  /// No description provided for @studentsAddStudent.
  ///
  /// In en, this message translates to:
  /// **'Add student'**
  String get studentsAddStudent;

  /// No description provided for @studentsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Click “Add student” to register the first one.'**
  String get studentsEmptyDescription;

  /// No description provided for @studentsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All subjects'**
  String get studentsFilterAll;

  /// No description provided for @studentsNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get studentsNameLabel;

  /// No description provided for @studentsSurnameLabel.
  ///
  /// In en, this message translates to:
  /// **'Surname (optional)'**
  String get studentsSurnameLabel;

  /// No description provided for @studentsEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get studentsEmailLabel;

  /// No description provided for @studentsPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get studentsPasswordLabel;

  /// No description provided for @studentsPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'8–32 characters: letters, numbers or !@#\$%^&*'**
  String get studentsPasswordHint;

  /// No description provided for @studentsSubjectLabel.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get studentsSubjectLabel;

  /// No description provided for @studentsNoSubjects.
  ///
  /// In en, this message translates to:
  /// **'Create a subject first before registering a student.'**
  String get studentsNoSubjects;

  /// No description provided for @studentsCreate.
  ///
  /// In en, this message translates to:
  /// **'Register student'**
  String get studentsCreate;

  /// No description provided for @studentsSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get studentsSaving;

  /// No description provided for @studentsCreateError.
  ///
  /// In en, this message translates to:
  /// **'Could not register student.'**
  String get studentsCreateError;

  /// No description provided for @studentsEmailTaken.
  ///
  /// In en, this message translates to:
  /// **'That email is already registered.'**
  String get studentsEmailTaken;

  /// No description provided for @studentsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get studentsDelete;

  /// No description provided for @studentsDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String studentsDeleteConfirmTitle(String name);

  /// No description provided for @studentsDeleteConfirmDescription.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be undone.'**
  String get studentsDeleteConfirmDescription;

  /// No description provided for @studentsDeletePasswordPrompt.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password to continue.'**
  String get studentsDeletePasswordPrompt;

  /// No description provided for @studentsDeletePasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'That password is incorrect.'**
  String get studentsDeletePasswordIncorrect;

  /// No description provided for @studentsDeleteForbidden.
  ///
  /// In en, this message translates to:
  /// **'This student also studies another teacher\'s subject — only the school\'s owner can delete them.'**
  String get studentsDeleteForbidden;

  /// No description provided for @studentsDeleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting…'**
  String get studentsDeleting;

  /// No description provided for @studentsDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Could not delete student.'**
  String get studentsDeleteError;

  /// No description provided for @studentsServerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Server unavailable. Please try again.'**
  String get studentsServerUnavailable;

  /// No description provided for @studentsBackToStudents.
  ///
  /// In en, this message translates to:
  /// **'Back to students'**
  String get studentsBackToStudents;

  /// No description provided for @studentsRegisteredLabel.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get studentsRegisteredLabel;

  /// No description provided for @studentsNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Student not found'**
  String get studentsNotFoundTitle;

  /// No description provided for @studentsNotFoundDescription.
  ///
  /// In en, this message translates to:
  /// **'They may have already been deleted.'**
  String get studentsNotFoundDescription;

  /// No description provided for @studentsTestResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Test results'**
  String get studentsTestResultsTitle;

  /// No description provided for @studentsResultsEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Results appear here once students complete tests.'**
  String get studentsResultsEmptyHint;

  /// No description provided for @subjectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get subjectsTitle;

  /// No description provided for @subjectsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your school\'s subjects.'**
  String get subjectsSubtitle;

  /// No description provided for @subjectsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No subjects yet'**
  String get subjectsEmptyTitle;

  /// No description provided for @subjectsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Click “Add subject” to create your first one.'**
  String get subjectsEmptyDescription;

  /// No description provided for @subjectsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load subjects.'**
  String get subjectsLoadError;

  /// No description provided for @subjectsAddSubject.
  ///
  /// In en, this message translates to:
  /// **'Add subject'**
  String get subjectsAddSubject;

  /// No description provided for @subjectsNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g. English'**
  String get subjectsNamePlaceholder;

  /// No description provided for @subjectsAddModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Add subject'**
  String get subjectsAddModalTitle;

  /// No description provided for @subjectsRenameModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename subject'**
  String get subjectsRenameModalTitle;

  /// No description provided for @subjectsCreate.
  ///
  /// In en, this message translates to:
  /// **'Create subject'**
  String get subjectsCreate;

  /// No description provided for @subjectsSave.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get subjectsSave;

  /// No description provided for @subjectsRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get subjectsRename;

  /// No description provided for @subjectsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get subjectsDelete;

  /// No description provided for @subjectsActivate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get subjectsActivate;

  /// No description provided for @subjectsDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get subjectsDeactivate;

  /// No description provided for @subjectsActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get subjectsActiveLabel;

  /// No description provided for @subjectsInactiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get subjectsInactiveLabel;

  /// No description provided for @subjectsDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String subjectsDeleteConfirmTitle(String name);

  /// No description provided for @subjectsDeleteConfirmDescription.
  ///
  /// In en, this message translates to:
  /// **'This also deletes its levels, tests and questions. This can\'t be undone.'**
  String get subjectsDeleteConfirmDescription;

  /// No description provided for @subjectsCreateError.
  ///
  /// In en, this message translates to:
  /// **'Could not create subject.'**
  String get subjectsCreateError;

  /// No description provided for @subjectsUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Could not update subject.'**
  String get subjectsUpdateError;

  /// No description provided for @subjectsDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Could not delete subject.'**
  String get subjectsDeleteError;

  /// No description provided for @subjectsActivateError.
  ///
  /// In en, this message translates to:
  /// **'Could not update that subject\'s status.'**
  String get subjectsActivateError;

  /// No description provided for @subjectsServerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Server unavailable. Please try again.'**
  String get subjectsServerUnavailable;

  /// No description provided for @subjectDetailBackToSubjects.
  ///
  /// In en, this message translates to:
  /// **'Back to subjects'**
  String get subjectDetailBackToSubjects;

  /// No description provided for @subjectDetailNotFoundDescription.
  ///
  /// In en, this message translates to:
  /// **'This subject may have already been deleted.'**
  String get subjectDetailNotFoundDescription;

  /// No description provided for @subjectDetailCreatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get subjectDetailCreatedLabel;

  /// No description provided for @subjectDetailTabTests.
  ///
  /// In en, this message translates to:
  /// **'Tests'**
  String get subjectDetailTabTests;

  /// No description provided for @subjectDetailTabLevels.
  ///
  /// In en, this message translates to:
  /// **'Levels'**
  String get subjectDetailTabLevels;

  /// No description provided for @subjectDetailEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get subjectDetailEdit;

  /// No description provided for @subjectDetailNoLevelsHint.
  ///
  /// In en, this message translates to:
  /// **'Add a level (e.g. A1) before creating tests.'**
  String get subjectDetailNoLevelsHint;

  /// No description provided for @subjectDetailGenerateWithAi.
  ///
  /// In en, this message translates to:
  /// **'Generate with AI'**
  String get subjectDetailGenerateWithAi;

  /// No description provided for @subjectDetailAddTest.
  ///
  /// In en, this message translates to:
  /// **'Add test'**
  String get subjectDetailAddTest;

  /// No description provided for @subjectDetailTestsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No tests yet'**
  String get subjectDetailTestsEmptyTitle;

  /// No description provided for @subjectDetailTestsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a test manually, or generate one with AI.'**
  String get subjectDetailTestsEmptyDescription;

  /// No description provided for @subjectDetailTestsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load tests.'**
  String get subjectDetailTestsLoadError;

  /// No description provided for @subjectDetailAddTestModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Add test'**
  String get subjectDetailAddTestModalTitle;

  /// No description provided for @subjectDetailEditTestModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit test'**
  String get subjectDetailEditTestModalTitle;

  /// No description provided for @subjectDetailTestTitlePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get subjectDetailTestTitlePlaceholder;

  /// No description provided for @subjectDetailTimeLimitLabel.
  ///
  /// In en, this message translates to:
  /// **'Time limit in minutes (leave blank for none)'**
  String get subjectDetailTimeLimitLabel;

  /// No description provided for @subjectDetailTimeLimitHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 45'**
  String get subjectDetailTimeLimitHint;

  /// No description provided for @subjectDetailCreateTest.
  ///
  /// In en, this message translates to:
  /// **'Create test'**
  String get subjectDetailCreateTest;

  /// No description provided for @subjectDetailTestCreateError.
  ///
  /// In en, this message translates to:
  /// **'Could not create test.'**
  String get subjectDetailTestCreateError;

  /// No description provided for @subjectDetailTestUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Could not update test.'**
  String get subjectDetailTestUpdateError;

  /// No description provided for @subjectDetailTestDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Could not delete test.'**
  String get subjectDetailTestDeleteError;

  /// No description provided for @subjectDetailDeleteTestConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\"?'**
  String subjectDetailDeleteTestConfirmTitle(String title);

  /// No description provided for @subjectDetailDeleteTestConfirmDescription.
  ///
  /// In en, this message translates to:
  /// **'This also deletes its questions. This can\'t be undone.'**
  String get subjectDetailDeleteTestConfirmDescription;

  /// No description provided for @subjectDetailAddLevel.
  ///
  /// In en, this message translates to:
  /// **'Add level'**
  String get subjectDetailAddLevel;

  /// No description provided for @subjectDetailLevelNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g. A1'**
  String get subjectDetailLevelNamePlaceholder;

  /// No description provided for @subjectDetailAddLevelModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Add level'**
  String get subjectDetailAddLevelModalTitle;

  /// No description provided for @subjectDetailRenameLevelModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename level'**
  String get subjectDetailRenameLevelModalTitle;

  /// No description provided for @subjectDetailCreateLevel.
  ///
  /// In en, this message translates to:
  /// **'Create level'**
  String get subjectDetailCreateLevel;

  /// No description provided for @subjectDetailLevelsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No levels yet'**
  String get subjectDetailLevelsEmptyTitle;

  /// No description provided for @subjectDetailLevelsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a level (e.g. A1) to start creating tests.'**
  String get subjectDetailLevelsEmptyDescription;

  /// No description provided for @subjectDetailLevelsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load levels.'**
  String get subjectDetailLevelsLoadError;

  /// No description provided for @subjectDetailLevelCreateError.
  ///
  /// In en, this message translates to:
  /// **'Could not create level.'**
  String get subjectDetailLevelCreateError;

  /// No description provided for @subjectDetailLevelUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Could not update level.'**
  String get subjectDetailLevelUpdateError;

  /// No description provided for @subjectDetailLevelDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Could not delete level.'**
  String get subjectDetailLevelDeleteError;

  /// No description provided for @subjectDetailDeleteLevelConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String subjectDetailDeleteLevelConfirmTitle(String name);

  /// No description provided for @subjectDetailDeleteLevelConfirmDescription.
  ///
  /// In en, this message translates to:
  /// **'This also deletes its tests and questions. This can\'t be undone.'**
  String get subjectDetailDeleteLevelConfirmDescription;

  /// No description provided for @subjectDetailGenerateModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Generate test with AI'**
  String get subjectDetailGenerateModalTitle;

  /// No description provided for @subjectDetailGenerateTopicPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Topic, e.g. Past tense irregular verbs'**
  String get subjectDetailGenerateTopicPlaceholder;

  /// No description provided for @subjectDetailGenerateQuestionCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Questions (1–30)'**
  String get subjectDetailGenerateQuestionCountLabel;

  /// No description provided for @subjectDetailGenerateQuestionTypeMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get subjectDetailGenerateQuestionTypeMixed;

  /// No description provided for @subjectDetailGenerateQuestionTypeMultipleChoice.
  ///
  /// In en, this message translates to:
  /// **'Multiple choice'**
  String get subjectDetailGenerateQuestionTypeMultipleChoice;

  /// No description provided for @subjectDetailGenerateQuestionTypeText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get subjectDetailGenerateQuestionTypeText;

  /// No description provided for @subjectDetailGenerateTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title (optional)'**
  String get subjectDetailGenerateTitleLabel;

  /// No description provided for @subjectDetailGenerateInstructionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Instructions for the AI (optional)'**
  String get subjectDetailGenerateInstructionsLabel;

  /// No description provided for @subjectDetailGenerateButton.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get subjectDetailGenerateButton;

  /// No description provided for @subjectDetailGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating… this can take up to a minute.'**
  String get subjectDetailGenerating;

  /// No description provided for @subjectDetailGenerateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not generate a test. Please try again.'**
  String get subjectDetailGenerateFailed;

  /// No description provided for @subjectDetailGenerateRateLimited.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached this hour\'s limit for AI test generation. Try again later.'**
  String get subjectDetailGenerateRateLimited;

  /// No description provided for @subjectDetailGenerateUnavailable.
  ///
  /// In en, this message translates to:
  /// **'AI test generation isn\'t switched on for this school.'**
  String get subjectDetailGenerateUnavailable;

  /// No description provided for @subjectDetailGenerateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Generated {generated} of {requested} questions. Review it before publishing.'**
  String subjectDetailGenerateSuccess(int generated, int requested);

  /// No description provided for @homeworkTitleTeacher.
  ///
  /// In en, this message translates to:
  /// **'Homework'**
  String get homeworkTitleTeacher;

  /// No description provided for @homeworkTitleStudent.
  ///
  /// In en, this message translates to:
  /// **'My Homework'**
  String get homeworkTitleStudent;

  /// No description provided for @homeworkSubtitleTeacher.
  ///
  /// In en, this message translates to:
  /// **'Assign homework to students and follow their progress.'**
  String get homeworkSubtitleTeacher;

  /// No description provided for @homeworkSubtitleStudent.
  ///
  /// In en, this message translates to:
  /// **'Your homework, all in one place.'**
  String get homeworkSubtitleStudent;

  /// No description provided for @homeworkSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search homework…'**
  String get homeworkSearchHint;

  /// No description provided for @homeworkAssignButton.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get homeworkAssignButton;

  /// No description provided for @homeworkStatusAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get homeworkStatusAll;

  /// No description provided for @homeworkStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get homeworkStatusPending;

  /// No description provided for @homeworkStatusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get homeworkStatusOverdue;

  /// No description provided for @homeworkStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get homeworkStatusCompleted;

  /// No description provided for @homeworkFilterAllTypes.
  ///
  /// In en, this message translates to:
  /// **'All homework'**
  String get homeworkFilterAllTypes;

  /// No description provided for @homeworkFilterAllStudents.
  ///
  /// In en, this message translates to:
  /// **'All students'**
  String get homeworkFilterAllStudents;

  /// No description provided for @homeworkKindTest.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get homeworkKindTest;

  /// No description provided for @homeworkKindTask.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get homeworkKindTask;

  /// No description provided for @homeworkEmptyTitleTeacher.
  ///
  /// In en, this message translates to:
  /// **'No homework yet. Assign a test to your students.'**
  String get homeworkEmptyTitleTeacher;

  /// No description provided for @homeworkEmptyTitleStudent.
  ///
  /// In en, this message translates to:
  /// **'No homework yet. Enjoy the free time!'**
  String get homeworkEmptyTitleStudent;

  /// No description provided for @homeworkNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No homework matches your filters.'**
  String get homeworkNoMatches;

  /// No description provided for @homeworkLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load homework.'**
  String get homeworkLoadError;

  /// No description provided for @homeworkAssignModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Assign homework'**
  String get homeworkAssignModalTitle;

  /// No description provided for @homeworkTestLabel.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get homeworkTestLabel;

  /// No description provided for @homeworkNoActiveTests.
  ///
  /// In en, this message translates to:
  /// **'Publish a test first before assigning it as homework.'**
  String get homeworkNoActiveTests;

  /// No description provided for @homeworkTaskTitlePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get homeworkTaskTitlePlaceholder;

  /// No description provided for @homeworkMaxGradeHint.
  ///
  /// In en, this message translates to:
  /// **'Max grade (default 100)'**
  String get homeworkMaxGradeHint;

  /// No description provided for @homeworkDueDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get homeworkDueDateLabel;

  /// No description provided for @homeworkNoDueDate.
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get homeworkNoDueDate;

  /// No description provided for @homeworkNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Note for the student (optional)'**
  String get homeworkNoteHint;

  /// No description provided for @homeworkAssignToLabel.
  ///
  /// In en, this message translates to:
  /// **'Assign to'**
  String get homeworkAssignToLabel;

  /// No description provided for @homeworkGroupsLabel.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get homeworkGroupsLabel;

  /// No description provided for @homeworkStudentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get homeworkStudentsLabel;

  /// No description provided for @homeworkNoStudentsHint.
  ///
  /// In en, this message translates to:
  /// **'Register a student first before assigning homework.'**
  String get homeworkNoStudentsHint;

  /// No description provided for @homeworkAssignError.
  ///
  /// In en, this message translates to:
  /// **'Could not assign homework.'**
  String get homeworkAssignError;

  /// No description provided for @homeworkServerUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Server unavailable. Please try again.'**
  String get homeworkServerUnavailable;

  /// No description provided for @homeworkDueOn.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String homeworkDueOn(String date);

  /// No description provided for @homeworkNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get homeworkNoteLabel;

  /// No description provided for @homeworkTimeLimitMinutes.
  ///
  /// In en, this message translates to:
  /// **'Time limit: {minutes} minutes'**
  String homeworkTimeLimitMinutes(int minutes);

  /// No description provided for @homeworkViewResult.
  ///
  /// In en, this message translates to:
  /// **'View result'**
  String get homeworkViewResult;

  /// No description provided for @homeworkTestUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This test isn\'t available right now.'**
  String get homeworkTestUnavailable;

  /// No description provided for @homeworkStartTest.
  ///
  /// In en, this message translates to:
  /// **'Start test'**
  String get homeworkStartTest;

  /// No description provided for @homeworkStartTestComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Taking tests from here is coming soon.'**
  String get homeworkStartTestComingSoon;

  /// No description provided for @homeworkMaxGradeValue.
  ///
  /// In en, this message translates to:
  /// **'Out of {max} points'**
  String homeworkMaxGradeValue(int max);

  /// No description provided for @homeworkMaterialsLabel.
  ///
  /// In en, this message translates to:
  /// **'Materials'**
  String get homeworkMaterialsLabel;

  /// No description provided for @homeworkSubmissionFilesLabel.
  ///
  /// In en, this message translates to:
  /// **'Submission files'**
  String get homeworkSubmissionFilesLabel;

  /// No description provided for @homeworkUploadFile.
  ///
  /// In en, this message translates to:
  /// **'Upload file'**
  String get homeworkUploadFile;

  /// No description provided for @homeworkLoadFilesError.
  ///
  /// In en, this message translates to:
  /// **'Could not load files.'**
  String get homeworkLoadFilesError;

  /// No description provided for @homeworkNoFiles.
  ///
  /// In en, this message translates to:
  /// **'No files yet.'**
  String get homeworkNoFiles;

  /// No description provided for @homeworkUploadError.
  ///
  /// In en, this message translates to:
  /// **'Could not upload this file.'**
  String get homeworkUploadError;

  /// No description provided for @homeworkDeleteFileError.
  ///
  /// In en, this message translates to:
  /// **'Could not delete this file.'**
  String get homeworkDeleteFileError;

  /// No description provided for @homeworkSubmissionLabel.
  ///
  /// In en, this message translates to:
  /// **'Submission'**
  String get homeworkSubmissionLabel;

  /// No description provided for @homeworkNoSubmissionYet.
  ///
  /// In en, this message translates to:
  /// **'Not submitted yet.'**
  String get homeworkNoSubmissionYet;

  /// No description provided for @homeworkGradeButton.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get homeworkGradeButton;

  /// No description provided for @homeworkSubmissionHint.
  ///
  /// In en, this message translates to:
  /// **'Write your answer…'**
  String get homeworkSubmissionHint;

  /// No description provided for @homeworkSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get homeworkSubmitButton;

  /// No description provided for @homeworkResubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Resubmit'**
  String get homeworkResubmitButton;

  /// No description provided for @homeworkSubmitError.
  ///
  /// In en, this message translates to:
  /// **'Could not submit this homework.'**
  String get homeworkSubmitError;

  /// No description provided for @homeworkUnlockButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get homeworkUnlockButton;

  /// No description provided for @homeworkUnlockError.
  ///
  /// In en, this message translates to:
  /// **'Could not unlock this grade.'**
  String get homeworkUnlockError;

  /// No description provided for @homeworkGradeModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Grade submission'**
  String get homeworkGradeModalTitle;

  /// No description provided for @homeworkGradeHint.
  ///
  /// In en, this message translates to:
  /// **'Grade out of {max}'**
  String homeworkGradeHint(int max);

  /// No description provided for @homeworkFeedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Feedback (optional)'**
  String get homeworkFeedbackHint;

  /// No description provided for @homeworkGradeError.
  ///
  /// In en, this message translates to:
  /// **'Could not save this grade.'**
  String get homeworkGradeError;

  /// No description provided for @homeworkSaveGrade.
  ///
  /// In en, this message translates to:
  /// **'Save grade'**
  String get homeworkSaveGrade;

  /// No description provided for @homeworkEditModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit homework'**
  String get homeworkEditModalTitle;

  /// No description provided for @homeworkUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Could not update this homework.'**
  String get homeworkUpdateError;

  /// No description provided for @homeworkEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get homeworkEdit;

  /// No description provided for @homeworkDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get homeworkDelete;

  /// No description provided for @homeworkDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\"?'**
  String homeworkDeleteConfirmTitle(String title);

  /// No description provided for @homeworkDeleteConfirmDescription.
  ///
  /// In en, this message translates to:
  /// **'This can\'t be undone.'**
  String get homeworkDeleteConfirmDescription;

  /// No description provided for @homeworkDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Could not delete this homework.'**
  String get homeworkDeleteError;

  /// No description provided for @homeworkDetailNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Homework not found'**
  String get homeworkDetailNotFoundTitle;

  /// No description provided for @homeworkDetailNotFoundDescription.
  ///
  /// In en, this message translates to:
  /// **'This homework may have already been deleted.'**
  String get homeworkDetailNotFoundDescription;
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
