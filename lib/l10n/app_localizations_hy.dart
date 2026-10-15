// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Armenian (`hy`).
class AppLocalizationsHy extends AppLocalizations {
  AppLocalizationsHy([String locale = 'hy']) : super(locale);

  @override
  String get appTitle => 'Studyfy';

  @override
  String get landingBadge => 'Ստեղծված է լեզվի կենտրոնների համար';

  @override
  String get landingHeroLead => 'Ամեն ինչ, ինչ ձեր կենտրոնին պետք է՝';

  @override
  String get landingHeroWordTeach => 'դասավանդելու';

  @override
  String get landingHeroWordSchedule => 'պլանավորելու';

  @override
  String get landingHeroWordTest => 'թեստավորելու';

  @override
  String get landingHeroWordGrow => 'աճելու';

  @override
  String get landingHeroWordSuffix => 'համար';

  @override
  String get landingHeroSub =>
      'Կազմակերպեք առարկաներն ու մակարդակները, ստեղծեք նկարներով թեստեր, պլանավորեք շաբաթական պարապմունքներ և տեսեք յուրաքանչյուր աշակերտի արդյունքները՝ մի հարմար ու գեղեցիկ տեղում։';

  @override
  String get landingChipSessions => 'Խմբային և անհատական պարապմունքներ';

  @override
  String get landingChipTests => 'Թեստեր՝ նկարներով և տեսանյութով';

  @override
  String get landingChipGrading => 'Ակնթարթային գնահատում';

  @override
  String get landingMockTimetable => 'Այս շաբաթ';

  @override
  String get landingMockToday => 'Այսօր';

  @override
  String get landingMockGroup => 'Խմբային';

  @override
  String get landingMockIndividual => 'Անհատական';

  @override
  String get landingMockResult => 'Թեստի արդյունք';

  @override
  String get landingMockCorrect => 'Ճիշտ պատասխաններ';

  @override
  String get landingMockQuestion => 'Ինչպե՞ս է «խնձոր»-ը ֆրանսերեն';

  @override
  String get landingFeatureTestsTitle => 'Թեստեր և հարցեր';

  @override
  String get landingFeatureTestsDesc =>
      'Բազմակի ընտրության կամ ազատ տեքստով հարցեր՝ կամընտիր նկարով և տեսանյութով։';

  @override
  String get landingFeatureTimetableTitle => 'Շաբաթական ժամանակացույց';

  @override
  String get landingFeatureTimetableDesc =>
      'Կրկնվող խմբային և անհատական պարապմունքներ՝ այսօրվա և հաջորդ պարապմունքի մի հայացքով։';

  @override
  String get landingRolesTitle => 'Բոլորի համար՝ իր տեսքով';

  @override
  String get landingTeachersTitle => 'Ուսուցիչների համար';

  @override
  String get landingTeachersPoint1 =>
      'Կառավարեք առարկաները, մակարդակներն ու թեստերը';

  @override
  String get landingTeachersPoint2 => 'Գրանցեք աշակերտներին և կազմեք խմբեր';

  @override
  String get landingTeachersPoint3 => 'Պլանավորեք շաբաթական պարապմունքները';

  @override
  String get landingTeachersPoint4 => 'Դիտեք բոլոր արդյունքները մանրամասնորեն';

  @override
  String get landingStudentsTitle => 'Աշակերտների համար';

  @override
  String get landingStudentsPoint1 => 'Տեսեք ձեր շաբաթական ժամանակացույցը';

  @override
  String get landingStudentsPoint2 => 'Իմացեք հաջորդ պարապմունքի ժամը';

  @override
  String get landingStudentsPoint3 => 'Դիտեք ձեր արդյունքները հարց առ հարց';

  @override
  String get landingCtaTitle => 'Պատրա՞ստ եք սկսելու';

  @override
  String get landingCtaSub => 'Մուտք գործեք և կազմակերպեք ձեր կենտրոնը։';

  @override
  String get signIn => 'Մուտք գործել';

  @override
  String get registrationButton => 'Գրանցում';

  @override
  String get registrationTitle => 'Կապ հաստատեք մեզ հետ';

  @override
  String get registrationSub =>
      'Թողեք ձեր էլ. փոստը և հեռախոսահամարը, և մենք շուտով կկապվենք ձեզ հետ։';

  @override
  String get registrationEmailLabel => 'Էլ. փոստ';

  @override
  String get registrationPhoneLabel => 'Հեռախոսահամար';

