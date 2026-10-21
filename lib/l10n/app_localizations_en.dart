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
  String get homeBannerDialogTitle => 'Banner picture';

  @override
  String get homeBannerDialogSubtitle =>
      'Shown on the right of the home page banner, for you and for this subject\'s students.';

  @override
  String get homeBannerNoSubjects => 'Add a subject first.';

  @override
  String get homeBannerSubjectLabel => 'Subject';

  @override
  String get homeBannerPreviewLabel => 'Preview';

  @override
  String get homeBannerChoosePicture => 'Choose a picture';

  @override
  String get homeBannerSizeHint =>
      'Best size: 1600 × 400 px (4:1). At least 1200 × 300 px.';

  @override
  String get homeBannerFormatHint =>
      'JPEG, PNG, GIF or WebP, up to 10 MB. Keep the main part on the right: the left side fades under the text.';

  @override
  String homeBannerTooSmallWarning(int width, int height) {
    return 'This picture is $width × $height px, so it may look blurry. Use at least 1200 × 300 px.';
  }

  @override
  String get homeBannerTooTallWarning =>
      'This picture is much taller than the banner, so its top and bottom will be cut off. A wide picture (about 4:1) fits best.';

  @override
  String get homeBannerRemovePicture => 'Remove picture';

  @override
  String get homeBannerSavePicture => 'Save picture';

  @override
  String get homeBannerUploadError => 'Could not update the picture.';

  @override
  String get homeBannerRemoveError => 'Could not remove the picture.';

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

  @override
  String get tabStudents => 'Students';

  @override
  String get studentsTitle => 'Students';

  @override
  String get studentsSubtitle => 'Students of your partner.';

  @override
  String get studentsEmptyTitle => 'No students yet';

  @override
  String get studentsLoadError => 'Could not load students.';

  @override
  String get sessionsAddSession => 'Add session';

  @override
  String get sessionsAddModalTitle => 'Add session';

  @override
  String get sessionsEditModalTitle => 'Edit session';

  @override
  String get sessionsCreate => 'Create session';

  @override
  String get sessionsSave => 'Save changes';

  @override
  String get sessionsSaving => 'Saving…';

  @override
  String get sessionsEdit => 'Edit';

  @override
  String get sessionsDelete => 'Delete';

  @override
  String get sessionsDeleteConfirmTitle => 'Delete this session?';

  @override
  String get sessionsDeleteConfirmDescription => 'This can\'t be undone.';

  @override
  String get sessionsDeleting => 'Deleting…';

  @override
  String get sessionsCreateError => 'Could not create session.';

  @override
  String get sessionsUpdateError => 'Could not update session.';

  @override
  String get sessionsDeleteError => 'Could not delete session.';

  @override
  String get sessionsServerUnavailable =>
      'Server unavailable. Please try again.';

  @override
  String get sessionsNoGroups =>
      'Create a group first to schedule a group session.';

  @override
  String get sessionsNoStudents =>
      'Register a student first to schedule an individual session.';

  @override
  String get sessionsTypeLabel => 'Type';

  @override
  String get sessionsGroupLabel => 'Group';

  @override
  String get sessionsStudentLabel => 'Student';

  @override
  String get sessionsDayLabel => 'Day of the week';

  @override
  String get sessionsTimeLabel => 'Start time';

  @override
  String get groupsAddGroup => 'Add group';

  @override
  String get groupsEmptyDescription =>
      'Click “Add group” to create your first one.';

  @override
  String get groupsNameLabel => 'Name';

  @override
  String get groupsNamePlaceholder => 'e.g. Beginners Tuesday';

  @override
  String get groupsMembersLabel => 'Students (optional)';

  @override
  String get groupsNoStudentsHint => 'No students registered yet.';

  @override
  String get groupsAddModalTitle => 'Add group';

  @override
  String get groupsRenameModalTitle => 'Rename group';

  @override
  String get groupsCreate => 'Create group';

  @override
  String get groupsSave => 'Save changes';

  @override
  String get groupsSaving => 'Saving…';

  @override
  String get groupsRename => 'Rename';

  @override
  String get groupsDelete => 'Delete';

  @override
  String groupsDeleteConfirmTitle(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get groupsDeleteConfirmDescription =>
      'This also deletes the group\'s sessions. This can\'t be undone.';

  @override
  String get groupsDeleting => 'Deleting…';

  @override
  String get groupsCreateError => 'Could not create group.';

  @override
  String get groupsUpdateError => 'Could not update group.';

  @override
  String get groupsDeleteError => 'Could not delete group.';

  @override
  String get groupsServerUnavailable => 'Server unavailable. Please try again.';

  @override
  String get groupDetailMembersTitle => 'Members';

  @override
  String get groupDetailNoMembers => 'No students in this group yet.';

  @override
  String get groupDetailAddMember => 'Add';

  @override
  String get groupDetailSelectStudent => 'Student';

  @override
  String get groupDetailAllAdded => 'All students are already in this group.';

  @override
  String get groupDetailAddMemberError => 'Could not add student.';

  @override
  String get groupDetailRemoveMember => 'Remove';

  @override
  String get groupDetailRemoveMemberError => 'Could not remove student.';

  @override
  String get groupDetailNotFoundTitle => 'Group not found';

  @override
  String get groupDetailNotFoundDescription =>
      'It may have already been deleted.';

  @override
  String homeStatsNewThisWeek(int count) {
    return '+$count this week';
  }

  @override
  String get homeActivityTitle => 'This week\'s activity';

  @override
  String get homeActivityEmpty => 'No attempts yet this week.';

  @override
  String get homeActivityDetails => 'View details';

  @override
  String homeActivityAttempts(int count) {
    return '$count attempts';
  }

  @override
  String get homeActivityTotal => 'Attempts';

  @override
  String get homeActivityAverage => 'Avg. score';

  @override
  String get homeActivityBest => 'Best score';

  @override
  String get resultsRecentTitle => 'Recent results';

  @override
  String get resultsViewAll => 'View all';

  @override
  String get resultsPageTitle => 'Results';

  @override
  String get resultsPageSubtitleTeacher => 'Test attempts by your students.';

  @override
  String get resultsPageSubtitleStudent => 'Your test attempts.';

  @override
  String get resultsFilterAllStudents => 'All students';

  @override
  String get resultsFilterAllTests => 'All tests';

  @override
  String get resultsAverage => 'Average';

  @override
  String get resultsBest => 'Best';

  @override
  String get resultsEmptyTitle => 'No results yet.';

  @override
  String get resultsLoadError => 'Could not load results.';

  @override
  String resultsUnknownTest(int id) {
    return 'Test #$id';
  }

  @override
  String get resultDetailYourAnswer => 'Your answer';

  @override
  String get resultDetailCorrectAnswer => 'Correct answer';

  @override
  String get resultDetailCorrect => 'Correct';

  @override
  String get resultDetailIncorrect => 'Incorrect';

  @override
  String get resultDetailNotFoundTitle => 'Result not found';

  @override
  String get studentsAddStudent => 'Add student';

  @override
  String get studentsEmptyDescription =>
      'Click “Add student” to register the first one.';

  @override
  String get studentsFilterAll => 'All subjects';

  @override
  String get studentsNameLabel => 'Name';

  @override
  String get studentsSurnameLabel => 'Surname (optional)';

  @override
  String get studentsEmailLabel => 'Email';

  @override
  String get studentsPasswordLabel => 'Password';

  @override
  String get studentsPasswordHint =>
      '8–32 characters: letters, numbers or !@#\$%^&*';

  @override
  String get studentsSubjectLabel => 'Subject';

  @override
  String get studentsNoSubjects =>
      'Create a subject first before registering a student.';

  @override
  String get studentsCreate => 'Register student';

  @override
  String get studentsSaving => 'Saving…';

  @override
  String get studentsCreateError => 'Could not register student.';

  @override
  String get studentsEmailTaken => 'That email is already registered.';

  @override
  String get studentsDelete => 'Delete';

  @override
  String studentsDeleteConfirmTitle(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get studentsDeleteConfirmDescription => 'This can\'t be undone.';

  @override
  String get studentsDeletePasswordPrompt =>
      'Confirm your password to continue.';

  @override
  String get studentsDeletePasswordIncorrect => 'That password is incorrect.';

  @override
  String get studentsDeleteForbidden =>
      'This student also studies another teacher\'s subject — only the school\'s owner can delete them.';

  @override
  String get studentsDeleting => 'Deleting…';

  @override
  String get studentsDeleteError => 'Could not delete student.';

  @override
  String get studentsServerUnavailable =>
      'Server unavailable. Please try again.';

  @override
  String get studentsBackToStudents => 'Back to students';

  @override
  String get studentsRegisteredLabel => 'Registered';

  @override
  String get studentsNotFoundTitle => 'Student not found';

  @override
  String get studentsNotFoundDescription =>
      'They may have already been deleted.';

  @override
  String get studentsTestResultsTitle => 'Test results';

  @override
  String get studentsResultsEmptyHint =>
      'Results appear here once students complete tests.';

  @override
  String get subjectsTitle => 'Subjects';

  @override
  String get subjectsSubtitle => 'Your school\'s subjects.';

  @override
  String get subjectsEmptyTitle => 'No subjects yet';

  @override
  String get subjectsEmptyDescription =>
      'Click “Add subject” to create your first one.';

  @override
  String get subjectsLoadError => 'Could not load subjects.';

  @override
  String get subjectsAddSubject => 'Add subject';

  @override
  String get subjectsNamePlaceholder => 'e.g. English';

  @override
  String get subjectsAddModalTitle => 'Add subject';

  @override
  String get subjectsRenameModalTitle => 'Rename subject';

  @override
  String get subjectsCreate => 'Create subject';

  @override
  String get subjectsSave => 'Save changes';

  @override
  String get subjectsRename => 'Rename';

  @override
  String get subjectsDelete => 'Delete';

  @override
  String get subjectsActivate => 'Activate';

  @override
  String get subjectsDeactivate => 'Deactivate';

  @override
  String get subjectsActiveLabel => 'Active';

  @override
  String get subjectsInactiveLabel => 'Inactive';

  @override
  String subjectsDeleteConfirmTitle(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get subjectsDeleteConfirmDescription =>
      'This also deletes its levels, tests and questions. This can\'t be undone.';

  @override
  String get subjectsCreateError => 'Could not create subject.';

  @override
  String get subjectsUpdateError => 'Could not update subject.';

  @override
  String get subjectsDeleteError => 'Could not delete subject.';

  @override
  String get subjectsActivateError =>
      'Could not update that subject\'s status.';

  @override
  String get subjectsServerUnavailable =>
      'Server unavailable. Please try again.';

  @override
  String get subjectDetailBackToSubjects => 'Back to subjects';

  @override
  String get subjectDetailNotFoundDescription =>
      'This subject may have already been deleted.';

  @override
  String get subjectDetailCreatedLabel => 'Created';

  @override
  String get subjectDetailTabTests => 'Tests';

  @override
  String get subjectDetailTabLevels => 'Levels';

  @override
  String get subjectDetailEdit => 'Edit';

  @override
  String get subjectDetailNoLevelsHint =>
      'Add a level (e.g. A1) before creating tests.';

  @override
  String get subjectDetailGenerateWithAi => 'Generate with AI';

  @override
  String get subjectDetailAddTest => 'Add test';

  @override
  String get subjectDetailTestsEmptyTitle => 'No tests yet';

  @override
  String get subjectDetailTestsEmptyDescription =>
      'Add a test manually, or generate one with AI.';

  @override
  String get subjectDetailTestsLoadError => 'Could not load tests.';

  @override
  String get subjectDetailAddTestModalTitle => 'Add test';

  @override
  String get subjectDetailEditTestModalTitle => 'Edit test';

  @override
  String get subjectDetailTestTitlePlaceholder => 'Title';

  @override
  String get subjectDetailTimeLimitLabel =>
      'Time limit in minutes (leave blank for none)';

  @override
  String get subjectDetailTimeLimitHint => 'e.g. 45';

  @override
  String get subjectDetailCreateTest => 'Create test';

  @override
  String get subjectDetailTestCreateError => 'Could not create test.';

  @override
  String get subjectDetailTestUpdateError => 'Could not update test.';

  @override
  String get subjectDetailTestDeleteError => 'Could not delete test.';

  @override
  String subjectDetailDeleteTestConfirmTitle(String title) {
    return 'Delete \"$title\"?';
  }

  @override
  String get subjectDetailDeleteTestConfirmDescription =>
      'This also deletes its questions. This can\'t be undone.';

  @override
  String get subjectDetailAddLevel => 'Add level';

  @override
  String get subjectDetailLevelNamePlaceholder => 'e.g. A1';

  @override
  String get subjectDetailAddLevelModalTitle => 'Add level';

  @override
  String get subjectDetailRenameLevelModalTitle => 'Rename level';

  @override
  String get subjectDetailCreateLevel => 'Create level';

  @override
  String get subjectDetailLevelsEmptyTitle => 'No levels yet';

  @override
  String get subjectDetailLevelsEmptyDescription =>
      'Add a level (e.g. A1) to start creating tests.';

  @override
  String get subjectDetailLevelsLoadError => 'Could not load levels.';

  @override
  String get subjectDetailLevelCreateError => 'Could not create level.';

  @override
  String get subjectDetailLevelUpdateError => 'Could not update level.';

  @override
  String get subjectDetailLevelDeleteError => 'Could not delete level.';

  @override
  String subjectDetailDeleteLevelConfirmTitle(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get subjectDetailDeleteLevelConfirmDescription =>
      'This also deletes its tests and questions. This can\'t be undone.';

  @override
  String get subjectDetailGenerateModalTitle => 'Generate test with AI';

  @override
  String get subjectDetailGenerateTopicPlaceholder =>
      'Topic, e.g. Past tense irregular verbs';

  @override
  String get subjectDetailGenerateQuestionCountLabel => 'Questions (1–30)';

  @override
  String get subjectDetailGenerateQuestionTypeMixed => 'Mixed';

  @override
  String get subjectDetailGenerateQuestionTypeMultipleChoice =>
      'Multiple choice';

  @override
  String get subjectDetailGenerateQuestionTypeText => 'Text';

  @override
  String get subjectDetailGenerateTitleLabel => 'Title (optional)';

  @override
  String get subjectDetailGenerateInstructionsLabel =>
      'Instructions for the AI (optional)';

  @override
  String get subjectDetailGenerateButton => 'Generate';

  @override
  String get subjectDetailGenerating =>
      'Generating… this can take up to a minute.';

  @override
  String get subjectDetailGenerateFailed =>
      'Could not generate a test. Please try again.';

  @override
  String get subjectDetailGenerateRateLimited =>
      'You\'ve reached this hour\'s limit for AI test generation. Try again later.';

  @override
  String get subjectDetailGenerateUnavailable =>
      'AI test generation isn\'t switched on for this school.';

  @override
  String subjectDetailGenerateSuccess(int generated, int requested) {
    return 'Generated $generated of $requested questions. Review it before publishing.';
  }

  @override
  String get testDetailNotFoundDescription =>
      'This test may have already been deleted.';

  @override
  String get testDetailDraftBannerTitle => 'Draft – not visible to students';

  @override
  String get testDetailDiscardDraft => 'Discard draft';

  @override
  String get testDetailPublishTest => 'Publish test';

  @override
  String get testDetailPublishError => 'Could not update the test.';

  @override
  String get testDetailDiscardDraftConfirmTitle => 'Discard this draft?';

  @override
  String get testDetailDiscardDraftConfirmDescription =>
      'This deletes the test and its questions. This can\'t be undone.';

  @override
  String get testDetailDiscardError => 'Could not discard the draft.';

  @override
  String get testDetailUntimedLabel => 'Untimed';

  @override
  String testDetailMinutesLabel(int minutes) {
    return '$minutes min';
  }

  @override
  String get testDetailTabQuestions => 'Questions';

  @override
  String testDetailTabResults(int count) {
    return 'Results ($count)';
  }

  @override
  String testDetailTabHomework(int count) {
    return 'Homework ($count)';
  }

  @override
  String get testDetailQuestionsSubtitle =>
      'Questions for this test appear here.';

  @override
  String get testDetailAddQuestion => 'Add question';

  @override
  String get testDetailQuestionsLoadError => 'Could not load questions.';

  @override
  String get testDetailFreeTextLabel => 'Free text';

  @override
  String testDetailExpectedAnswerLabel(String answer) {
    return 'Expected answer: $answer';
  }

  @override
  String get testDetailDeleteQuestionConfirmTitle => 'Delete this question?';

  @override
  String get testDetailDeleteQuestionConfirmDescription =>
      'This can\'t be undone.';

  @override
  String get testDetailQuestionDeleteError => 'Could not delete the question.';

  @override
  String get testDetailResultsEmptyTitle => 'No attempts yet.';

  @override
  String get testDetailHomeworkEmptyTitle => 'Not assigned to anyone yet.';

  @override
  String get testDetailQuestionFormAddTitle => 'Add question';

  @override
  String get testDetailQuestionFormEditTitle => 'Edit question';

  @override
  String get testDetailQuestionLabel => 'Question';

  @override
  String get testDetailQuestionTextPlaceholder => 'Question text';

  @override
  String get testDetailQuestionTypeLabel => 'Type';

  @override
  String testDetailOptionLabel(String letter) {
    return 'Option $letter';
  }

  @override
  String testDetailOptionOptionalLabel(String letter) {
    return 'Option $letter (optional)';
  }

  @override
  String get testDetailCorrectAnswerLabel => 'Correct option';

  @override
  String get testDetailExpectedTextAnswerPlaceholder => 'Expected answer';

  @override
  String get testDetailImageLabel => 'Image (optional)';

  @override
  String get testDetailAddImage => 'Add image';

  @override
  String get testDetailImageHelpExisting =>
      'Choose a new image to replace it, or leave this empty to keep the current one. JPEG, PNG, GIF or WebP, up to 10 MB.';

  @override
  String get testDetailImageHelpNew => 'JPEG, PNG, GIF or WebP, up to 10 MB.';

  @override
  String get testDetailVideoPlaceholder => 'Video link (optional)';

  @override
  String get testDetailVideoHint => 'https://…';

  @override
  String get testDetailSaveQuestion => 'Save question';

  @override
  String get testDetailQuestionCreateError => 'Could not add the question.';

  @override
  String get testDetailQuestionUpdateError => 'Could not update the question.';

  @override
  String get homeworkTitleTeacher => 'Homework';

  @override
  String get homeworkTitleStudent => 'My Homework';

  @override
  String get homeworkSubtitleTeacher =>
      'Assign homework to students and follow their progress.';

  @override
  String get homeworkSubtitleStudent => 'Your homework, all in one place.';

  @override
  String get homeworkSearchHint => 'Search homework…';

  @override
  String get homeworkAssignButton => 'Assign';

  @override
  String get homeworkStatusAll => 'All';

  @override
  String get homeworkStatusPending => 'Pending';

  @override
  String get homeworkStatusOverdue => 'Overdue';

  @override
  String get homeworkStatusCompleted => 'Completed';

  @override
  String get homeworkFilterAllTypes => 'All homework';

  @override
  String get homeworkFilterAllStudents => 'All students';

  @override
  String get homeworkKindTest => 'Test';

  @override
  String get homeworkKindTask => 'Task';

  @override
  String get homeworkEmptyTitleTeacher =>
      'No homework yet. Assign a test to your students.';

  @override
  String get homeworkEmptyTitleStudent =>
      'No homework yet. Enjoy the free time!';

  @override
  String get homeworkNoMatches => 'No homework matches your filters.';

  @override
  String get homeworkLoadError => 'Could not load homework.';

  @override
  String get homeworkAssignModalTitle => 'Assign homework';

  @override
  String get homeworkTestLabel => 'Test';

  @override
  String get homeworkNoActiveTests =>
      'Publish a test first before assigning it as homework.';

  @override
  String get homeworkTaskTitlePlaceholder => 'Title';

  @override
  String get homeworkMaxGradeHint => 'Max grade (default 100)';

  @override
  String get homeworkAttachmentLabel => 'Attachment (optional)';

  @override
  String get homeworkDueDateLabel => 'Due date';

  @override
  String get homeworkNoDueDate => 'No due date';

  @override
  String get homeworkNoteHint => 'Note for the student (optional)';

  @override
  String get homeworkAssignToLabel => 'Assign to';

  @override
  String get homeworkGroupsLabel => 'Groups';

  @override
  String get homeworkStudentsLabel => 'Students';

  @override
  String get homeworkNoStudentsHint =>
      'Register a student first before assigning homework.';

  @override
  String get homeworkAssignError => 'Could not assign homework.';

  @override
  String get homeworkServerUnavailable =>
      'Server unavailable. Please try again.';

  @override
  String homeworkDueOn(String date) {
    return 'Due $date';
  }

  @override
  String get homeworkNoteLabel => 'Note';

  @override
  String homeworkTimeLimitMinutes(int minutes) {
    return 'Time limit: $minutes minutes';
  }

  @override
  String get homeworkViewResult => 'View result';

  @override
  String get homeworkTestUnavailable => 'This test isn\'t available right now.';

  @override
  String get homeworkStartTest => 'Start test';

  @override
  String get homeworkStartTestComingSoon =>
      'Taking tests from here is coming soon.';

  @override
  String homeworkMaxGradeValue(int max) {
    return 'Out of $max points';
  }

  @override
  String get homeworkMaterialsLabel => 'Materials';

  @override
  String get homeworkSubmissionFilesLabel => 'Submission files';

  @override
  String get homeworkUploadFile => 'Upload file';

  @override
  String get homeworkLoadFilesError => 'Could not load files.';

  @override
  String get homeworkNoFiles => 'No files yet.';

  @override
  String get homeworkUploadError => 'Could not upload this file.';

  @override
  String get homeworkDeleteFileError => 'Could not delete this file.';

  @override
  String get homeworkSubmissionLabel => 'Submission';

  @override
  String get homeworkNoSubmissionYet => 'Not submitted yet.';

  @override
  String get homeworkGradeButton => 'Grade';

  @override
  String get homeworkSubmissionHint => 'Write your answer…';

  @override
  String get homeworkSubmitButton => 'Submit';

  @override
  String get homeworkResubmitButton => 'Resubmit';

  @override
  String get homeworkSubmitError => 'Could not submit this homework.';

  @override
  String get homeworkUnlockButton => 'Unlock';

  @override
  String get homeworkUnlockError => 'Could not unlock this grade.';

  @override
  String get homeworkGradeModalTitle => 'Grade submission';

  @override
  String homeworkGradeHint(int max) {
    return 'Grade out of $max';
  }

  @override
  String get homeworkFeedbackHint => 'Feedback (optional)';

  @override
  String get homeworkGradeError => 'Could not save this grade.';

  @override
  String get homeworkSaveGrade => 'Save grade';

  @override
  String get homeworkEditModalTitle => 'Edit homework';

  @override
  String get homeworkUpdateError => 'Could not update this homework.';

  @override
  String get homeworkEdit => 'Edit';

  @override
  String get homeworkDelete => 'Delete';

  @override
  String homeworkDeleteConfirmTitle(String title) {
    return 'Delete \"$title\"?';
  }

  @override
  String get homeworkDeleteConfirmDescription => 'This can\'t be undone.';

  @override
  String get homeworkDeleteError => 'Could not delete this homework.';

  @override
  String get homeworkDetailNotFoundTitle => 'Homework not found';

  @override
  String get homeworkDetailNotFoundDescription =>
      'This homework may have already been deleted.';
}
