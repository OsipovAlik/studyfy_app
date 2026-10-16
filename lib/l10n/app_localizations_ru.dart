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

  @override
  String get tabSubjects => 'Предметы';

  @override
  String get tabSessions => 'Занятия';

  @override
  String get tabHomework => 'Домашние задания';

  @override
  String get tabMyHomework => 'Мои задания';

  @override
  String get profileRole => 'Роль';

  @override
  String get profileSchool => 'Учебный центр';

  @override
  String get profileEmail => 'E-mail';

  @override
  String get profileMemberSince => 'С нами с';

  @override
  String get tabProfile => 'Профиль';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsAppearance => 'Оформление';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get termsOfUse => 'Условия использования';

  @override
  String get tabHome => 'Главная';

  @override
  String get homeSubtitle =>
      'Ещё одна неделя отличного прогресса. Так держать!';

  @override
  String get homeTimetableTitle => 'Расписание на эту неделю';

  @override
  String get homeTimetableSubtitle => 'Регулярные занятия по дням.';

  @override
  String get homeTimetableViewCalendar => 'Весь календарь';

  @override
  String get homeTimetableNextSession => 'Следующее занятие';

  @override
  String get homeTimetableEmptyTitle => 'Занятий пока нет';

  @override
  String get homeTimetableLoadError => 'Не удалось загрузить расписание.';

  @override
  String get homeTimetableLiveNow => 'Идёт сейчас';

  @override
  String get sessionToday => 'Сегодня';

  @override
  String get sessionNoSessionsDay => 'Нет занятий';

  @override
  String get sessionMorning => 'Утро (до 12:00)';

  @override
  String get sessionAfternoon => 'День (12:00–17:00)';

  @override
  String get sessionEvening => 'Вечер (с 17:00)';

  @override
  String get sessionJoinCall => 'Войти в звонок';

  @override
  String get sessionTypeGroup => 'Групповое';

  @override
  String get sessionTypeIndividual => 'Индивидуальное';

  @override
  String sessionUnknownGroup(int id) {
    return 'Группа №$id';
  }

  @override
  String sessionUnknownStudent(int id) {
    return 'Ученик №$id';
  }

  @override
  String get weekdayMonday => 'Понедельник';

  @override
  String get weekdayTuesday => 'Вторник';

  @override
  String get weekdayWednesday => 'Среда';

  @override
  String get weekdayThursday => 'Четверг';

  @override
  String get weekdayFriday => 'Пятница';

  @override
  String get weekdaySaturday => 'Суббота';

  @override
  String get weekdaySunday => 'Воскресенье';

  @override
  String get sessionsTitle => 'Занятия';

  @override
  String get sessionsSubtitle =>
      'Регулярные групповые и индивидуальные занятия на неделе.';

  @override
  String get sessionsEmptyTitle => 'Занятий пока нет';

  @override
  String get sessionsLoadError => 'Не удалось загрузить занятия.';

  @override
  String get callPageTitle => 'Видеозвонок';

  @override
  String get callLobbyTitle => 'Готовы присоединиться?';

  @override
  String get callLobbySubtitle => 'Проверьте камеру и микрофон перед входом.';

  @override
  String get callGroupSession => 'Групповое занятие';

  @override
  String get callIndividualSession => 'Индивидуальное занятие';

  @override
  String callWeekly(String day, String time) {
    return '$day, $time — каждую неделю';
  }

  @override
  String get callJoinNow => 'Присоединиться';

  @override
  String get callJoining => 'Подключение…';

  @override
  String callJoinAs(String name) {
    return 'Вы войдёте как $name';
  }

  @override
  String get callHostNote => 'Вы войдёте как организатор этого занятия.';

  @override
  String get callOneDeviceNote =>
      'Если войти здесь, звонок на другой вкладке или устройстве завершится.';

  @override
  String get callCameraOff => 'Камера выключена';

  @override
  String get callCameraBlocked =>
      'Доступ к камере заблокирован. Разрешите его в настройках телефона, чтобы другие вас видели.';

  @override
  String get callMicBlocked =>
      'Доступ к микрофону заблокирован. Разрешите его в настройках телефона, чтобы другие вас слышали.';

  @override
  String get callDeviceBusy =>
      'Не удалось запустить камеру или микрофон. Возможно, они заняты другим приложением.';

  @override
  String get callTurnOnMic => 'Включить микрофон';

  @override
  String get callTurnOffMic => 'Выключить микрофон';

  @override
  String get callTurnOnCamera => 'Включить камеру';

  @override
  String get callTurnOffCamera => 'Выключить камеру';

  @override
  String get callSwitchCamera => 'Переключить камеру';

  @override
  String get callSwitchCameraError => 'Не удалось переключить камеру.';

  @override
  String get callShowParticipants => 'Участники';

  @override
  String get callLeave => 'Выйти из звонка';

  @override
  String get callLive => 'В эфире';

  @override
  String get callYou => 'Вы';

  @override
  String get callHost => 'Организатор';

  @override
  String callInCall(int count) {
    return 'В звонке: $count';
  }

  @override
  String get callAloneTitle => 'Вы здесь пока один';

  @override
  String get callAloneDescription =>
      'Остальные появятся, как только присоединятся.';

  @override
  String get callReconnecting => 'Соединение потеряно. Переподключение…';

  @override
  String get callPoorConnection => 'Плохое соединение';

  @override
  String get callMuted => 'Микрофон выключен';

  @override
  String callJoinedToast(String name) {
    return '$name в звонке';
  }

  @override
  String callLeftToast(String name) {
    return '$name покидает звонок';
  }

  @override
  String get callMutedByHost => 'Организатор выключил ваш микрофон.';

  @override
  String get callMediaError => 'Не удалось запустить камеру или микрофон.';

  @override
  String get callLeftTitle => 'Вы вышли из звонка';

  @override
  String get callLeftDescription => 'Вы можете вернуться в любой момент.';

  @override
  String get callDuplicateTitle => 'Вы вошли с другой вкладки или устройства';

  @override
  String get callDuplicateDescription =>
      'Звонок может быть открыт только в одном месте, поэтому здесь он был отключён.';

  @override
  String get callRemovedTitle => 'Вас удалили из звонка';

  @override
  String get callRemovedDescription =>
      'Организатор удалил вас из этого звонка.';

  @override
  String get callEndedTitle => 'Звонок завершён';

  @override
  String get callEndedDescription => 'Организатор закрыл комнату.';

  @override
  String get callLostTitle => 'Соединение потеряно';

  @override
  String get callLostDescription => 'Не удалось снова подключить вас к звонку.';

  @override
  String get callForbiddenTitle => 'Вы не можете присоединиться к этому звонку';

  @override
  String get callForbiddenDescription =>
      'Присоединиться могут только преподаватели и ученики этого занятия.';

  @override
  String get callUnavailableTitle => 'Видеозвонки пока недоступны';

  @override
  String get callUnavailableDescription =>
      'Видеозвонки не настроены на сервере. Попробуйте позже.';

  @override
  String get callErrorTitle => 'Не удалось присоединиться к звонку';

  @override
  String get callErrorDescription =>
      'Проверьте подключение и попробуйте ещё раз.';

  @override
  String get callNotFoundTitle => 'Занятие не найдено';

  @override
  String get callNotFoundDescription =>
      'Возможно, оно удалено или вы в нём не участвуете.';

  @override
  String get callRejoin => 'Присоединиться снова';

  @override
  String get callTryAgain => 'Попробовать снова';

  @override
  String get sessionsSegmentGroups => 'Группы';

  @override
  String get sessionsFilterAllTypes => 'Все типы';

  @override
  String get sessionsFilterAllDays => 'Все дни';

  @override
  String get sessionsNoMatches => 'Нет занятий, подходящих под эти фильтры.';

  @override
  String get groupsTitle => 'Группы';

  @override
  String get groupsSubtitle => 'Списки учеников для повторного использования.';

  @override
  String get groupsEmptyTitle => 'Групп пока нет';

  @override
  String get groupsLoadError => 'Не удалось загрузить группы.';

  @override
  String groupMembers(int count) {
    return 'Участников: $count';
  }

  @override
  String get tabStudents => 'Ученики';

  @override
  String get studentsTitle => 'Ученики';

  @override
  String get studentsSubtitle => 'Ученики вашего партнёра.';

  @override
  String get studentsEmptyTitle => 'Учеников пока нет';

  @override
  String get studentsLoadError => 'Не удалось загрузить учеников.';

  @override
  String get sessionsAddSession => 'Добавить занятие';

  @override
  String get sessionsAddModalTitle => 'Добавить занятие';

  @override
  String get sessionsEditModalTitle => 'Редактировать занятие';

  @override
  String get sessionsCreate => 'Создать занятие';

  @override
  String get sessionsSave => 'Сохранить изменения';

  @override
  String get sessionsSaving => 'Сохранение…';

  @override
  String get sessionsEdit => 'Редактировать';

  @override
  String get sessionsDelete => 'Удалить';

  @override
  String get sessionsDeleteConfirmTitle => 'Удалить это занятие?';

  @override
  String get sessionsDeleteConfirmDescription =>
      'Это действие нельзя отменить.';

  @override
  String get sessionsDeleting => 'Удаление…';

  @override
  String get sessionsCreateError => 'Не удалось создать занятие.';

  @override
  String get sessionsUpdateError => 'Не удалось изменить занятие.';

  @override
  String get sessionsDeleteError => 'Не удалось удалить занятие.';

  @override
  String get sessionsServerUnavailable =>
      'Сервер недоступен. Попробуйте ещё раз.';

  @override
  String get sessionsNoGroups =>
      'Сначала создайте группу, чтобы запланировать групповое занятие.';

  @override
  String get sessionsNoStudents =>
      'Сначала зарегистрируйте ученика, чтобы запланировать индивидуальное занятие.';

  @override
  String get sessionsTypeLabel => 'Тип';

  @override
  String get sessionsGroupLabel => 'Группа';

  @override
  String get sessionsStudentLabel => 'Ученик';

  @override
  String get sessionsDayLabel => 'День недели';

  @override
  String get sessionsTimeLabel => 'Время начала';

  @override
  String get groupsAddGroup => 'Добавить группу';

  @override
  String get groupsEmptyDescription =>
      'Нажмите «Добавить группу», чтобы создать первую.';

  @override
  String get groupsNameLabel => 'Название';

  @override
  String get groupsNamePlaceholder => 'Напр.: Начинающие, вторник';

  @override
  String get groupsMembersLabel => 'Ученики (необязательно)';

  @override
  String get groupsNoStudentsHint => 'Зарегистрированных учеников пока нет.';

  @override
  String get groupsAddModalTitle => 'Добавить группу';

  @override
  String get groupsRenameModalTitle => 'Переименовать группу';

  @override
  String get groupsCreate => 'Создать группу';

  @override
  String get groupsSave => 'Сохранить изменения';

  @override
  String get groupsSaving => 'Сохранение…';

  @override
  String get groupsRename => 'Переименовать';

  @override
  String get groupsDelete => 'Удалить';

  @override
  String groupsDeleteConfirmTitle(String name) {
    return 'Удалить «$name»?';
  }

  @override
  String get groupsDeleteConfirmDescription =>
      'Занятия этой группы тоже будут удалены. Это действие нельзя отменить.';

  @override
  String get groupsDeleting => 'Удаление…';

  @override
  String get groupsCreateError => 'Не удалось создать группу.';

  @override
  String get groupsUpdateError => 'Не удалось изменить группу.';

  @override
  String get groupsDeleteError => 'Не удалось удалить группу.';

  @override
  String get groupsServerUnavailable =>
      'Сервер недоступен. Попробуйте ещё раз.';

  @override
  String get groupDetailMembersTitle => 'Участники';

  @override
  String get groupDetailNoMembers => 'В этой группе пока нет учеников.';

  @override
  String get groupDetailAddMember => 'Добавить';

  @override
  String get groupDetailSelectStudent => 'Ученик';

  @override
  String get groupDetailAllAdded => 'Все ученики уже в этой группе.';

  @override
  String get groupDetailAddMemberError => 'Не удалось добавить ученика.';

  @override
  String get groupDetailRemoveMember => 'Убрать';

  @override
  String get groupDetailRemoveMemberError => 'Не удалось убрать ученика.';

  @override
  String get groupDetailNotFoundTitle => 'Группа не найдена';

  @override
  String get groupDetailNotFoundDescription => 'Возможно, она уже удалена.';
}