  @override
  String get registrationPhonePlaceholder => '+374 55 123456';

  @override
  String get registrationSubmit => 'Ուղարկել հայտը';

  @override
  String get registrationSending => 'Ուղարկվում է…';

  @override
  String get registrationSuccessTitle => 'Շնորհակալություն։';

  @override
  String get registrationSuccessText =>
      'Ձեր հայտը ստացվել է։ Մենք շուտով կկապվենք ձեզ հետ։';

  @override
  String get registrationClose => 'Փակել';

  @override
  String get registrationInvalidEmail => 'Մուտքագրեք ճիշտ էլ. հասցե։';

  @override
  String get registrationInvalidPhone =>
      'Մուտքագրեք ճիշտ հեռախոսահամար (օր.՝ +374 55 123456)։';

  @override
  String get errorGeneric => 'Ինչ-որ բան սխալ գնաց։ Փորձեք կրկին։';

  @override
  String get errorServerUnavailable => 'Սերվերը հասանելի չէ։ Փորձեք կրկին։';

  @override
  String registrationTooMany(String time) {
    return 'Չափազանց շատ հայտեր։ Կրկին փորձեք $time հետո։';
  }

  @override
  String durationSeconds(int n) {
    return '$n վրկ';
  }

  @override
  String durationMinutes(int n) {
    return '$n րոպե';
  }

  @override
  String get onboardingSkip => 'Բաց թողնել';

  @override
  String get onboardingNext => 'Հաջորդը';

  @override
  String get languageLabel => 'Լեզու';

  @override
  String get loginComingSoon => 'Մուտքի էջը շուտով կավելացվի։';

  @override
  String get onboardingReplay => 'Կրկին դիտել ներածությունը';

  @override
  String get loginWelcome => 'Բարի վերադարձ 👋';

  @override
  String get loginSubtitle =>
      'Մուտք գործեք՝ շարունակելու ձեր ուսումնական ճանապարհը։';

  @override
  String get loginEmail => 'Էլ. փոստ';

  @override
  String get loginPassword => 'Գաղտնաբառ';

  @override
  String get loginForgot => 'Մոռացե՞լ եք';

  @override
  String get passwordShow => 'Ցույց տալ';

  @override
  String get passwordHide => 'Թաքցնել';

  @override
  String get loginRemember => 'Հիշել ինձ';

  @override
  String get loginSignIn => 'Մուտք';

  @override
  String get loginSigningIn => 'Մուտք է կատարվում…';

  @override
  String get loginInvalid => 'Սխալ էլ. փոստ կամ գաղտնաբառ։';

  @override
  String get loginUnavailable => 'Սերվերը հասանելի չէ։ Փորձեք կրկին։';

  @override
  String get loginTooMany =>
      'Չափազանց շատ փորձեր։ Խնդրում ենք փորձել ավելի ուշ։';

  @override
  String loginRetryIn(String time) {
    return 'Կրկին փորձեք $time հետո';
  }

  @override
  String get loginResetPassword => 'Վերականգնել գաղտնաբառը';

  @override
  String get loginResetUnlocks =>
      'Գաղտնաբառը վերականգնելով՝ հաշիվն անմիջապես կապակողպվի։';

  @override
  String get loginInactive =>
      'Ձեր կազմակերպությունն ակտիվ չէ։ Խնդրում ենք կապվել աջակցության հետ։';

  @override
  String get loginResetSuccess =>
      'Գաղտնաբառը վերականգնված է։ Մուտք գործեք նորով։';

  @override
  String get loginWordLearn => 'Սովորիր';

  @override
  String get loginWordDiscover => 'Բացահայտիր';

  @override
  String get loginWordGrow => 'Զարգացիր';

  @override
  String get loginWordAchieve => 'Հասիր նպատակիդ';

  @override
  String get forgotTitle => 'Վերականգնել գաղտնաբառը';

  @override
  String get forgotSubtitle =>
      'Մուտքագրեք ձեր էլ. փոստը, և մենք ձեզ կուղարկենք 6 նիշանոց կոդ՝ այն վերականգնելու համար։';

  @override
  String get forgotEmailLabel => 'Էլ. փոստ';

  @override
  String get forgotSubmit => 'Ուղարկել կոդը';

  @override
  String get forgotSending => 'Ուղարկվում է…';

  @override
  String get forgotBackToLogin => 'Վերադառնալ մուտք գործելուն';

  @override
  String forgotTooMany(int minutes) {
    return 'Չափազանց շատ փորձեր։ Կրկին փորձեք $minutes րոպեից։';
  }

