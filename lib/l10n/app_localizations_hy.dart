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
  String get homeBannerDialogTitle => 'Բանների նկար';

  @override
  String get homeBannerDialogSubtitle =>
      'Ցուցադրվում է գլխավոր էջի բանների աջ կողմում՝ ձեզ և այս առարկայի աշակերտներին։';

  @override
  String get homeBannerNoSubjects => 'Նախ ավելացրեք առարկա։';

  @override
  String get homeBannerSubjectLabel => 'Առարկա';

  @override
  String get homeBannerPreviewLabel => 'Նախադիտում';

  @override
  String get homeBannerChoosePicture => 'Ընտրել նկար';

  @override
  String get homeBannerSizeHint =>
      'Լավագույն չափսը՝ 1600 × 400 px (4:1)։ Նվազագույնը՝ 1200 × 300 px։';

  @override
  String get homeBannerFormatHint =>
      'JPEG, PNG, GIF կամ WebP, մինչև 10 ՄԲ։ Հիմնական մասը դրեք աջ կողմում․ ձախ կողմը կծածկվի տեքստի տակ։';

  @override
  String homeBannerTooSmallWarning(int width, int height) {
    return 'Այս նկարը $width × $height px է, ուստի կարող է լղոզված երևալ։ Օգտագործեք առնվազն 1200 × 300 px։';
  }

  @override
  String get homeBannerTooTallWarning =>
      'Այս նկարը բաններից շատ ավելի բարձր է, ուստի դրա վերևն ու ներքևը կկտրվեն։ Ամենալավը կլինի լայն նկարը (մոտ 4:1)։';

  @override
  String get homeBannerRemovePicture => 'Հեռացնել նկարը';

  @override
  String get homeBannerSavePicture => 'Պահպանել նկարը';

  @override
  String get homeBannerUploadError => 'Չհաջողվեց թարմացնել նկարը։';

  @override
  String get homeBannerRemoveError => 'Չհաջողվեց հեռացնել նկարը։';

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

  @override
  String get tabStudents => 'Աշակերտներ';

  @override
  String get studentsTitle => 'Աշակերտներ';

  @override
  String get studentsSubtitle => 'Ձեր գործընկերոջ աշակերտները։';

  @override
  String get studentsEmptyTitle => 'Աշակերտներ դեռ չկան';

  @override
  String get studentsLoadError => 'Չհաջողվեց բեռնել աշակերտներին։';

  @override
  String get sessionsAddSession => 'Ավելացնել պարապմունք';

  @override
  String get sessionsAddModalTitle => 'Ավելացնել պարապմունք';

  @override
  String get sessionsEditModalTitle => 'Խմբագրել պարապմունքը';

  @override
  String get sessionsCreate => 'Ստեղծել պարապմունքը';

  @override
  String get sessionsSave => 'Պահպանել փոփոխությունները';

  @override
  String get sessionsSaving => 'Պահպանվում է…';

  @override
  String get sessionsEdit => 'Խմբագրել';

  @override
  String get sessionsDelete => 'Ջնջել';

  @override
  String get sessionsDeleteConfirmTitle => 'Ջնջե՞լ այս պարապմունքը։';

  @override
  String get sessionsDeleteConfirmDescription =>
      'Այս գործողությունը հնարավոր չէ հետարկել։';

  @override
  String get sessionsDeleting => 'Ջնջվում է…';

  @override
  String get sessionsCreateError => 'Չհաջողվեց ստեղծել պարապմունքը։';

  @override
  String get sessionsUpdateError => 'Չհաջողվեց թարմացնել պարապմունքը։';

  @override
  String get sessionsDeleteError => 'Չհաջողվեց ջնջել պարապմունքը։';

  @override
  String get sessionsServerUnavailable => 'Սերվերը հասանելի չէ։ Փորձեք կրկին։';

  @override
  String get sessionsNoGroups =>
      'Խմբային պարապմունք պլանավորելու համար նախ ստեղծեք խումբ։';

  @override
  String get sessionsNoStudents =>
      'Անհատական պարապմունք պլանավորելու համար նախ գրանցեք աշակերտ։';

  @override
  String get sessionsTypeLabel => 'Տեսակ';

  @override
  String get sessionsGroupLabel => 'Խումբ';

  @override
  String get sessionsStudentLabel => 'Աշակերտ';

  @override
  String get sessionsDayLabel => 'Շաբաթվա օր';

  @override
  String get sessionsTimeLabel => 'Սկսելու ժամը';

  @override
  String get groupsAddGroup => 'Ավելացնել խումբ';

  @override
  String get groupsEmptyDescription =>
      'Սեղմեք «Ավելացնել խումբ»՝ առաջինը ստեղծելու համար։';

  @override
  String get groupsNameLabel => 'Անվանում';

  @override
  String get groupsNamePlaceholder => 'օր.՝ Երեքշաբթի, սկսնակներ';

  @override
  String get groupsMembersLabel => 'Աշակերտներ (կամընտիր)';

  @override
  String get groupsNoStudentsHint => 'Աշակերտներ դեռ գրանցված չեն։';

  @override
  String get groupsAddModalTitle => 'Ավելացնել խումբ';

  @override
  String get groupsRenameModalTitle => 'Վերանվանել խումբը';

  @override
  String get groupsCreate => 'Ստեղծել խումբը';

  @override
  String get groupsSave => 'Պահպանել փոփոխությունները';

  @override
  String get groupsSaving => 'Պահպանվում է…';

  @override
  String get groupsRename => 'Վերանվանել';

  @override
  String get groupsDelete => 'Ջնջել';

  @override
  String groupsDeleteConfirmTitle(String name) {
    return 'Ջնջե՞լ «$name» խումբը։';
  }

  @override
  String get groupsDeleteConfirmDescription =>
      'Կջնջվեն նաև խմբի պարապմունքները։ Այս գործողությունը հնարավոր չէ հետարկել։';

  @override
  String get groupsDeleting => 'Ջնջվում է…';

  @override
  String get groupsCreateError => 'Չհաջողվեց ստեղծել խումբը։';

  @override
  String get groupsUpdateError => 'Չհաջողվեց թարմացնել խումբը։';

  @override
  String get groupsDeleteError => 'Չհաջողվեց ջնջել խումբը։';

  @override
  String get groupsServerUnavailable => 'Սերվերը հասանելի չէ։ Փորձեք կրկին։';

  @override
  String get groupDetailMembersTitle => 'Անդամներ';

  @override
  String get groupDetailNoMembers => 'Այս խմբում դեռ աշակերտներ չկան։';

  @override
  String get groupDetailAddMember => 'Ավելացնել';

  @override
  String get groupDetailSelectStudent => 'Աշակերտ';

  @override
  String get groupDetailAllAdded => 'Բոլոր աշակերտներն արդեն խմբում են։';

  @override
  String get groupDetailAddMemberError => 'Չհաջողվեց ավելացնել աշակերտին։';

  @override
  String get groupDetailRemoveMember => 'Հեռացնել';

  @override
  String get groupDetailRemoveMemberError => 'Չհաջողվեց հեռացնել աշակերտին։';

  @override
  String get groupDetailNotFoundTitle => 'Խումբը չի գտնվել';

  @override
  String get groupDetailNotFoundDescription =>
      'Այն կարող է արդեն ջնջված լինել։';

  @override
  String homeStatsNewThisWeek(int count) {
    return '+$count այս շաբաթ';
  }

  @override
  String get homeActivityTitle => 'Այս շաբաթվա ակտիվությունը';

  @override
  String get homeActivityEmpty => 'Այս շաբաթ դեռ փորձեր չկան։';

  @override
  String get homeActivityDetails => 'Մանրամասն';

  @override
  String homeActivityAttempts(int count) {
    return '$count փորձ';
  }

  @override
  String get homeActivityTotal => 'Փորձեր';

  @override
  String get homeActivityAverage => 'Միջին արդյունք';

  @override
  String get homeActivityBest => 'Լավագույն արդյունք';

  @override
  String get resultsRecentTitle => 'Վերջին արդյունքները';

  @override
  String get resultsViewAll => 'Տեսնել բոլորը';

  @override
  String get resultsPageTitle => 'Արդյունքներ';

  @override
  String get resultsPageSubtitleTeacher => 'Ձեր աշակերտների թեստային փորձերը։';

  @override
  String get resultsPageSubtitleStudent => 'Ձեր թեստային փորձերը։';

  @override
  String get resultsFilterAllStudents => 'Բոլոր աշակերտները';

  @override
  String get resultsFilterAllTests => 'Բոլոր թեստերը';

  @override
  String get resultsAverage => 'Միջին';

  @override
  String get resultsBest => 'Լավագույն';

  @override
  String get resultsEmptyTitle => 'Արդյունքներ դեռ չկան։';

  @override
  String get resultsLoadError => 'Չհաջողվեց բեռնել արդյունքները։';

  @override
  String resultsUnknownTest(int id) {
    return 'Թեստ #$id';
  }

  @override
  String get resultDetailYourAnswer => 'Ձեր պատասխանը';

  @override
  String get resultDetailCorrectAnswer => 'Ճիշտ պատասխանը';

  @override
  String get resultDetailCorrect => 'Ճիշտ';

  @override
  String get resultDetailIncorrect => 'Սխալ';

  @override
  String get resultDetailNotFoundTitle => 'Արդյունքը չի գտնվել';

  @override
  String get studentsAddStudent => 'Ավելացնել աշակերտ';

  @override
  String get studentsEmptyDescription =>
      'Սեղմեք «Ավելացնել աշակերտ»՝ առաջինը գրանցելու համար։';

  @override
  String get studentsFilterAll => 'Բոլոր առարկաները';

  @override
  String get studentsNameLabel => 'Անուն';

  @override
  String get studentsSurnameLabel => 'Ազգանուն (կամընտիր)';

  @override
  String get studentsEmailLabel => 'Էլ. փոստ';

  @override
  String get studentsPasswordLabel => 'Գաղտնաբառ';

  @override
  String get studentsPasswordHint =>
      '8–32 նիշ՝ լատինական տառեր, թվեր կամ !@#\$%^&*';

  @override
  String get studentsSubjectLabel => 'Առարկա';

  @override
  String get studentsNoSubjects =>
      'Աշակերտ գրանցելու համար նախ ստեղծեք առարկա։';

  @override
  String get studentsCreate => 'Գրանցել աշակերտին';

  @override
  String get studentsSaving => 'Պահպանվում է…';

  @override
  String get studentsCreateError => 'Չհաջողվեց գրանցել աշակերտին։';

  @override
  String get studentsEmailTaken => 'Այս էլ. հասցեն արդեն գրանցված է։';

  @override
  String get studentsDelete => 'Ջնջել';

  @override
  String studentsDeleteConfirmTitle(String name) {
    return 'Ջնջե՞լ «$name» աշակերտին։';
  }

  @override
  String get studentsDeleteConfirmDescription =>
      'Այս գործողությունը հնարավոր չէ հետարկել։';

  @override
  String get studentsDeletePasswordPrompt =>
      'Հաստատելու համար մուտքագրեք ձեր գաղտնաբառը։';

  @override
  String get studentsDeletePasswordIncorrect => 'Գաղտնաբառը սխալ է։';

  @override
  String get studentsDeleteForbidden =>
      'Այս աշակերտը սովորում է նաև այլ ուսուցչի առարկա․ ջնջել կարող է միայն դպրոցի սեփականատերը։';

  @override
  String get studentsDeleting => 'Ջնջվում է…';

  @override
  String get studentsDeleteError => 'Չհաջողվեց ջնջել աշակերտին։';

  @override
  String get studentsServerUnavailable => 'Սերվերը հասանելի չէ։ Փորձեք կրկին։';

  @override
  String get studentsBackToStudents => 'Վերադառնալ աշակերտներին';

  @override
  String get studentsRegisteredLabel => 'Գրանցվել է';

  @override
  String get studentsNotFoundTitle => 'Աշակերտը չի գտնվել';

  @override
  String get studentsNotFoundDescription => 'Նա կարող է արդեն ջնջված լինել։';

  @override
  String get studentsTestResultsTitle => 'Թեստերի արդյունքներ';

  @override
  String get studentsResultsEmptyHint =>
      'Արդյունքները կհայտնվեն այստեղ, երբ աշակերտներն ավարտեն թեստերը։';

  @override
  String get subjectsTitle => 'Առարկաներ';

  @override
  String get subjectsSubtitle => 'Ձեր դպրոցի առարկաները։';

  @override
  String get subjectsEmptyTitle => 'Առարկաներ դեռ չկան';

  @override
  String get subjectsEmptyDescription =>
      'Սեղմեք «Ավելացնել առարկա»՝ առաջինը ստեղծելու համար։';

  @override
  String get subjectsLoadError => 'Չհաջողվեց բեռնել առարկաները։';

  @override
  String get subjectsAddSubject => 'Ավելացնել առարկա';

  @override
  String get subjectsNamePlaceholder => 'օր.՝ Անգլերեն';

  @override
  String get subjectsAddModalTitle => 'Ավելացնել առարկա';

  @override
  String get subjectsRenameModalTitle => 'Վերանվանել առարկան';

  @override
  String get subjectsCreate => 'Ստեղծել առարկան';

  @override
  String get subjectsSave => 'Պահպանել փոփոխությունները';

  @override
  String get subjectsRename => 'Վերանվանել';

  @override
  String get subjectsDelete => 'Ջնջել';

  @override
  String get subjectsActivate => 'Ակտիվացնել';

  @override
  String get subjectsDeactivate => 'Անգործուն դարձնել';

  @override
  String get subjectsActiveLabel => 'Ակտիվ';

  @override
  String get subjectsInactiveLabel => 'Անգործուն';

  @override
  String subjectsDeleteConfirmTitle(String name) {
    return 'Ջնջե՞լ «$name» առարկան։';
  }

  @override
  String get subjectsDeleteConfirmDescription =>
      'Սա նաև կջնջի դրա մակարդակները, թեստերը և հարցերը։ Այս գործողությունը հնարավոր չէ հետարկել։';

  @override
  String get subjectsCreateError => 'Չհաջողվեց ստեղծել առարկան։';

  @override
  String get subjectsUpdateError => 'Չհաջողվեց թարմացնել առարկան։';

  @override
  String get subjectsDeleteError => 'Չհաջողվեց ջնջել առարկան։';

  @override
  String get subjectsActivateError =>
      'Չհաջողվեց թարմացնել առարկայի կարգավիճակը։';

  @override
  String get subjectsServerUnavailable => 'Սերվերը հասանելի չէ։ Փորձեք կրկին։';

  @override
  String get subjectDetailBackToSubjects => 'Վերադառնալ առարկաներին';

  @override
  String get subjectDetailNotFoundDescription =>
      'Այս առարկան գուցե արդեն ջնջվել է։';

  @override
  String get subjectDetailCreatedLabel => 'Ստեղծվել է';

  @override
  String get subjectDetailTabTests => 'Թեստեր';

  @override
  String get subjectDetailTabLevels => 'Մակարդակներ';

  @override
  String get subjectDetailEdit => 'Խմբագրել';

  @override
  String get subjectDetailNoLevelsHint =>
      'Ավելացրեք մակարդակ (օր.՝ A1)՝ թեստեր ստեղծելուց առաջ։';

  @override
  String get subjectDetailGenerateWithAi => 'Ստեղծել AI-ով';

  @override
  String get subjectDetailAddTest => 'Ավելացնել թեստ';

  @override
  String get subjectDetailTestsEmptyTitle => 'Թեստեր դեռ չկան';

  @override
  String get subjectDetailTestsEmptyDescription =>
      'Ավելացրեք թեստ ձեռքով կամ ստեղծեք AI-ի միջոցով։';

  @override
  String get subjectDetailTestsLoadError => 'Չհաջողվեց բեռնել թեստերը։';

  @override
  String get subjectDetailAddTestModalTitle => 'Ավելացնել թեստ';

  @override
  String get subjectDetailEditTestModalTitle => 'Խմբագրել թեստը';

  @override
  String get subjectDetailTestTitlePlaceholder => 'Վերնագիր';

  @override
  String get subjectDetailTimeLimitLabel =>
      'Ժամանակի սահմանաչափ՝ րոպեներով (դատարկ թողեք՝ առանց սահմանաչափի)';

  @override
  String get subjectDetailTimeLimitHint => 'օր.՝ 45';

  @override
  String get subjectDetailCreateTest => 'Ստեղծել թեստը';

  @override
  String get subjectDetailTestCreateError => 'Չհաջողվեց ստեղծել թեստը։';

  @override
  String get subjectDetailTestUpdateError => 'Չհաջողվեց թարմացնել թեստը։';

  @override
  String get subjectDetailTestDeleteError => 'Չհաջողվեց ջնջել թեստը։';

  @override
  String subjectDetailDeleteTestConfirmTitle(String title) {
    return 'Ջնջե՞լ «$title» թեստը։';
  }

  @override
  String get subjectDetailDeleteTestConfirmDescription =>
      'Սա նաև կջնջի դրա հարցերը։ Այս գործողությունը հնարավոր չէ հետարկել։';

  @override
  String get subjectDetailAddLevel => 'Ավելացնել մակարդակ';

  @override
  String get subjectDetailLevelNamePlaceholder => 'օր.՝ A1';

  @override
  String get subjectDetailAddLevelModalTitle => 'Ավելացնել մակարդակ';

  @override
  String get subjectDetailRenameLevelModalTitle => 'Վերանվանել մակարդակը';

  @override
  String get subjectDetailCreateLevel => 'Ստեղծել մակարդակը';

  @override
  String get subjectDetailLevelsEmptyTitle => 'Մակարդակներ դեռ չկան';

  @override
  String get subjectDetailLevelsEmptyDescription =>
      'Ավելացրեք մակարդակ (օր.՝ A1)՝ թեստեր ստեղծելը սկսելու համար։';

  @override
  String get subjectDetailLevelsLoadError => 'Չհաջողվեց բեռնել մակարդակները։';

  @override
  String get subjectDetailLevelCreateError => 'Չհաջողվեց ստեղծել մակարդակը։';

  @override
  String get subjectDetailLevelUpdateError => 'Չհաջողվեց թարմացնել մակարդակը։';

  @override
  String get subjectDetailLevelDeleteError => 'Չհաջողվեց ջնջել մակարդակը։';

  @override
  String subjectDetailDeleteLevelConfirmTitle(String name) {
    return 'Ջնջե՞լ «$name» մակարդակը։';
  }

  @override
  String get subjectDetailDeleteLevelConfirmDescription =>
      'Սա նաև կջնջի դրա թեստերը և հարցերը։ Այս գործողությունը հնարավոր չէ հետարկել։';

  @override
  String get subjectDetailGenerateModalTitle => 'Ստեղծել թեստ AI-ով';

  @override
  String get subjectDetailGenerateTopicPlaceholder =>
      'Թեմա, օր.՝ Անկանոն բայեր անցյալ ժամանակով';

  @override
  String get subjectDetailGenerateQuestionCountLabel => 'Հարցեր (1–30)';

  @override
  String get subjectDetailGenerateQuestionTypeMixed => 'Խառը';

  @override
  String get subjectDetailGenerateQuestionTypeMultipleChoice =>
      'Բազմակի ընտրություն';

  @override
  String get subjectDetailGenerateQuestionTypeText => 'Տեքստ';

  @override
  String get subjectDetailGenerateTitleLabel => 'Վերնագիր (կամընտիր)';

  @override
  String get subjectDetailGenerateInstructionsLabel =>
      'Հրահանգներ AI-ի համար (կամընտիր)';

  @override
  String get subjectDetailGenerateButton => 'Ստեղծել';

  @override
  String get subjectDetailGenerating =>
      'Ստեղծվում է… սա կարող է տևել մինչև մեկ րոպե։';

  @override
  String get subjectDetailGenerateFailed =>
      'Չհաջողվեց ստեղծել թեստը։ Փորձեք կրկին։';

  @override
  String get subjectDetailGenerateRateLimited =>
      'Այս ժամվա համար AI-ով թեստ ստեղծելու սահմանաչափը սպառվել է։ Փորձեք ավելի ուշ։';

  @override
  String get subjectDetailGenerateUnavailable =>
      'AI-ով թեստ ստեղծելը միացված չէ այս դպրոցի համար։';

  @override
  String subjectDetailGenerateSuccess(int generated, int requested) {
    return 'Ստեղծվեց $requested-ից $generated հարց։ Վերանայեք այն՝ նախքան հրապարակելը։';
  }

  @override
  String get testDetailNotFoundDescription => 'Այս թեստը գուցե արդեն ջնջվել է։';

  @override
  String get testDetailDraftBannerTitle => 'Սևագիր — ուսանողներին անտեսանելի';

  @override
  String get testDetailDiscardDraft => 'Ջնջել սևագիրը';

  @override
  String get testDetailPublishTest => 'Հրապարակել թեստը';

  @override
  String get testDetailPublishError => 'Չհաջողվեց թարմացնել թեստը։';

  @override
  String get testDetailDiscardDraftConfirmTitle => 'Ջնջե՞լ այս սևագիրը։';

  @override
  String get testDetailDiscardDraftConfirmDescription =>
      'Սա կջնջի թեստը և դրա հարցերը։ Այս գործողությունը հնարավոր չէ հետարկել։';

  @override
  String get testDetailDiscardError => 'Չհաջողվեց ջնջել սևագիրը։';

  @override
  String get testDetailUntimedLabel => 'Առանց սահմանաչափի';

  @override
  String testDetailMinutesLabel(int minutes) {
    return '$minutes րոպե';
  }

  @override
  String get testDetailTabQuestions => 'Հարցեր';

  @override
  String testDetailTabResults(int count) {
    return 'Արդյունքներ ($count)';
  }

  @override
  String testDetailTabHomework(int count) {
    return 'Տնային առաջադրանքներ ($count)';
  }

  @override
  String get testDetailQuestionsSubtitle =>
      'Այս թեստի հարցերը կհայտնվեն այստեղ։';

  @override
  String get testDetailAddQuestion => 'Ավելացնել հարց';

  @override
  String get testDetailQuestionsLoadError => 'Չհաջողվեց բեռնել հարցերը։';

  @override
  String get testDetailFreeTextLabel => 'Ազատ տեքստ';

  @override
  String testDetailExpectedAnswerLabel(String answer) {
    return 'Ակնկալվող պատասխան՝ $answer';
  }

  @override
  String get testDetailDeleteQuestionConfirmTitle => 'Ջնջե՞լ այս հարցը։';

  @override
  String get testDetailDeleteQuestionConfirmDescription =>
      'Այս գործողությունը հնարավոր չէ հետարկել։';

  @override
  String get testDetailQuestionDeleteError => 'Չհաջողվեց ջնջել հարցը։';

  @override
  String get testDetailResultsEmptyTitle => 'Դեռ փորձեր չկան։';

  @override
  String get testDetailHomeworkEmptyTitle => 'Դեռ ոչ ոքի չի նշանակվել։';

  @override
  String get testDetailQuestionFormAddTitle => 'Ավելացնել հարց';

  @override
  String get testDetailQuestionFormEditTitle => 'Խմբագրել հարցը';

  @override
  String get testDetailQuestionLabel => 'Հարց';

  @override
  String get testDetailQuestionTextPlaceholder => 'Հարցի տեքստը';

  @override
  String get testDetailQuestionTypeLabel => 'Տեսակ';

  @override
  String testDetailOptionLabel(String letter) {
    return 'Տարբերակ $letter';
  }

  @override
  String testDetailOptionOptionalLabel(String letter) {
    return 'Տարբերակ $letter (ըստ ցանկության)';
  }

  @override
  String get testDetailCorrectAnswerLabel => 'Ճիշտ տարբերակ';

  @override
  String get testDetailExpectedTextAnswerPlaceholder => 'Ակնկալվող պատասխան';

  @override
  String get testDetailImageLabel => 'Նկար (ըստ ցանկության)';

  @override
  String get testDetailAddImage => 'Ավելացնել նկար';

  @override
  String get testDetailImageHelpExisting =>
      'Ընտրեք նոր նկար՝ այն փոխարինելու համար, կամ թողեք դատարկ՝ ընթացիկը պահպանելու համար։ JPEG, PNG, GIF կամ WebP, մինչև 10 ՄԲ։';

  @override
  String get testDetailImageHelpNew => 'JPEG, PNG, GIF կամ WebP, մինչև 10 ՄԲ։';

  @override
  String get testDetailVideoPlaceholder => 'Տեսանյութի հղում (ըստ ցանկության)';

  @override
  String get testDetailVideoHint => 'https://…';

  @override
  String get testDetailSaveQuestion => 'Պահպանել հարցը';

  @override
  String get testDetailQuestionCreateError => 'Չհաջողվեց ավելացնել հարցը։';

  @override
  String get testDetailQuestionUpdateError => 'Չհաջողվեց թարմացնել հարցը։';

  @override
  String get homeworkTitleTeacher => 'Տնային առաջադրանքներ';

  @override
  String get homeworkTitleStudent => 'Իմ առաջադրանքները';

  @override
  String get homeworkSubtitleTeacher =>
      'Հանձնարարեք առաջադրանքներ աշակերտներին և հետևեք նրանց առաջընթացին։';

  @override
  String get homeworkSubtitleStudent => 'Ձեր բոլոր առաջադրանքները՝ մեկ տեղում։';

  @override
  String get homeworkSearchHint => 'Որոնել առաջադրանք…';

  @override
  String get homeworkAssignButton => 'Հանձնարարել';

  @override
  String get homeworkStatusAll => 'Բոլորը';

  @override
  String get homeworkStatusPending => 'Սպասվող';

  @override
  String get homeworkStatusOverdue => 'Ժամկետանց';

  @override
  String get homeworkStatusCompleted => 'Ավարտված';

  @override
  String get homeworkFilterAllTypes => 'Բոլոր առաջադրանքները';

  @override
  String get homeworkFilterAllStudents => 'Բոլոր աշակերտները';

  @override
  String get homeworkKindTest => 'Թեստ';

  @override
  String get homeworkKindTask => 'Առաջադրանք';

  @override
  String get homeworkEmptyTitleTeacher =>
      'Առաջադրանքներ դեռ չկան։ Հանձնարարեք թեստ ձեր աշակերտներին։';

  @override
  String get homeworkEmptyTitleStudent =>
      'Առաջադրանքներ դեռ չկան։ Վայելեք ազատ ժամանակը։';

  @override
  String get homeworkNoMatches =>
      'Ձեր ֆիլտրերին համապատասխանող առաջադրանք չկա։';

  @override
  String get homeworkLoadError => 'Չհաջողվեց բեռնել առաջադրանքները։';

  @override
  String get homeworkAssignModalTitle => 'Հանձնարարել առաջադրանք';

  @override
  String get homeworkTestLabel => 'Թեստ';

  @override
  String get homeworkNoActiveTests =>
      'Նախ հրապարակեք թեստ՝ այն որպես առաջադրանք հանձնարարելուց առաջ։';

  @override
  String get homeworkTaskTitlePlaceholder => 'Վերնագիր';

  @override
  String get homeworkMaxGradeHint => 'Առավելագույն միավոր (լռելյայն՝ 100)';

  @override
  String get homeworkAttachmentLabel => 'Կցված ֆայլ (ըստ ցանկության)';

  @override
  String get homeworkDueDateLabel => 'Վերջնաժամկետ';

  @override
  String get homeworkDetailsLabel => 'Մանրամասներ';

  @override
  String get homeworkStatusLabel => 'Կարգավիճակ';

  @override
  String get homeworkTypeLabel => 'Տեսակ';

  @override
  String get homeworkStudentLabel => 'Աշակերտ';

  @override
  String get homeworkAssignedLabel => 'Նշանակվել է';

  @override
  String get homeworkTestNotHandedIn => 'Դեռ չի հանձնվել։';

  @override
  String get homeworkFilesLabel => 'Ֆայլեր';

  @override
  String get homeworkNoDueDate => 'Առանց վերջնաժամկետի';

  @override
  String get homeworkNoteHint => 'Նշում աշակերտի համար (կամընտիր)';

  @override
  String get homeworkAssignToLabel => 'Հանձնարարել';

  @override
  String get homeworkGroupsLabel => 'Խմբեր';

  @override
  String get homeworkStudentsLabel => 'Աշակերտներ';

  @override
  String get homeworkNoStudentsHint =>
      'Նախ գրանցեք աշակերտ՝ առաջադրանք հանձնարարելուց առաջ։';

  @override
  String get homeworkAssignError => 'Չհաջողվեց հանձնարարել առաջադրանքը։';

  @override
  String get homeworkServerUnavailable => 'Սերվերը հասանելի չէ։ Փորձեք կրկին։';

  @override
  String homeworkDueOn(String date) {
    return 'Վերջնաժամկետ՝ $date';
  }

  @override
  String get homeworkNoteLabel => 'Նշում';

  @override
  String homeworkTimeLimitMinutes(int minutes) {
    return 'Ժամանակի սահմանաչափ՝ $minutes րոպե';
  }

  @override
  String get homeworkViewResult => 'Դիտել արդյունքը';

  @override
  String get homeworkTestUnavailable => 'Այս թեստն այժմ հասանելի չէ։';

  @override
  String get homeworkStartTest => 'Սկսել թեստը';

  @override
  String get homeworkStartTestComingSoon =>
      'Այստեղից թեստ հանձնելը շուտով հասանելի կլինի։';

  @override
  String homeworkMaxGradeValue(int max) {
    return '$max միավորից';
  }

  @override
  String get homeworkMaterialsLabel => 'Նյութեր';

  @override
  String get homeworkSubmissionFilesLabel => 'Հանձնված ֆայլեր';

  @override
  String get homeworkUploadFile => 'Վերբեռնել ֆայլ';

  @override
  String get homeworkLoadFilesError => 'Չհաջողվեց բեռնել ֆայլերը։';

  @override
  String get homeworkNoFiles => 'Ֆայլեր դեռ չկան։';

  @override
  String get homeworkUploadError => 'Չհաջողվեց վերբեռնել այս ֆայլը։';

  @override
  String get homeworkDeleteFileError => 'Չհաջողվեց ջնջել այս ֆայլը։';

  @override
  String get homeworkSubmissionLabel => 'Հանձնում';

  @override
  String get homeworkNoSubmissionYet => 'Դեռ չի հանձնվել։';

  @override
  String get homeworkGradeButton => 'Գնահատել';

  @override
  String get homeworkSubmissionHint => 'Գրեք ձեր պատասխանը…';

  @override
  String get homeworkSubmitButton => 'Հանձնել';

  @override
  String get homeworkResubmitButton => 'Կրկին հանձնել';

  @override
  String get homeworkSubmitError => 'Չհաջողվեց հանձնել այս առաջադրանքը։';

  @override
  String get homeworkUnlockButton => 'Ապակողպել';

  @override
  String get homeworkUnlockError => 'Չհաջողվեց ապակողպել այս գնահատականը։';

  @override
  String get homeworkGradeModalTitle => 'Գնահատել հանձնումը';

  @override
  String homeworkGradeHint(int max) {
    return 'Գնահատական $max-ից';
  }

  @override
  String get homeworkFeedbackHint => 'Արձագանք (կամընտիր)';

  @override
  String get homeworkGradeError => 'Չհաջողվեց պահպանել այս գնահատականը։';

  @override
  String get homeworkSaveGrade => 'Պահպանել գնահատականը';

  @override
  String get homeworkEditModalTitle => 'Խմբագրել առաջադրանքը';

  @override
  String get homeworkUpdateError => 'Չհաջողվեց թարմացնել այս առաջադրանքը։';

  @override
  String get homeworkEdit => 'Խմբագրել';

  @override
  String get homeworkDelete => 'Ջնջել';

  @override
  String homeworkDeleteConfirmTitle(String title) {
    return 'Ջնջե՞լ «$title» առաջադրանքը։';
  }

  @override
  String get homeworkDeleteConfirmDescription =>
      'Այս գործողությունը հնարավոր չէ հետարկել։';

  @override
  String get homeworkDeleteError => 'Չհաջողվեց ջնջել այս առաջադրանքը։';

  @override
  String get homeworkDetailNotFoundTitle => 'Առաջադրանքը չի գտնվել';

  @override
  String get homeworkDetailNotFoundDescription => 'Այն գուցե արդեն ջնջվել է։';
}
