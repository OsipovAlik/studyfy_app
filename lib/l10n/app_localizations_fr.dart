// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Studyfy';

  @override
  String get landingBadge => 'Conçu pour les écoles de langues';

  @override
  String get landingHeroLead => 'Tout ce qu\'il faut à votre école pour';

  @override
  String get landingHeroWordTeach => 'enseigner';

  @override
  String get landingHeroWordSchedule => 'planifier';

  @override
  String get landingHeroWordTest => 'évaluer';

  @override
  String get landingHeroWordGrow => 'grandir';

  @override
  String get landingHeroWordSuffix => '';

  @override
  String get landingHeroSub =>
      'Organisez matières et niveaux, créez des tests illustrés, planifiez les cours de la semaine et suivez les résultats de chaque élève — le tout dans un seul espace, simple et agréable.';

  @override
  String get landingChipSessions => 'Cours collectifs et individuels';

  @override
  String get landingChipTests => 'Tests avec images et vidéos';

  @override
  String get landingChipGrading => 'Correction instantanée';

  @override
  String get landingMockTimetable => 'Cette semaine';

  @override
  String get landingMockToday => 'Aujourd\'hui';

  @override
  String get landingMockGroup => 'Groupe';

  @override
  String get landingMockIndividual => 'Individuel';

  @override
  String get landingMockResult => 'Résultat du test';

  @override
  String get landingMockCorrect => 'Bonnes réponses';

  @override
  String get landingMockQuestion => 'Comment dit-on « apple » en français ?';

  @override
  String get landingFeatureTestsTitle => 'Tests et questions';

  @override
  String get landingFeatureTestsDesc =>
      'Questions à choix multiples ou à réponse libre, chacune avec une image et une vidéo facultatives.';

  @override
  String get landingFeatureTimetableTitle => 'Emploi du temps de la semaine';

  @override
  String get landingFeatureTimetableDesc =>
      'Créneaux récurrents collectifs et individuels, avec le cours du jour et le suivant en un coup d\'œil.';

  @override
  String get landingRolesTitle => 'Pensé pour chacun, selon ses besoins';

  @override
  String get landingTeachersTitle => 'Pour les enseignants';

  @override
  String get landingTeachersPoint1 =>
      'Gérez les matières, les niveaux et les tests';

  @override
  String get landingTeachersPoint2 =>
      'Inscrivez des élèves et formez des groupes';

  @override
  String get landingTeachersPoint3 => 'Planifiez les cours de la semaine';

  @override
  String get landingTeachersPoint4 => 'Examinez chaque résultat en détail';

  @override
  String get landingStudentsTitle => 'Pour les élèves';

  @override
  String get landingStudentsPoint1 =>
      'Consultez votre emploi du temps de la semaine';

  @override
  String get landingStudentsPoint2 =>
      'Sachez quand a lieu votre prochain cours';

  @override
  String get landingStudentsPoint3 =>
      'Revoyez vos résultats question par question';

  @override
  String get landingCtaTitle => 'Envie de vous lancer ?';

  @override
  String get landingCtaSub => 'Connectez-vous et organisez votre école.';

  @override
  String get signIn => 'Se connecter';

  @override
  String get registrationButton => 'Inscription';

  @override
  String get registrationTitle => 'Contactez-nous';

  @override
  String get registrationSub =>
      'Laissez votre e-mail et votre numéro de téléphone, nous vous recontacterons rapidement.';

  @override
  String get registrationEmailLabel => 'E-mail';

  @override
  String get registrationPhoneLabel => 'Numéro de téléphone';

  @override
  String get registrationPhonePlaceholder => '+374 55 123456';

  @override
  String get registrationSubmit => 'Envoyer la demande';

  @override
  String get registrationSending => 'Envoi…';

  @override
  String get registrationSuccessTitle => 'Merci !';

  @override
  String get registrationSuccessText =>
      'Nous avons bien reçu votre demande et vous recontacterons rapidement.';

  @override
  String get registrationClose => 'Fermer';

  @override
  String get registrationInvalidEmail => 'Saisissez une adresse e-mail valide.';

  @override
  String get registrationInvalidPhone =>
      'Saisissez un numéro de téléphone valide (ex. : +374 55 123456).';

  @override
  String get errorGeneric => 'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get errorServerUnavailable =>
      'Serveur indisponible. Veuillez réessayer.';

  @override
  String registrationTooMany(String time) {
    return 'Trop de demandes. Réessayez dans $time.';
  }

  @override
  String durationSeconds(int n) {
    return '$n secondes';
  }

  @override
  String durationMinutes(int n) {
    return '$n minutes';
  }

  @override
  String get onboardingSkip => 'Passer';

  @override
  String get onboardingNext => 'Suivant';

  @override
  String get languageLabel => 'Langue';

  @override
  String get loginComingSoon => 'L\'écran de connexion arrive bientôt.';

  @override
  String get onboardingReplay => 'Revoir la présentation';

  @override
  String get loginWelcome => 'Bon retour parmi nous 👋';

  @override
  String get loginSubtitle =>
      'Connectez-vous pour poursuivre votre apprentissage.';

  @override
  String get loginEmail => 'E-mail';

  @override
  String get loginPassword => 'Mot de passe';

  @override
  String get loginForgot => 'Mot de passe oublié ?';

  @override
  String get passwordShow => 'Afficher';

  @override
  String get passwordHide => 'Masquer';

  @override
  String get loginRemember => 'Rester connecté';

  @override
  String get loginSignIn => 'Se connecter';

  @override
  String get loginSigningIn => 'Connexion…';

  @override
  String get loginInvalid => 'E-mail ou mot de passe incorrect.';

  @override
  String get loginUnavailable => 'Serveur indisponible. Veuillez réessayer.';

  @override
  String get loginTooMany =>
      'Trop de tentatives. Veuillez réessayer plus tard.';

  @override
  String loginRetryIn(String time) {
    return 'Réessayez dans $time';
  }

  @override
  String get loginResetPassword => 'Réinitialiser le mot de passe';

  @override
  String get loginResetUnlocks =>
      'La réinitialisation du mot de passe débloque votre compte immédiatement.';

  @override
  String get loginInactive =>
      'Votre organisation est inactive. Veuillez contacter l\'assistance.';

  @override
  String get loginResetSuccess =>
      'Mot de passe réinitialisé. Connectez-vous avec le nouveau.';

  @override
  String get loginWordLearn => 'Apprenez';

  @override
  String get loginWordDiscover => 'Découvrez';

  @override
  String get loginWordGrow => 'Progressez';

  @override
  String get loginWordAchieve => 'Réussissez';

  @override
  String get forgotTitle => 'Réinitialiser votre mot de passe';

  @override
  String get forgotSubtitle =>
      'Saisissez votre e-mail et nous vous enverrons un code à 6 chiffres pour le réinitialiser.';

  @override
  String get forgotEmailLabel => 'E-mail';

  @override
  String get forgotSubmit => 'Envoyer le code';

  @override
  String get forgotSending => 'Envoi…';

  @override
  String get forgotBackToLogin => 'Retour à la connexion';

  @override
  String forgotTooMany(int minutes) {
    return 'Trop de tentatives. Réessayez dans $minutes minutes.';
  }

  @override
  String get forgotStep2Title => 'Saisissez le code';

  @override
  String forgotStep2Subtitle(String email) {
    return 'Vérifiez $email pour un code à 6 chiffres, puis choisissez votre nouveau mot de passe.';
  }

  @override
  String get forgotChangeEmail => 'Utiliser une autre adresse e-mail';

  @override
  String get forgotCodeLabel => 'Code reçu par e-mail';

  @override
  String get forgotCodePlaceholder => '000000';

  @override
  String get forgotCodeInvalid =>
      'Saisissez le code à 6 chiffres reçu par e-mail.';

  @override
  String get forgotPasswordLabel => 'Nouveau mot de passe';

  @override
  String get forgotConfirmLabel => 'Confirmer le nouveau mot de passe';

  @override
  String get forgotPasswordRule =>
      '8 à 32 caractères : lettres, chiffres et !@#\$%^&*.';

  @override
  String get forgotMismatch => 'Les mots de passe ne correspondent pas.';

  @override
  String get forgotSubmitReset => 'Réinitialiser le mot de passe';

  @override
  String get forgotResetting => 'Réinitialisation…';

  @override
  String get forgotResendCode => 'Envoyer un nouveau code';

  @override
  String forgotResendCodeIn(int seconds) {
    return 'Envoyer un nouveau code ($seconds s)';
  }

  @override
  String get forgotResendSent => 'Un nouveau code est en route.';

  @override
  String homeWelcome(String name) {
    return 'Bon retour, $name';
  }

  @override
  String get logout => 'Se déconnecter';

  @override
  String get logoutConfirmTitle => 'Se déconnecter de Studyfy ?';

  @override
  String get logoutConfirmDescription =>
      'Vous devrez vous reconnecter pour accéder à votre compte.';

  @override
  String get cancel => 'Annuler';

  @override
  String get forgotCodeIncorrect =>
      'Le code est incorrect ou a expiré. Vérifiez l\'e-mail ou demandez-en un nouveau.';

  @override
  String get loginAdminNotSupported =>
      'Les comptes administrateur se gèrent sur le site Studyfy. Cette application est destinée aux enseignants et aux élèves.';

  @override
  String get loginSessionExpired =>
      'Votre session a pris fin. Veuillez vous reconnecter.';

  @override
  String get roleTeacher => 'Enseignant';

  @override
  String get roleStudent => 'Élève';

  @override
  String get roleAdmin => 'Administrateur';

  @override
  String get loginNewSchool => 'Nouvelle école ? Contactez-nous';

  @override
  String get loginPasswordRequired => 'Saisissez votre mot de passe.';

  @override
  String get tabSubjects => 'Matières';

  @override
  String get tabSessions => 'Cours';

  @override
  String get tabHomework => 'Devoirs';

  @override
  String get tabMyHomework => 'Mes devoirs';

  @override
  String get profileRole => 'Rôle';

  @override
  String get profileSchool => 'École';

  @override
  String get profileEmail => 'E-mail';

  @override
  String get profileMemberSince => 'Membre depuis';

  @override
  String get tabProfile => 'Profil';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get termsOfUse => 'Conditions d\'utilisation';

  @override
  String get tabHome => 'Accueil';

  @override
  String get homeSubtitle =>
      'Encore une semaine de beaux progrès. Continuez comme ça !';

  @override
  String get homeTimetableTitle => 'Emploi du temps de la semaine';

  @override
  String get homeTimetableSubtitle => 'Cours récurrents, jour par jour.';

  @override
  String get homeTimetableViewCalendar => 'Voir tout le calendrier';

  @override
  String get homeTimetableNextSession => 'Prochain cours';

  @override
  String get homeTimetableEmptyTitle => 'Aucun cours pour l\'instant';

  @override
  String get homeTimetableLoadError =>
      'Impossible de charger l\'emploi du temps.';

  @override
  String get homeTimetableLiveNow => 'En cours';

  @override
  String get sessionToday => 'Aujourd\'hui';

  @override
  String get sessionNoSessionsDay => 'Aucun cours';

  @override
  String get sessionMorning => 'Matin (avant 12h00)';

  @override
  String get sessionAfternoon => 'Après-midi (12h00–17h00)';

  @override
  String get sessionEvening => 'Soir (à partir de 17h00)';

  @override
  String get sessionJoinCall => 'Rejoindre l\'appel';

  @override
  String get sessionTypeGroup => 'Collectif';

  @override
  String get sessionTypeIndividual => 'Individuel';

  @override
  String sessionUnknownGroup(int id) {
    return 'Groupe n° $id';
  }

  @override
  String sessionUnknownStudent(int id) {
    return 'Élève n° $id';
  }

  @override
  String get weekdayMonday => 'Lundi';

  @override
  String get weekdayTuesday => 'Mardi';

  @override
  String get weekdayWednesday => 'Mercredi';

  @override
  String get weekdayThursday => 'Jeudi';

  @override
  String get weekdayFriday => 'Vendredi';

  @override
  String get weekdaySaturday => 'Samedi';

  @override
  String get weekdaySunday => 'Dimanche';

  @override
  String get sessionsTitle => 'Cours';

  @override
  String get sessionsSubtitle =>
      'Cours hebdomadaires récurrents, collectifs et individuels.';

  @override
  String get sessionsEmptyTitle => 'Aucun cours pour l\'instant';

  @override
  String get sessionsLoadError => 'Impossible de charger les cours.';

  @override
  String get callPageTitle => 'Appel vidéo';

  @override
  String get callLobbyTitle => 'Prêt à rejoindre ?';

  @override
  String get callLobbySubtitle =>
      'Vérifiez votre caméra et votre micro avant d\'entrer.';

  @override
  String get callGroupSession => 'Séance de groupe';

  @override
  String get callIndividualSession => 'Séance individuelle';

  @override
  String callWeekly(String day, String time) {
    return '$day à $time, chaque semaine';
  }

  @override
  String get callJoinNow => 'Rejoindre';

  @override
  String get callJoining => 'Connexion…';

  @override
  String callJoinAs(String name) {
    return 'Vous rejoindrez en tant que $name';
  }

  @override
  String get callHostNote => 'Vous rejoindrez en tant qu\'hôte de ce cours.';

  @override
  String get callOneDeviceNote =>
      'Rejoindre ici met fin à votre appel sur tout autre onglet ou appareil.';

  @override
  String get callCameraOff => 'Votre caméra est désactivée';

  @override
  String get callCameraBlocked =>
      'L\'accès à la caméra est bloqué. Autorisez-le dans les réglages de votre téléphone pour que les autres vous voient.';

  @override
  String get callMicBlocked =>
      'L\'accès au micro est bloqué. Autorisez-le dans les réglages de votre téléphone pour que les autres vous entendent.';

  @override
  String get callDeviceBusy =>
      'Votre caméra ou votre micro n\'a pas pu démarrer. Il est peut-être utilisé par une autre application.';

  @override
  String get callTurnOnMic => 'Activer le micro';

  @override
  String get callTurnOffMic => 'Couper le micro';

  @override
  String get callTurnOnCamera => 'Activer la caméra';

  @override
  String get callTurnOffCamera => 'Désactiver la caméra';

  @override
  String get callSwitchCamera => 'Changer de caméra';

  @override
  String get callSwitchCameraError => 'Impossible de changer de caméra.';

  @override
  String get callShowParticipants => 'Participants';

  @override
  String get callLeave => 'Quitter l\'appel';

  @override
  String get callLive => 'En direct';

  @override
  String get callYou => 'Vous';

  @override
  String get callHost => 'Hôte';

  @override
  String callInCall(int count) {
    return '$count dans l\'appel';
  }

  @override
  String get callAloneTitle => 'Vous êtes seul ici';

  @override
  String get callAloneDescription =>
      'Les autres apparaîtront dès qu\'ils rejoindront.';

  @override
  String get callReconnecting => 'Connexion perdue. Reconnexion…';

  @override
  String get callPoorConnection => 'Connexion faible';

  @override
  String get callMuted => 'Micro coupé';

  @override
  String callJoinedToast(String name) {
    return '$name a rejoint';
  }

  @override
  String callLeftToast(String name) {
    return '$name est parti';
  }

  @override
  String get callMutedByHost => 'L\'hôte a coupé votre micro.';

  @override
  String get callMediaError =>
      'Votre caméra ou votre micro n\'a pas pu démarrer.';

  @override
  String get callLeftTitle => 'Vous avez quitté l\'appel';

  @override
  String get callLeftDescription =>
      'Vous pouvez rejoindre à nouveau à tout moment.';

  @override
  String get callDuplicateTitle =>
      'Vous avez rejoint depuis un autre onglet ou appareil';

  @override
  String get callDuplicateDescription =>
      'Un appel ne peut être ouvert qu\'à un seul endroit à la fois, celui-ci a donc été déconnecté.';

  @override
  String get callRemovedTitle => 'Vous avez été retiré de l\'appel';

  @override
  String get callRemovedDescription => 'L\'hôte vous a retiré de cet appel.';

  @override
  String get callEndedTitle => 'L\'appel est terminé';

  @override
  String get callEndedDescription => 'L\'hôte a fermé cette salle.';

  @override
  String get callLostTitle => 'Connexion perdue';

  @override
  String get callLostDescription =>
      'Impossible de vous reconnecter à l\'appel.';

  @override
  String get callForbiddenTitle => 'Vous ne pouvez pas rejoindre cet appel';

  @override
  String get callForbiddenDescription =>
      'Seuls les enseignants et les élèves de cette séance peuvent le rejoindre.';

  @override
  String get callUnavailableTitle =>
      'Les appels vidéo ne sont pas encore disponibles';

  @override
  String get callUnavailableDescription =>
      'Les appels vidéo ne sont pas configurés sur le serveur. Veuillez réessayer plus tard.';

  @override
  String get callErrorTitle => 'Impossible de rejoindre l\'appel';

  @override
  String get callErrorDescription => 'Vérifiez votre connexion et réessayez.';

  @override
  String get callNotFoundTitle => 'Séance introuvable';

  @override
  String get callNotFoundDescription =>
      'Elle a peut-être été supprimée, ou vous n\'en faites pas partie.';

  @override
  String get callRejoin => 'Rejoindre à nouveau';

  @override
  String get callTryAgain => 'Réessayer';

  @override
  String get sessionsSegmentGroups => 'Groupes';

  @override
  String get sessionsFilterAllTypes => 'Tous les types';

  @override
  String get sessionsFilterAllDays => 'Tous les jours';

  @override
  String get sessionsNoMatches => 'Aucun cours ne correspond à ces filtres.';

  @override
  String get groupsTitle => 'Groupes';

  @override
  String get groupsSubtitle => 'Des listes d\'élèves réutilisables.';

  @override
  String get groupsEmptyTitle => 'Aucun groupe pour l\'instant';

  @override
  String get groupsLoadError => 'Impossible de charger les groupes.';

  @override
  String groupMembers(int count) {
    return '$count membre(s)';
  }
}
