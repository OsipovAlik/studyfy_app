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
}
