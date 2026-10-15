// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Studyfy';

  @override
  String get landingBadge => 'Built for language schools';

  @override
  String get landingHeroLead => 'Everything your school needs to';

  @override
  String get landingHeroWordTeach => 'teach';

  @override
  String get landingHeroWordSchedule => 'schedule';

  @override
  String get landingHeroWordTest => 'test';

  @override
  String get landingHeroWordGrow => 'grow';

  @override
  String get landingHeroWordSuffix => '';

  @override
  String get landingHeroSub =>
      'Organize subjects and levels, build image-rich tests, schedule weekly sessions and see every student\'s results — all in one calm, beautiful place.';

  @override
  String get landingChipSessions => 'Group & individual sessions';

  @override
  String get landingChipTests => 'Tests with images & video';

  @override
  String get landingChipGrading => 'Instant grading';

  @override
  String get landingMockTimetable => 'This week';

  @override
  String get landingMockToday => 'Today';

  @override
  String get landingMockGroup => 'Group';

  @override
  String get landingMockIndividual => 'Individual';

  @override
  String get landingMockResult => 'Test result';

  @override
  String get landingMockCorrect => 'Correct answers';

  @override
  String get landingMockQuestion => 'What is “apple” in French?';

  @override
  String get landingFeatureTestsTitle => 'Tests & questions';

  @override
  String get landingFeatureTestsDesc =>
      'Multiple-choice or free-text questions, each with an optional image and video.';

  @override
  String get landingFeatureTimetableTitle => 'Weekly timetable';

  @override
  String get landingFeatureTimetableDesc =>
      'Recurring group and individual slots, with today\'s session and what\'s next at a glance.';

  @override
  String get landingRolesTitle => 'Made for everyone, in their own way';

  @override
  String get landingTeachersTitle => 'For teachers';

  @override
  String get landingTeachersPoint1 => 'Manage subjects, levels and tests';

  @override
  String get landingTeachersPoint2 => 'Register students and build groups';

  @override
  String get landingTeachersPoint3 => 'Schedule weekly sessions';

  @override
  String get landingTeachersPoint4 => 'Review every result in detail';

  @override
  String get landingStudentsTitle => 'For students';

  @override
  String get landingStudentsPoint1 => 'See your weekly timetable';

  @override
  String get landingStudentsPoint2 => 'Know when your next session is';

  @override
  String get landingStudentsPoint3 =>
      'Review your results question by question';

  @override
  String get landingCtaTitle => 'Ready to get started?';

  @override
  String get landingCtaSub => 'Sign in and organize your school.';

  @override
  String get signIn => 'Sign in';

  @override
  String get registrationButton => 'Registration';

  @override
  String get registrationTitle => 'Get in touch';

  @override
  String get registrationSub =>
      'Leave your email and phone number and we\'ll contact you soon.';

  @override
  String get registrationEmailLabel => 'Email';

  @override
  String get registrationPhoneLabel => 'Phone number';

  @override
  String get registrationPhonePlaceholder => '+374 55 123456';

  @override
  String get registrationSubmit => 'Send request';

  @override
  String get registrationSending => 'Sending…';

  @override
  String get registrationSuccessTitle => 'Thank you!';

  @override
  String get registrationSuccessText =>
      'We\'ve received your request and will contact you soon.';

  @override
  String get registrationClose => 'Close';

  @override
  String get registrationInvalidEmail => 'Enter a valid email address.';

  @override
  String get registrationInvalidPhone =>
      'Enter a valid phone number (e.g. +374 55 123456).';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorServerUnavailable => 'Server unavailable. Please try again.';

  @override
  String registrationTooMany(String time) {
    return 'Too many requests. Try again in $time.';
  }

  @override
  String durationSeconds(int n) {
    return '$n seconds';
  }

  @override
  String durationMinutes(int n) {
    return '$n minutes';
  }

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get languageLabel => 'Language';

  @override
  String get loginComingSoon => 'The sign-in screen is coming next.';

  @override
  String get onboardingReplay => 'Watch the intro again';

  @override
  String get loginWelcome => 'Welcome back 👋';

  @override
  String get loginSubtitle => 'Sign in to continue your learning journey.';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginForgot => 'Forgot?';

  @override
  String get passwordShow => 'Show';

  @override
  String get passwordHide => 'Hide';

  @override
  String get loginRemember => 'Keep me signed in';

  @override
  String get loginSignIn => 'Sign in';

  @override
  String get loginSigningIn => 'Signing in…';

  @override
  String get loginInvalid => 'Incorrect email or password.';

  @override
  String get loginUnavailable => 'Server unavailable. Please try again.';

  @override
  String get loginTooMany => 'Too many attempts. Please try again later.';

  @override
  String loginRetryIn(String time) {
    return 'Try again in $time';
  }

  @override
  String get loginResetPassword => 'Reset your password';

  @override
  String get loginResetUnlocks =>
      'Resetting your password unlocks your account right away.';

  @override
  String get loginInactive =>
      'Your organization is inactive. Please contact support.';

  @override
  String get loginResetSuccess => 'Password reset. Log in with the new one.';

  @override
  String get loginWordLearn => 'Learn';

  @override
  String get loginWordDiscover => 'Discover';

  @override
  String get loginWordGrow => 'Grow';

  @override
  String get loginWordAchieve => 'Achieve';

  @override
  String get forgotTitle => 'Reset your password';

  @override
  String get forgotSubtitle =>
      'Enter your email and we\'ll send you a 6-digit code to reset it.';

  @override
  String get forgotEmailLabel => 'Email';

  @override
  String get forgotSubmit => 'Send code';

  @override
  String get forgotSending => 'Sending…';

  @override
  String get forgotBackToLogin => 'Back to sign in';

  @override
  String forgotTooMany(int minutes) {
    return 'Too many attempts. Try again in $minutes minutes.';
  }

  @override
  String get forgotStep2Title => 'Enter the code';

  @override
  String forgotStep2Subtitle(String email) {
    return 'Check $email for a 6-digit code, then set your new password.';
  }

  @override
  String get forgotChangeEmail => 'Use a different email';

  @override
  String get forgotCodeLabel => 'Code from the email';

  @override
  String get forgotCodePlaceholder => '000000';

  @override
  String get forgotCodeInvalid => 'Enter the 6-digit code from the email.';

  @override
  String get forgotPasswordLabel => 'New password';

  @override
  String get forgotConfirmLabel => 'Confirm new password';

  @override
  String get forgotPasswordRule =>
      '8–32 characters: letters, digits and !@#\$%^&*.';

  @override
  String get forgotMismatch => 'Passwords don\'t match.';

  @override
  String get forgotSubmitReset => 'Reset password';

  @override
  String get forgotResetting => 'Resetting…';

  @override
  String get forgotResendCode => 'Send a new code';

  @override
  String forgotResendCodeIn(int seconds) {
    return 'Send a new code (${seconds}s)';
  }

  @override
  String get forgotResendSent => 'A new code is on its way.';

  @override
  String homeWelcome(String name) {
    return 'Welcome back, $name';
  }

  @override
  String get logout => 'Log out';

  @override
  String get logoutConfirmTitle => 'Log out of Studyfy?';

  @override
  String get logoutConfirmDescription =>
      'You\'ll need to sign in again to access your account.';

  @override
  String get cancel => 'Cancel';

  @override
  String get forgotCodeIncorrect =>
      'The code is incorrect or has expired. Check the email or request a new one.';

  @override
  String get loginAdminNotSupported =>
      'Administrator accounts are managed on the Studyfy website. This app is for teachers and students.';

  @override
  String get loginSessionExpired =>
      'Your session has ended. Please sign in again.';

  @override
  String get roleTeacher => 'Teacher';

  @override
  String get roleStudent => 'Student';

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get loginNewSchool => 'New school? Get in touch';

  @override
  String get loginPasswordRequired => 'Enter your password.';

  @override
  String get tabSubjects => 'Subjects';

  @override
  String get tabSessions => 'Sessions';

  @override
  String get tabHomework => 'Homework';

  @override
  String get tabMyHomework => 'My homework';

  @override
  String get profileRole => 'Role';

  @override
  String get profileSchool => 'School';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileMemberSince => 'Member since';

  @override
  String get tabProfile => 'Profile';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get termsOfUse => 'Terms of use';

  @override
  String get tabHome => 'Home';

  @override
  String get homeSubtitle => 'Another week of amazing progress. Keep going!';

  @override
  String get homeTimetableTitle => 'This week\'s timetable';

  @override
  String get homeTimetableSubtitle => 'Recurring sessions by day.';

  @override
  String get homeTimetableViewCalendar => 'View full calendar';

  @override
  String get homeTimetableNextSession => 'Next session';

  @override
  String get homeTimetableEmptyTitle => 'No sessions yet';

  @override
  String get homeTimetableLoadError => 'Could not load the timetable.';

  @override
  String get homeTimetableLiveNow => 'Happening now';

  @override
  String get sessionToday => 'Today';

  @override
  String get sessionNoSessionsDay => 'No sessions';

  @override
  String get sessionMorning => 'Morning (before 12:00)';

  @override
  String get sessionAfternoon => 'Afternoon (12:00–17:00)';

  @override
  String get sessionEvening => 'Evening (from 17:00)';

  @override
  String get sessionJoinCall => 'Join call';

  @override
  String get sessionTypeGroup => 'Group';

  @override
  String get sessionTypeIndividual => 'Individual';

  @override
  String sessionUnknownGroup(int id) {
    return 'Group #$id';
  }

  @override
  String sessionUnknownStudent(int id) {
    return 'Student #$id';
  }

  @override
  String get weekdayMonday => 'Monday';

  @override
  String get weekdayTuesday => 'Tuesday';

  @override
  String get weekdayWednesday => 'Wednesday';

  @override
  String get weekdayThursday => 'Thursday';

  @override
  String get weekdayFriday => 'Friday';

  @override
  String get weekdaySaturday => 'Saturday';

  @override
  String get weekdaySunday => 'Sunday';

  @override
  String get sessionsTitle => 'Sessions';

  @override
  String get sessionsSubtitle =>
      'Weekly recurring group and individual sessions.';

  @override
  String get sessionsEmptyTitle => 'No sessions yet';

  @override
  String get sessionsLoadError => 'Could not load sessions.';

  @override
  String get callPageTitle => 'Video call';

  @override
  String get callLobbyTitle => 'Ready to join?';

  @override
  String get callLobbySubtitle =>
      'Check your camera and microphone before you go in.';

  @override
  String get callGroupSession => 'Group session';

  @override
  String get callIndividualSession => 'Individual session';

  @override
  String callWeekly(String day, String time) {
    return 'Every $day at $time';
  }

  @override
  String get callJoinNow => 'Join now';

  @override
  String get callJoining => 'Joining…';

  @override
  String callJoinAs(String name) {
    return 'You\'ll join as $name';
  }

  @override
  String get callHostNote => 'You\'ll join as the host of this class.';

  @override
  String get callOneDeviceNote =>
      'Joining here ends your call on any other tab or device.';

  @override
  String get callCameraOff => 'Your camera is off';

  @override
  String get callCameraBlocked =>
      'Camera access is blocked. Allow it in your phone\'s settings so others can see you.';

  @override
  String get callMicBlocked =>
      'Microphone access is blocked. Allow it in your phone\'s settings so others can hear you.';

  @override
  String get callDeviceBusy =>
      'Your camera or microphone couldn\'t start. It may be in use by another app.';

  @override
  String get callTurnOnMic => 'Turn on microphone';

  @override
  String get callTurnOffMic => 'Turn off microphone';

  @override
  String get callTurnOnCamera => 'Turn on camera';

  @override
  String get callTurnOffCamera => 'Turn off camera';

  @override
  String get callSwitchCamera => 'Switch camera';

  @override
  String get callSwitchCameraError => 'Couldn\'t switch camera.';

  @override
  String get callShowParticipants => 'Participants';

  @override
  String get callLeave => 'Leave call';

  @override
  String get callLive => 'Live';

  @override
  String get callYou => 'You';

  @override
  String get callHost => 'Host';

  @override
  String callInCall(int count) {
    return '$count in call';
  }

  @override
  String get callAloneTitle => 'You\'re the only one here';

  @override
  String get callAloneDescription => 'Others will appear as soon as they join.';

  @override
  String get callReconnecting => 'Connection lost. Reconnecting…';

  @override
  String get callPoorConnection => 'Poor connection';

  @override
  String get callMuted => 'Muted';

  @override
  String callJoinedToast(String name) {
    return '$name joined';
  }

  @override
  String callLeftToast(String name) {
    return '$name left';
  }

  @override
  String get callMutedByHost => 'The host muted your microphone.';

  @override
  String get callMediaError => 'Your camera or microphone couldn\'t start.';

  @override
  String get callLeftTitle => 'You left the call';

  @override
  String get callLeftDescription => 'You can rejoin at any time.';

  @override
  String get callDuplicateTitle => 'You joined from another tab or device';

  @override
  String get callDuplicateDescription =>
      'A call can only be open in one place at a time, so this one was disconnected.';

  @override
  String get callRemovedTitle => 'You were removed from the call';

  @override
  String get callRemovedDescription => 'The host removed you from this call.';

  @override
  String get callEndedTitle => 'The call has ended';

  @override
  String get callEndedDescription => 'The host closed this room.';

  @override
  String get callLostTitle => 'Connection lost';

  @override
  String get callLostDescription => 'We couldn\'t reconnect you to the call.';

  @override
  String get callForbiddenTitle => 'You can\'t join this call';

  @override
  String get callForbiddenDescription =>
      'Only this session\'s teachers and students can join.';

  @override
  String get callUnavailableTitle => 'Video calls aren\'t available yet';

  @override
  String get callUnavailableDescription =>
      'Video calls aren\'t set up on the server. Please try again later.';

  @override
  String get callErrorTitle => 'Couldn\'t join the call';

  @override
  String get callErrorDescription => 'Check your connection and try again.';

  @override
  String get callNotFoundTitle => 'Session not found';

  @override
  String get callNotFoundDescription =>
      'It may have been deleted, or you\'re not part of it.';

  @override
  String get callRejoin => 'Rejoin';

  @override
  String get callTryAgain => 'Try again';

  @override
  String get sessionsSegmentGroups => 'Groups';

  @override
  String get sessionsFilterAllTypes => 'All types';

  @override
  String get sessionsFilterAllDays => 'All days';

  @override
  String get sessionsNoMatches => 'No sessions match these filters.';

  @override
  String get groupsTitle => 'Groups';

  @override
  String get groupsSubtitle => 'Reusable rosters of students.';

  @override
  String get groupsEmptyTitle => 'No groups yet';

  @override
  String get groupsLoadError => 'Could not load groups.';

  @override
  String groupMembers(int count) {
    return '$count members';
  }
}