  @override
  String get forgotStep2Title => 'Մուտքագրեք կոդը';

  @override
  String forgotStep2Subtitle(String email) {
    return 'Ստուգեք $email հասցեում 6 նիշանոց կոդը, ապա սահմանեք նոր գաղտնաբառ։';
  }

  @override
  String get forgotChangeEmail => 'Օգտագործել այլ էլ. փոստ';

  @override
  String get forgotCodeLabel => 'Էլ. փոստով ստացված կոդը';

  @override
  String get forgotCodePlaceholder => '000000';

  @override
  String get forgotCodeInvalid =>
      'Մուտքագրեք էլ. փոստով ստացված 6 նիշանոց կոդը։';

  @override
  String get forgotPasswordLabel => 'Նոր գաղտնաբառ';

  @override
  String get forgotConfirmLabel => 'Հաստատեք նոր գաղտնաբառը';

  @override
  String get forgotPasswordRule => '8–32 նիշ։ տառեր, թվեր և !@#\$%^&*։';

  @override
  String get forgotMismatch => 'Գաղտնաբառերը չեն համընկնում։';

  @override
  String get forgotSubmitReset => 'Վերականգնել գաղտնաբառը';

  @override
  String get forgotResetting => 'Վերականգնվում է…';

  @override
  String get forgotResendCode => 'Ուղարկել նոր կոդ';

  @override
  String forgotResendCodeIn(int seconds) {
    return 'Ուղարկել նոր կոդ ($seconds վրկ)';
  }

  @override
  String get forgotResendSent => 'Նոր կոդն արդեն ճանապարհին է։';

  @override
  String homeWelcome(String name) {
    return 'Բարի վերադարձ, $name';
  }

  @override
  String get logout => 'Դուրս գալ';

  @override
  String get logoutConfirmTitle => 'Դուրս գա՞լ Studyfy-ից։';

  @override
  String get logoutConfirmDescription =>
      'Հաշիվ նորից մտնելու համար անհրաժեշտ կլինի կրկին մուտք գործել։';

  @override
  String get cancel => 'Չեղարկել';

  @override
  String get forgotCodeIncorrect =>
      'Կոդը սխալ է կամ ժամկետանց։ Ստուգեք էլ. նամակը կամ ստացեք նոր կոդ։';

  @override
  String get loginAdminNotSupported =>
      'Ադմինիստրատորի հաշիվները կառավարվում են Studyfy կայքում։ Այս հավելվածը ուսուցիչների և աշակերտների համար է։';

  @override
  String get loginSessionExpired =>
      'Ձեր աշխատաշրջանն ավարտվել է։ Խնդրում ենք կրկին մուտք գործել։';

  @override
  String get roleTeacher => 'Ուսուցիչ';

  @override
  String get roleStudent => 'Աշակերտ';

  @override
  String get roleAdmin => 'Ադմինիստրատոր';

  @override
  String get loginNewSchool => 'Նո՞ր կենտրոն եք։ Կապ հաստատեք մեզ հետ';

  @override
  String get loginPasswordRequired => 'Մուտքագրեք գաղտնաբառը։';

  @override
  String get tabSubjects => 'Առարկաներ';

  @override
  String get tabSessions => 'Պարապմունքներ';

  @override
  String get tabHomework => 'Տնային առաջադրանքներ';

  @override
  String get tabMyHomework => 'Իմ առաջադրանքները';

  @override
  String get profileRole => 'Դեր';

  @override
  String get profileSchool => 'Ուսումնական կենտրոն';

  @override
  String get profileEmail => 'Էլ. փոստ';

  @override
  String get profileMemberSince => 'Անդամ է';

  @override
  String get tabProfile => 'Պրոֆիլ';

  @override
  String get settingsTitle => 'Կարգավորումներ';

  @override
  String get settingsAppearance => 'Տեսք';

  @override
  String get themeSystem => 'Համակարգային';

  @override
  String get themeLight => 'Լուսավոր';

  @override
  String get themeDark => 'Մութ';

  @override
  String get privacyPolicy => 'Գաղտնիության քաղաքականություն';

  @override
  String get termsOfUse => 'Օգտագործման պայմաններ';

  @override
  String get tabHome => 'Գլխավոր';

  @override
  String get homeSubtitle =>
      'Եվս մեկ շաբաթ՝ հրաշալի առաջընթացով։ Շարունակե՛ք նույն ոգով։';

