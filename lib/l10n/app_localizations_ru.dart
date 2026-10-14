// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Studyfy';

  @override
  String get landingBadge => 'Создано для языковых центров';

  @override
  String get landingHeroLead => 'Всё, что нужно вашему центру, чтобы';

  @override
  String get landingHeroWordTeach => 'обучать';

  @override
  String get landingHeroWordSchedule => 'планировать';

  @override
  String get landingHeroWordTest => 'проверять';

  @override
  String get landingHeroWordGrow => 'расти';

  @override
  String get landingHeroWordSuffix => '';

  @override
  String get landingHeroSub =>
      'Организуйте предметы и уровни, создавайте тесты с картинками, планируйте занятия на неделю и следите за результатами каждого ученика — всё в одном спокойном и красивом месте.';

  @override
  String get landingChipSessions => 'Групповые и индивидуальные занятия';

  @override
  String get landingChipTests => 'Тесты с картинками и видео';

  @override
  String get landingChipGrading => 'Мгновенная проверка';

  @override
  String get landingMockTimetable => 'Эта неделя';

  @override
  String get landingMockToday => 'Сегодня';

  @override
  String get landingMockGroup => 'Групповое';

  @override
  String get landingMockIndividual => 'Индивидуальное';

  @override
  String get landingMockResult => 'Результат теста';

  @override
  String get landingMockCorrect => 'Правильные ответы';

  @override
  String get landingMockQuestion => 'Как по-французски «яблоко»?';

  @override
  String get landingFeatureTestsTitle => 'Тесты и вопросы';

  @override
  String get landingFeatureTestsDesc =>
      'Вопросы с выбором ответа или со свободным ответом, к каждому можно добавить картинку и видео.';

  @override
  String get landingFeatureTimetableTitle => 'Расписание на неделю';

  @override
  String get landingFeatureTimetableDesc =>
      'Регулярные групповые и индивидуальные занятия: сегодняшнее и следующее видны сразу.';

  @override
  String get landingRolesTitle => 'Удобно каждому — по-своему';

  @override
  String get landingTeachersTitle => 'Для учителей';

  @override
  String get landingTeachersPoint1 =>
      'Управляйте предметами, уровнями и тестами';

  @override
  String get landingTeachersPoint2 =>
      'Регистрируйте учеников и создавайте группы';

  @override
  String get landingTeachersPoint3 => 'Планируйте занятия на неделю';

  @override
  String get landingTeachersPoint4 =>
      'Подробно просматривайте каждый результат';

  @override
  String get landingStudentsTitle => 'Для учеников';

  @override
  String get landingStudentsPoint1 => 'Смотрите своё расписание на неделю';

  @override
  String get landingStudentsPoint2 => 'Знайте, когда следующее занятие';

  @override
  String get landingStudentsPoint3 =>
      'Разбирайте свои результаты по каждому вопросу';

  @override
  String get landingCtaTitle => 'Готовы начать?';

  @override
  String get landingCtaSub => 'Войдите и организуйте работу своего центра.';

  @override
  String get signIn => 'Войти';

  @override
  String get registrationButton => 'Регистрация';

  @override
  String get registrationTitle => 'Свяжитесь с нами';

  @override
  String get registrationSub =>
      'Оставьте e-mail и номер телефона — мы скоро с вами свяжемся.';

  @override
  String get registrationEmailLabel => 'E-mail';

  @override
  String get registrationPhoneLabel => 'Номер телефона';

  @override
  String get registrationPhonePlaceholder => '+374 55 123456';

  @override
  String get registrationSubmit => 'Отправить заявку';

  @override
  String get registrationSending => 'Отправка…';

  @override
  String get registrationSuccessTitle => 'Спасибо!';

  @override
  String get registrationSuccessText =>
      'Мы получили вашу заявку и скоро с вами свяжемся.';

  @override
  String get registrationClose => 'Закрыть';

  @override
  String get registrationInvalidEmail => 'Введите корректный адрес e-mail.';

  @override
  String get registrationInvalidPhone =>
      'Введите корректный номер телефона (напр.: +374 55 123456).';

  @override
  String get errorGeneric => 'Что-то пошло не так. Попробуйте ещё раз.';

  @override
  String get errorServerUnavailable => 'Сервер недоступен. Попробуйте ещё раз.';

  @override
  String registrationTooMany(String time) {
    return 'Слишком много заявок. Попробуйте снова через $time.';
  }

  @override
  String durationSeconds(int n) {
    return '$n сек.';
  }

  @override
  String durationMinutes(int n) {
    return '$n мин.';
  }

  @override
  String get onboardingSkip => 'Пропустить';

  @override
  String get onboardingNext => 'Далее';

  @override
  String get languageLabel => 'Язык';

  @override
  String get loginComingSoon => 'Экран входа скоро появится.';

  @override
  String get onboardingReplay => 'Посмотреть вступление снова';

  @override
  String get loginWelcome => 'С возвращением 👋';

  @override
  String get loginSubtitle => 'Войдите, чтобы продолжить обучение.';

  @override
  String get loginEmail => 'E-mail';

  @override
  String get loginPassword => 'Пароль';

  @override
  String get loginForgot => 'Забыли пароль?';

  @override
  String get passwordShow => 'Показать';

  @override
  String get passwordHide => 'Скрыть';

  @override
  String get loginRemember => 'Не выходить из аккаунта';

  @override
  String get loginSignIn => 'Войти';

  @override
  String get loginSigningIn => 'Вход…';

  @override
  String get loginInvalid => 'Неверный e-mail или пароль.';

  @override
  String get loginUnavailable => 'Сервер недоступен. Попробуйте ещё раз.';

  @override
  String get loginTooMany => 'Слишком много попыток. Попробуйте позже.';

  @override
  String loginRetryIn(String time) {
    return 'Повторите через $time';
  }

  @override
  String get loginResetPassword => 'Сбросить пароль';

  @override
  String get loginResetUnlocks =>
      'После сброса пароля аккаунт сразу разблокируется.';

  @override
  String get loginInactive =>
      'Ваша организация неактивна. Обратитесь в службу поддержки.';

  @override
  String get loginResetSuccess => 'Пароль сброшен. Войдите с новым паролем.';

  @override
  String get loginWordLearn => 'Учитесь';

  @override
  String get loginWordDiscover => 'Открывайте';

  @override
  String get loginWordGrow => 'Развивайтесь';

  @override
  String get loginWordAchieve => 'Достигайте';

  @override
  String get forgotTitle => 'Восстановление пароля';

  @override
  String get forgotSubtitle =>
      'Введите свой e-mail, и мы вышлем вам 6-значный код для сброса пароля.';

  @override
  String get forgotEmailLabel => 'E-mail';

  @override
  String get forgotSubmit => 'Отправить код';

  @override
  String get forgotSending => 'Отправка…';

  @override
  String get forgotBackToLogin => 'Назад ко входу';

  @override
  String forgotTooMany(int minutes) {
    return 'Слишком много попыток. Попробуйте снова через $minutes мин.';
  }

  @override
  String get forgotStep2Title => 'Введите код';

  @override
  String forgotStep2Subtitle(String email) {
    return 'Проверьте $email — туда отправлен 6-значный код, затем задайте новый пароль.';
  }

  @override
  String get forgotChangeEmail => 'Использовать другой e-mail';

  @override
  String get forgotCodeLabel => 'Код из письма';

  @override
  String get forgotCodePlaceholder => '000000';

  @override
  String get forgotCodeInvalid => 'Введите 6-значный код из письма.';

  @override
  String get forgotPasswordLabel => 'Новый пароль';

  @override
  String get forgotConfirmLabel => 'Подтвердите новый пароль';

  @override
  String get forgotPasswordRule => '8–32 символа: буквы, цифры и !@#\$%^&*.';

  @override
  String get forgotMismatch => 'Пароли не совпадают.';

  @override
  String get forgotSubmitReset => 'Сбросить пароль';

  @override
  String get forgotResetting => 'Сброс…';

  @override
  String get forgotResendCode => 'Отправить новый код';

  @override
  String forgotResendCodeIn(int seconds) {
    return 'Отправить новый код ($seconds с)';
  }

  @override
  String get forgotResendSent => 'Новый код уже отправлен.';

  @override
  String homeWelcome(String name) {
    return 'С возвращением, $name';
  }

  @override
  String get logout => 'Выйти';

  @override
  String get logoutConfirmTitle => 'Выйти из Studyfy?';

  @override
  String get logoutConfirmDescription =>
      'Чтобы снова попасть в аккаунт, нужно будет войти ещё раз.';

  @override
  String get cancel => 'Отмена';

  @override
  String get forgotCodeIncorrect =>
      'Код неверный или устарел. Проверьте письмо или запросите новый код.';

  @override
  String get loginAdminNotSupported =>
      'Аккаунты администраторов управляются на сайте Studyfy. Это приложение для учителей и учеников.';

  @override
  String get loginSessionExpired =>
      'Ваш сеанс завершён. Пожалуйста, войдите снова.';

  @override
  String get roleTeacher => 'Учитель';

  @override
  String get roleStudent => 'Ученик';

  @override
  String get roleAdmin => 'Администратор';

  @override
  String get loginNewSchool => 'Новый центр? Свяжитесь с нами';

  @override
  String get loginPasswordRequired => 'Введите пароль.';
}
