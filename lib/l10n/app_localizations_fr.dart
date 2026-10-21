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
  String get homeBannerDialogTitle => 'Image de la bannière';

  @override
  String get homeBannerDialogSubtitle =>
      'Affichée à droite de la bannière de l\'accueil, pour vous et pour les élèves de cette matière.';

  @override
  String get homeBannerNoSubjects => 'Ajoutez d\'abord une matière.';

  @override
  String get homeBannerSubjectLabel => 'Matière';

  @override
  String get homeBannerPreviewLabel => 'Aperçu';

  @override
  String get homeBannerChoosePicture => 'Choisir une image';

  @override
  String get homeBannerSizeHint =>
      'Taille idéale : 1600 × 400 px (4:1). Au moins 1200 × 300 px.';

  @override
  String get homeBannerFormatHint =>
      'JPEG, PNG, GIF ou WebP, jusqu\'à 10 Mo. Placez l\'essentiel à droite : la partie gauche s\'estompe sous le texte.';

  @override
  String homeBannerTooSmallWarning(int width, int height) {
    return 'Cette image fait $width × $height px, elle risque donc d\'être floue. Utilisez au moins 1200 × 300 px.';
  }

  @override
  String get homeBannerTooTallWarning =>
      'Cette image est beaucoup plus haute que la bannière : le haut et le bas seront coupés. Une image large (environ 4:1) convient mieux.';

  @override
  String get homeBannerRemovePicture => 'Supprimer l\'image';

  @override
  String get homeBannerSavePicture => 'Enregistrer l\'image';

  @override
  String get homeBannerUploadError => 'Impossible de mettre à jour l\'image.';

  @override
  String get homeBannerRemoveError => 'Impossible de supprimer l\'image.';

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

  @override
  String get tabStudents => 'Élèves';

  @override
  String get studentsTitle => 'Élèves';

  @override
  String get studentsSubtitle => 'Les élèves de votre partenaire.';

  @override
  String get studentsEmptyTitle => 'Aucun élève pour l\'instant';

  @override
  String get studentsLoadError => 'Impossible de charger les élèves.';

  @override
  String get sessionsAddSession => 'Ajouter un cours';

  @override
  String get sessionsAddModalTitle => 'Ajouter un cours';

  @override
  String get sessionsEditModalTitle => 'Modifier le cours';

  @override
  String get sessionsCreate => 'Créer le cours';

  @override
  String get sessionsSave => 'Enregistrer les modifications';

  @override
  String get sessionsSaving => 'Enregistrement…';

  @override
  String get sessionsEdit => 'Modifier';

  @override
  String get sessionsDelete => 'Supprimer';

  @override
  String get sessionsDeleteConfirmTitle => 'Supprimer ce cours ?';

  @override
  String get sessionsDeleteConfirmDescription =>
      'Cette action est irréversible.';

  @override
  String get sessionsDeleting => 'Suppression…';

  @override
  String get sessionsCreateError => 'Impossible de créer le cours.';

  @override
  String get sessionsUpdateError => 'Impossible de modifier le cours.';

  @override
  String get sessionsDeleteError => 'Impossible de supprimer le cours.';

  @override
  String get sessionsServerUnavailable =>
      'Serveur indisponible. Veuillez réessayer.';

  @override
  String get sessionsNoGroups =>
      'Créez d\'abord un groupe pour planifier un cours collectif.';

  @override
  String get sessionsNoStudents =>
      'Inscrivez d\'abord un élève pour planifier un cours individuel.';

  @override
  String get sessionsTypeLabel => 'Type';

  @override
  String get sessionsGroupLabel => 'Groupe';

  @override
  String get sessionsStudentLabel => 'Élève';

  @override
  String get sessionsDayLabel => 'Jour de la semaine';

  @override
  String get sessionsTimeLabel => 'Heure de début';

  @override
  String get groupsAddGroup => 'Ajouter un groupe';

  @override
  String get groupsEmptyDescription =>
      'Cliquez sur « Ajouter un groupe » pour créer le premier.';

  @override
  String get groupsNameLabel => 'Nom';

  @override
  String get groupsNamePlaceholder => 'ex. : Débutants du mardi';

  @override
  String get groupsMembersLabel => 'Élèves (facultatif)';

  @override
  String get groupsNoStudentsHint => 'Aucun élève inscrit pour l\'instant.';

  @override
  String get groupsAddModalTitle => 'Ajouter un groupe';

  @override
  String get groupsRenameModalTitle => 'Renommer le groupe';

  @override
  String get groupsCreate => 'Créer le groupe';

  @override
  String get groupsSave => 'Enregistrer les modifications';

  @override
  String get groupsSaving => 'Enregistrement…';

  @override
  String get groupsRename => 'Renommer';

  @override
  String get groupsDelete => 'Supprimer';

  @override
  String groupsDeleteConfirmTitle(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String get groupsDeleteConfirmDescription =>
      'Les cours de ce groupe seront aussi supprimés. Cette action est irréversible.';

  @override
  String get groupsDeleting => 'Suppression…';

  @override
  String get groupsCreateError => 'Impossible de créer le groupe.';

  @override
  String get groupsUpdateError => 'Impossible de modifier le groupe.';

  @override
  String get groupsDeleteError => 'Impossible de supprimer le groupe.';

  @override
  String get groupsServerUnavailable =>
      'Serveur indisponible. Veuillez réessayer.';

  @override
  String get groupDetailMembersTitle => 'Membres';

  @override
  String get groupDetailNoMembers =>
      'Aucun élève dans ce groupe pour l’instant.';

  @override
  String get groupDetailAddMember => 'Ajouter';

  @override
  String get groupDetailSelectStudent => 'Élève';

  @override
  String get groupDetailAllAdded =>
      'Tous les élèves font déjà partie de ce groupe.';

  @override
  String get groupDetailAddMemberError => 'Impossible d\'ajouter l\'élève.';

  @override
  String get groupDetailRemoveMember => 'Retirer';

  @override
  String get groupDetailRemoveMemberError => 'Impossible de retirer l\'élève.';

  @override
  String get groupDetailNotFoundTitle => 'Groupe introuvable';

  @override
  String get groupDetailNotFoundDescription =>
      'Il a peut-être déjà été supprimé.';

  @override
  String homeStatsNewThisWeek(int count) {
    return '+$count cette semaine';
  }

  @override
  String get homeActivityTitle => 'Activité de la semaine';

  @override
  String get homeActivityEmpty => 'Aucune tentative cette semaine.';

  @override
  String get homeActivityDetails => 'Voir les détails';

  @override
  String homeActivityAttempts(int count) {
    return '$count tentatives';
  }

  @override
  String get homeActivityTotal => 'Tentatives';

  @override
  String get homeActivityAverage => 'Score moyen';

  @override
  String get homeActivityBest => 'Meilleur score';

  @override
  String get resultsRecentTitle => 'Résultats récents';

  @override
  String get resultsViewAll => 'Tout voir';

  @override
  String get resultsPageTitle => 'Résultats';

  @override
  String get resultsPageSubtitleTeacher =>
      'Les tentatives de test de vos élèves.';

  @override
  String get resultsPageSubtitleStudent => 'Vos tentatives de test.';

  @override
  String get resultsFilterAllStudents => 'Tous les élèves';

  @override
  String get resultsFilterAllTests => 'Tous les tests';

  @override
  String get resultsAverage => 'Moyenne';

  @override
  String get resultsBest => 'Meilleur';

  @override
  String get resultsEmptyTitle => 'Aucun résultat pour l’instant.';

  @override
  String get resultsLoadError => 'Impossible de charger les résultats.';

  @override
  String resultsUnknownTest(int id) {
    return 'Test #$id';
  }

  @override
  String get resultDetailYourAnswer => 'Votre réponse';

  @override
  String get resultDetailCorrectAnswer => 'Bonne réponse';

  @override
  String get resultDetailCorrect => 'Correct';

  @override
  String get resultDetailIncorrect => 'Incorrect';

  @override
  String get resultDetailNotFoundTitle => 'Résultat introuvable';

  @override
  String get studentsAddStudent => 'Ajouter un élève';

  @override
  String get studentsEmptyDescription =>
      'Cliquez sur « Ajouter un élève » pour inscrire le premier.';

  @override
  String get studentsFilterAll => 'Toutes les matières';

  @override
  String get studentsNameLabel => 'Prénom';

  @override
  String get studentsSurnameLabel => 'Nom (facultatif)';

  @override
  String get studentsEmailLabel => 'E-mail';

  @override
  String get studentsPasswordLabel => 'Mot de passe';

  @override
  String get studentsPasswordHint =>
      '8 à 32 caractères : lettres, chiffres ou !@#\$%^&*';

  @override
  String get studentsSubjectLabel => 'Matière';

  @override
  String get studentsNoSubjects =>
      'Créez d\'abord une matière avant d\'inscrire un élève.';

  @override
  String get studentsCreate => 'Inscrire l\'élève';

  @override
  String get studentsSaving => 'Enregistrement…';

  @override
  String get studentsCreateError => 'Impossible d\'inscrire l\'élève.';

  @override
  String get studentsEmailTaken => 'Cette adresse e-mail est déjà enregistrée.';

  @override
  String get studentsDelete => 'Supprimer';

  @override
  String studentsDeleteConfirmTitle(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String get studentsDeleteConfirmDescription =>
      'Cette action est irréversible.';

  @override
  String get studentsDeletePasswordPrompt =>
      'Confirmez votre mot de passe pour continuer.';

  @override
  String get studentsDeletePasswordIncorrect =>
      'Ce mot de passe est incorrect.';

  @override
  String get studentsDeleteForbidden =>
      'Cet élève suit aussi la matière d\'un autre enseignant : seul le propriétaire de l\'école peut le supprimer.';

  @override
  String get studentsDeleting => 'Suppression…';

  @override
  String get studentsDeleteError => 'Impossible de supprimer l\'élève.';

  @override
  String get studentsServerUnavailable =>
      'Serveur indisponible. Veuillez réessayer.';

  @override
  String get studentsBackToStudents => 'Retour aux élèves';

  @override
  String get studentsRegisteredLabel => 'Date d\'inscription';

  @override
  String get studentsNotFoundTitle => 'Élève introuvable';

  @override
  String get studentsNotFoundDescription =>
      'Cet élève a peut-être déjà été supprimé.';

  @override
  String get studentsTestResultsTitle => 'Résultats des tests';

  @override
  String get studentsResultsEmptyHint =>
      'Les résultats apparaîtront ici une fois que les élèves auront terminé des tests.';

  @override
  String get subjectsTitle => 'Matières';

  @override
  String get subjectsSubtitle => 'Les matières de votre école.';

  @override
  String get subjectsEmptyTitle => 'Aucune matière pour l\'instant';

  @override
  String get subjectsEmptyDescription =>
      'Cliquez sur « Ajouter une matière » pour créer la première.';

  @override
  String get subjectsLoadError => 'Impossible de charger les matières.';

  @override
  String get subjectsAddSubject => 'Ajouter une matière';

  @override
  String get subjectsNamePlaceholder => 'p. ex. Anglais';

  @override
  String get subjectsAddModalTitle => 'Ajouter une matière';

  @override
  String get subjectsRenameModalTitle => 'Renommer la matière';

  @override
  String get subjectsCreate => 'Créer la matière';

  @override
  String get subjectsSave => 'Enregistrer les modifications';

  @override
  String get subjectsRename => 'Renommer';

  @override
  String get subjectsDelete => 'Supprimer';

  @override
  String get subjectsActivate => 'Activer';

  @override
  String get subjectsDeactivate => 'Désactiver';

  @override
  String get subjectsActiveLabel => 'Active';

  @override
  String get subjectsInactiveLabel => 'Inactive';

  @override
  String subjectsDeleteConfirmTitle(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String get subjectsDeleteConfirmDescription =>
      'Cela supprime aussi ses niveaux, tests et questions. Cette action est irréversible.';

  @override
  String get subjectsCreateError => 'Impossible de créer la matière.';

  @override
  String get subjectsUpdateError => 'Impossible de mettre à jour la matière.';

  @override
  String get subjectsDeleteError => 'Impossible de supprimer la matière.';

  @override
  String get subjectsActivateError =>
      'Impossible de mettre à jour le statut de cette matière.';

  @override
  String get subjectsServerUnavailable =>
      'Serveur indisponible. Veuillez réessayer.';

  @override
  String get subjectDetailBackToSubjects => 'Retour aux matières';

  @override
  String get subjectDetailNotFoundDescription =>
      'Cette matière a peut-être déjà été supprimée.';

  @override
  String get subjectDetailCreatedLabel => 'Créée le';

  @override
  String get subjectDetailTabTests => 'Tests';

  @override
  String get subjectDetailTabLevels => 'Niveaux';

  @override
  String get subjectDetailEdit => 'Modifier';

  @override
  String get subjectDetailNoLevelsHint =>
      'Ajoutez un niveau (p. ex. A1) avant de créer des tests.';

  @override
  String get subjectDetailGenerateWithAi => 'Générer avec l\'IA';

  @override
  String get subjectDetailAddTest => 'Ajouter un test';

  @override
  String get subjectDetailTestsEmptyTitle => 'Aucun test pour l\'instant';

  @override
  String get subjectDetailTestsEmptyDescription =>
      'Ajoutez un test manuellement, ou générez-en un avec l\'IA.';

  @override
  String get subjectDetailTestsLoadError => 'Impossible de charger les tests.';

  @override
  String get subjectDetailAddTestModalTitle => 'Ajouter un test';

  @override
  String get subjectDetailEditTestModalTitle => 'Modifier le test';

  @override
  String get subjectDetailTestTitlePlaceholder => 'Titre';

  @override
  String get subjectDetailTimeLimitLabel =>
      'Durée limite en minutes (laisser vide pour aucune limite)';

  @override
  String get subjectDetailTimeLimitHint => 'p. ex. 45';

  @override
  String get subjectDetailCreateTest => 'Créer le test';

  @override
  String get subjectDetailTestCreateError => 'Impossible de créer le test.';

  @override
  String get subjectDetailTestUpdateError =>
      'Impossible de mettre à jour le test.';

  @override
  String get subjectDetailTestDeleteError => 'Impossible de supprimer le test.';

  @override
  String subjectDetailDeleteTestConfirmTitle(String title) {
    return 'Supprimer « $title » ?';
  }

  @override
  String get subjectDetailDeleteTestConfirmDescription =>
      'Cela supprime aussi ses questions. Cette action est irréversible.';

  @override
  String get subjectDetailAddLevel => 'Ajouter un niveau';

  @override
  String get subjectDetailLevelNamePlaceholder => 'p. ex. A1';

  @override
  String get subjectDetailAddLevelModalTitle => 'Ajouter un niveau';

  @override
  String get subjectDetailRenameLevelModalTitle => 'Renommer le niveau';

  @override
  String get subjectDetailCreateLevel => 'Créer le niveau';

  @override
  String get subjectDetailLevelsEmptyTitle => 'Aucun niveau pour l\'instant';

  @override
  String get subjectDetailLevelsEmptyDescription =>
      'Ajoutez un niveau (p. ex. A1) pour commencer à créer des tests.';

  @override
  String get subjectDetailLevelsLoadError =>
      'Impossible de charger les niveaux.';

  @override
  String get subjectDetailLevelCreateError => 'Impossible de créer le niveau.';

  @override
  String get subjectDetailLevelUpdateError =>
      'Impossible de mettre à jour le niveau.';

  @override
  String get subjectDetailLevelDeleteError =>
      'Impossible de supprimer le niveau.';

  @override
  String subjectDetailDeleteLevelConfirmTitle(String name) {
    return 'Supprimer « $name » ?';
  }

  @override
  String get subjectDetailDeleteLevelConfirmDescription =>
      'Cela supprime aussi ses tests et questions. Cette action est irréversible.';

  @override
  String get subjectDetailGenerateModalTitle => 'Générer un test avec l\'IA';

  @override
  String get subjectDetailGenerateTopicPlaceholder =>
      'Sujet, p. ex. Verbes irréguliers au passé';

  @override
  String get subjectDetailGenerateQuestionCountLabel => 'Questions (1–30)';

  @override
  String get subjectDetailGenerateQuestionTypeMixed => 'Mixte';

  @override
  String get subjectDetailGenerateQuestionTypeMultipleChoice =>
      'Choix multiple';

  @override
  String get subjectDetailGenerateQuestionTypeText => 'Texte';

  @override
  String get subjectDetailGenerateTitleLabel => 'Titre (facultatif)';

  @override
  String get subjectDetailGenerateInstructionsLabel =>
      'Instructions pour l\'IA (facultatif)';

  @override
  String get subjectDetailGenerateButton => 'Générer';

  @override
  String get subjectDetailGenerating =>
      'Génération en cours… cela peut prendre jusqu\'à une minute.';

  @override
  String get subjectDetailGenerateFailed =>
      'Impossible de générer un test. Veuillez réessayer.';

  @override
  String get subjectDetailGenerateRateLimited =>
      'Vous avez atteint la limite horaire de génération de tests par IA. Réessayez plus tard.';

  @override
  String get subjectDetailGenerateUnavailable =>
      'La génération de tests par IA n\'est pas activée pour cette école.';

  @override
  String subjectDetailGenerateSuccess(int generated, int requested) {
    return '$generated question(s) générée(s) sur $requested. Relisez-le avant de le publier.';
  }

  @override
  String get testDetailNotFoundDescription =>
      'Ce test a peut-être déjà été supprimé.';

  @override
  String get testDetailDraftBannerTitle =>
      'Brouillon — invisible pour les élèves';

  @override
  String get testDetailDiscardDraft => 'Abandonner le brouillon';

  @override
  String get testDetailPublishTest => 'Publier le test';

  @override
  String get testDetailPublishError => 'Impossible de mettre à jour le test.';

  @override
  String get testDetailDiscardDraftConfirmTitle => 'Abandonner ce brouillon ?';

  @override
  String get testDetailDiscardDraftConfirmDescription =>
      'Cela supprime aussi le test et ses questions. Cette action est irréversible.';

  @override
  String get testDetailDiscardError => 'Impossible d\'abandonner le brouillon.';

  @override
  String get testDetailUntimedLabel => 'Sans limite';

  @override
  String testDetailMinutesLabel(int minutes) {
    return '$minutes min';
  }

  @override
  String get testDetailTabQuestions => 'Questions';

  @override
  String testDetailTabResults(int count) {
    return 'Résultats ($count)';
  }

  @override
  String testDetailTabHomework(int count) {
    return 'Devoirs ($count)';
  }

  @override
  String get testDetailQuestionsSubtitle =>
      'Les questions de ce test apparaissent ici.';

  @override
  String get testDetailAddQuestion => 'Ajouter une question';

  @override
  String get testDetailQuestionsLoadError =>
      'Impossible de charger les questions.';

  @override
  String get testDetailFreeTextLabel => 'Texte libre';

  @override
  String testDetailExpectedAnswerLabel(String answer) {
    return 'Réponse attendue : $answer';
  }

  @override
  String get testDetailDeleteQuestionConfirmTitle =>
      'Supprimer cette question ?';

  @override
  String get testDetailDeleteQuestionConfirmDescription =>
      'Cette action est irréversible.';

  @override
  String get testDetailQuestionDeleteError =>
      'Impossible de supprimer la question.';

  @override
  String get testDetailResultsEmptyTitle => 'Aucune tentative pour le moment.';

  @override
  String get testDetailHomeworkEmptyTitle =>
      'Pas encore assigné à qui que ce soit.';

  @override
  String get testDetailQuestionFormAddTitle => 'Ajouter une question';

  @override
  String get testDetailQuestionFormEditTitle => 'Modifier la question';

  @override
  String get testDetailQuestionLabel => 'Question';

  @override
  String get testDetailQuestionTextPlaceholder => 'Texte de la question';

  @override
  String get testDetailQuestionTypeLabel => 'Type';

  @override
  String testDetailOptionLabel(String letter) {
    return 'Option $letter';
  }

  @override
  String testDetailOptionOptionalLabel(String letter) {
    return 'Option $letter (facultatif)';
  }

  @override
  String get testDetailCorrectAnswerLabel => 'Bonne option';

  @override
  String get testDetailExpectedTextAnswerPlaceholder => 'Réponse attendue';

  @override
  String get testDetailImageLabel => 'Image (facultatif)';

  @override
  String get testDetailAddImage => 'Ajouter une image';

  @override
  String get testDetailImageHelpExisting =>
      'Choisissez une nouvelle image pour la remplacer, ou laissez ce champ vide pour conserver l\'actuelle. JPEG, PNG, GIF ou WebP, jusqu\'à 10 Mo.';

  @override
  String get testDetailImageHelpNew =>
      'JPEG, PNG, GIF ou WebP, jusqu\'à 10 Mo.';

  @override
  String get testDetailVideoPlaceholder => 'Lien vidéo (facultatif)';

  @override
  String get testDetailVideoHint => 'https://…';

  @override
  String get testDetailSaveQuestion => 'Enregistrer la question';

  @override
  String get testDetailQuestionCreateError =>
      'Impossible d\'ajouter la question.';

  @override
  String get testDetailQuestionUpdateError =>
      'Impossible de mettre à jour la question.';

  @override
  String get homeworkTitleTeacher => 'Devoirs';

  @override
  String get homeworkTitleStudent => 'Mes devoirs';

  @override
  String get homeworkSubtitleTeacher =>
      'Attribuez des devoirs aux élèves et suivez leur progression.';

  @override
  String get homeworkSubtitleStudent => 'Tous vos devoirs au même endroit.';

  @override
  String get homeworkSearchHint => 'Rechercher un devoir…';

  @override
  String get homeworkAssignButton => 'Attribuer';

  @override
  String get homeworkStatusAll => 'Tous';

  @override
  String get homeworkStatusPending => 'En attente';

  @override
  String get homeworkStatusOverdue => 'En retard';

  @override
  String get homeworkStatusCompleted => 'Terminés';

  @override
  String get homeworkFilterAllTypes => 'Tous les devoirs';

  @override
  String get homeworkFilterAllStudents => 'Tous les élèves';

  @override
  String get homeworkKindTest => 'Test';

  @override
  String get homeworkKindTask => 'Tâche';

  @override
  String get homeworkEmptyTitleTeacher =>
      'Aucun devoir pour l\'instant. Attribuez un test à vos élèves.';

  @override
  String get homeworkEmptyTitleStudent =>
      'Aucun devoir pour l\'instant. Profitez-en !';

  @override
  String get homeworkNoMatches => 'Aucun devoir ne correspond à vos filtres.';

  @override
  String get homeworkLoadError => 'Impossible de charger les devoirs.';

  @override
  String get homeworkAssignModalTitle => 'Attribuer un devoir';

  @override
  String get homeworkTestLabel => 'Test';

  @override
  String get homeworkNoActiveTests =>
      'Publiez d\'abord un test avant de l\'attribuer comme devoir.';

  @override
  String get homeworkTaskTitlePlaceholder => 'Titre';

  @override
  String get homeworkMaxGradeHint => 'Note maximale (100 par défaut)';

  @override
  String get homeworkDueDateLabel => 'Date limite';

  @override
  String get homeworkNoDueDate => 'Aucune date limite';

  @override
  String get homeworkNoteHint => 'Note pour l\'élève (facultatif)';

  @override
  String get homeworkAssignToLabel => 'Attribuer à';

  @override
  String get homeworkGroupsLabel => 'Groupes';

  @override
  String get homeworkStudentsLabel => 'Élèves';

  @override
  String get homeworkNoStudentsHint =>
      'Inscrivez d\'abord un élève avant d\'attribuer un devoir.';

  @override
  String get homeworkAssignError => 'Impossible d\'attribuer ce devoir.';

  @override
  String get homeworkServerUnavailable =>
      'Serveur indisponible. Veuillez réessayer.';

  @override
  String homeworkDueOn(String date) {
    return 'À rendre le $date';
  }

  @override
  String get homeworkNoteLabel => 'Note';

  @override
  String homeworkTimeLimitMinutes(int minutes) {
    return 'Durée limite : $minutes minutes';
  }

  @override
  String get homeworkViewResult => 'Voir le résultat';

  @override
  String get homeworkTestUnavailable =>
      'Ce test n\'est pas disponible pour le moment.';

  @override
  String get homeworkStartTest => 'Commencer le test';

  @override
  String get homeworkStartTestComingSoon =>
      'Passer les tests depuis ici arrive bientôt.';

  @override
  String homeworkMaxGradeValue(int max) {
    return 'Sur $max points';
  }

  @override
  String get homeworkMaterialsLabel => 'Documents';

  @override
  String get homeworkSubmissionFilesLabel => 'Fichiers rendus';

  @override
  String get homeworkUploadFile => 'Importer un fichier';

  @override
  String get homeworkLoadFilesError => 'Impossible de charger les fichiers.';

  @override
  String get homeworkNoFiles => 'Aucun fichier pour l\'instant.';

  @override
  String get homeworkUploadError => 'Impossible d\'importer ce fichier.';

  @override
  String get homeworkDeleteFileError => 'Impossible de supprimer ce fichier.';

  @override
  String get homeworkSubmissionLabel => 'Réponse';

  @override
  String get homeworkNoSubmissionYet => 'Pas encore rendu.';

  @override
  String get homeworkGradeButton => 'Noter';

  @override
  String get homeworkSubmissionHint => 'Écrivez votre réponse…';

  @override
  String get homeworkSubmitButton => 'Rendre';

  @override
  String get homeworkResubmitButton => 'Rendre à nouveau';

  @override
  String get homeworkSubmitError => 'Impossible de rendre ce devoir.';

  @override
  String get homeworkUnlockButton => 'Déverrouiller';

  @override
  String get homeworkUnlockError => 'Impossible de déverrouiller cette note.';

  @override
  String get homeworkGradeModalTitle => 'Noter la réponse';

  @override
  String homeworkGradeHint(int max) {
    return 'Note sur $max';
  }

  @override
  String get homeworkFeedbackHint => 'Commentaire (facultatif)';

  @override
  String get homeworkGradeError => 'Impossible d\'enregistrer cette note.';

  @override
  String get homeworkSaveGrade => 'Enregistrer la note';

  @override
  String get homeworkEditModalTitle => 'Modifier le devoir';

  @override
  String get homeworkUpdateError => 'Impossible de mettre à jour ce devoir.';

  @override
  String get homeworkEdit => 'Modifier';

  @override
  String get homeworkDelete => 'Supprimer';

  @override
  String homeworkDeleteConfirmTitle(String title) {
    return 'Supprimer « $title » ?';
  }

  @override
  String get homeworkDeleteConfirmDescription =>
      'Cette action est irréversible.';

  @override
  String get homeworkDeleteError => 'Impossible de supprimer ce devoir.';

  @override
  String get homeworkDetailNotFoundTitle => 'Devoir introuvable';

  @override
  String get homeworkDetailNotFoundDescription =>
      'Il a peut-être déjà été supprimé.';
}