  @override
  String get homeTimetableTitle => 'Շաբաթվա ժամանակացույց';

  @override
  String get homeTimetableSubtitle => 'Կրկնվող պարապմունքները ըստ օրերի։';

  @override
  String get homeTimetableViewCalendar => 'Ամբողջ օրացույցը';

  @override
  String get homeTimetableNextSession => 'Հաջորդ պարապմունքը';

  @override
  String get homeTimetableEmptyTitle => 'Պարապմունքներ դեռ չկան';

  @override
  String get homeTimetableLoadError => 'Չհաջողվեց բեռնել ժամանակացույցը։';

  @override
  String get homeTimetableLiveNow => 'Ընթանում է հիմա';

  @override
  String get sessionToday => 'Այսօր';

  @override
  String get sessionNoSessionsDay => 'Պարապմունք չկա';

  @override
  String get sessionMorning => 'Առավոտ (մինչև 12:00)';

  @override
  String get sessionAfternoon => 'Ցերեկ (12:00–17:00)';

  @override
  String get sessionEvening => 'Երեկո (17:00-ից)';

  @override
  String get sessionJoinCall => 'Միանալ զանգին';

  @override
  String get sessionTypeGroup => 'Խմբային';

  @override
  String get sessionTypeIndividual => 'Անհատական';

  @override
  String sessionUnknownGroup(int id) {
    return 'Խումբ #$id';
  }

  @override
  String sessionUnknownStudent(int id) {
    return 'Աշակերտ #$id';
  }

  @override
  String get weekdayMonday => 'Երկուշաբթի';

  @override
  String get weekdayTuesday => 'Երեքշաբթի';

  @override
  String get weekdayWednesday => 'Չորեքշաբթի';

  @override
  String get weekdayThursday => 'Հինգշաբթի';

  @override
  String get weekdayFriday => 'Ուրբաթ';

  @override
  String get weekdaySaturday => 'Շաբաթ';

  @override
  String get weekdaySunday => 'Կիրակի';

  @override
  String get sessionsTitle => 'Պարապմունքներ';

  @override
  String get sessionsSubtitle =>
      'Շաբաթական կրկնվող խմբային և անհատական պարապմունքներ։';

  @override
  String get sessionsEmptyTitle => 'Պարապմունքներ դեռ չկան';

  @override
  String get sessionsLoadError => 'Չհաջողվեց բեռնել պարապմունքները։';

  @override
  String get callPageTitle => 'Տեսազանգ';

  @override
  String get callLobbyTitle => 'Պատրա՞ստ եք միանալ';

  @override
  String get callLobbySubtitle =>
      'Մուտք գործելուց առաջ ստուգեք տեսախցիկը և խոսափողը։';

  @override
  String get callGroupSession => 'Խմբային դաս';

  @override
  String get callIndividualSession => 'Անհատական դաս';

  @override
  String callWeekly(String day, String time) {
    return '$day, ժամը $time, ամեն շաբաթ';
  }

  @override
  String get callJoinNow => 'Միանալ';

  @override
  String get callJoining => 'Միացում…';

  @override
  String callJoinAs(String name) {
    return 'Դուք կմիանաք որպես $name';
  }

  @override
  String get callHostNote => 'Դուք կմիանաք որպես այս դասի կազմակերպիչը։';

  @override
  String get callOneDeviceNote =>
      'Այստեղ միանալը կավարտի ձեր զանգը մյուս ներդիրներում կամ սարքերում։';

  @override
  String get callCameraOff => 'Տեսախցիկն անջատված է';

  @override
  String get callCameraBlocked =>
      'Տեսախցիկի հասանելիությունն արգելափակված է։ Թույլատրեք այն հեռախոսի կարգավորումներում, որպեսզի մյուսները ձեզ տեսնեն։';

  @override
  String get callMicBlocked =>
      'Խոսափողի հասանելիությունն արգելափակված է։ Թույլատրեք այն հեռախոսի կարգավորումներում, որպեսզի մյուսները ձեզ լսեն։';

  @override
  String get callDeviceBusy =>
      'Տեսախցիկը կամ խոսափողը չհաջողվեց միացնել։ Հնարավոր է՝ այն օգտագործվում է այլ ծրագրի կողմից։';

  @override
  String get callTurnOnMic => 'Միացնել խոսափողը';

  @override
  String get callTurnOffMic => 'Անջատել խոսափողը';

  @override
  String get callTurnOnCamera => 'Միացնել տեսախցիկը';

  @override
  String get callTurnOffCamera => 'Անջատել տեսախցիկը';

  @override
  String get callSwitchCamera => 'Փոխել տեսախցիկը';

  @override
  String get callSwitchCameraError => 'Չհաջողվեց փոխել տեսախցիկը։';

  @override
  String get callShowParticipants => 'Մասնակիցներ';

  @override
  String get callLeave => 'Լքել զանգը';

  @override
  String get callLive => 'Ուղիղ';

  @override
  String get callYou => 'Դուք';

  @override
  String get callHost => 'Կազմակերպիչ';

  @override
  String callInCall(int count) {
    return 'Զանգում՝ $count';
  }

  @override
  String get callAloneTitle => 'Դուք այստեղ միայնակ եք';

  @override
  String get callAloneDescription => 'Մյուսները կհայտնվեն միանալուն պես։';

  @override
  String get callReconnecting => 'Կապը կորավ։ Վերամիացում…';

  @override
  String get callPoorConnection => 'Թույլ կապ';

  @override
  String get callMuted => 'Խոսափողն անջատված է';

  @override
  String callJoinedToast(String name) {
    return '$name — միացավ';
  }

  @override
  String callLeftToast(String name) {
    return '$name — դուրս եկավ';
  }

  @override
  String get callMutedByHost => 'Կազմակերպիչն անջատեց ձեր խոսափողը։';

  @override
  String get callMediaError => 'Տեսախցիկը կամ խոսափողը չհաջողվեց միացնել։';

  @override
  String get callLeftTitle => 'Դուք լքեցիք զանգը';

  @override
  String get callLeftDescription => 'Կարող եք կրկին միանալ ցանկացած պահի։';

  @override
  String get callDuplicateTitle => 'Դուք միացաք այլ ներդիրից կամ սարքից';

  @override
  String get callDuplicateDescription =>
      'Զանգը կարող է բաց լինել միայն մեկ տեղում, ուստի այստեղ այն անջատվեց։';

  @override
  String get callRemovedTitle => 'Ձեզ հեռացրին զանգից';

  @override
  String get callRemovedDescription => 'Կազմակերպիչը ձեզ հեռացրեց այս զանգից։';

  @override
  String get callEndedTitle => 'Զանգն ավարտվեց';

  @override
  String get callEndedDescription => 'Կազմակերպիչը փակեց սենյակը։';

  @override
  String get callLostTitle => 'Կապը կորավ';

  @override
  String get callLostDescription => 'Չհաջողվեց ձեզ կրկին միացնել զանգին։';

  @override
  String get callForbiddenTitle => 'Դուք չեք կարող միանալ այս զանգին';

  @override
  String get callForbiddenDescription =>
      'Միանալ կարող են միայն այս դասի ուսուցիչներն ու աշակերտները։';

  @override
  String get callUnavailableTitle => 'Տեսազանգերը դեռ հասանելի չեն';

  @override
  String get callUnavailableDescription =>
      'Տեսազանգերը կարգավորված չեն սերվերում։ Խնդրում ենք փորձել ավելի ուշ։';

  @override
  String get callErrorTitle => 'Չհաջողվեց միանալ զանգին';

  @override
  String get callErrorDescription => 'Ստուգեք ինտերնետ կապը և կրկին փորձեք։';

  @override
  String get callNotFoundTitle => 'Դասը չի գտնվել';

  @override
  String get callNotFoundDescription =>
      'Հնարավոր է՝ այն ջնջվել է, կամ դուք դրա մասնակից չեք։';

  @override
  String get callRejoin => 'Կրկին միանալ';

  @override
  String get callTryAgain => 'Կրկին փորձել';

  @override
  String get sessionsSegmentGroups => 'Խմբեր';

  @override
  String get sessionsFilterAllTypes => 'Բոլոր տեսակները';

  @override
  String get sessionsFilterAllDays => 'Բոլոր օրերը';

  @override
  String get sessionsNoMatches => 'Այս ֆիլտրերին համապատասխան պարապմունք չկա։';

  @override
  String get groupsTitle => 'Խմբեր';

  @override
  String get groupsSubtitle => 'Աշակերտների կրկին օգտագործվող ցուցակներ։';

  @override
  String get groupsEmptyTitle => 'Խմբեր դեռ չկան';

  @override
  String get groupsLoadError => 'Չհաջողվեց բեռնել խմբերը։';

  @override
  String groupMembers(int count) {
    return '$count անդամ';
  }
}
