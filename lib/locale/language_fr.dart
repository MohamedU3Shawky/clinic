import 'languages.dart';

class LanguageFr extends BaseLanguage {
  @override
  String get language => 'Langue';

  @override
  String get badRequest => '400: mauvaise demande';

  @override
  String get forbidden => '403: interdit';

  @override
  String get pageNotFound => '404 Page non trouvée';

  @override
  String get tooManyRequests => '429: trop de demandes';

  @override
  String get internalServerError => '500: Erreur du serveur interne';

  @override
  String get badGateway => '502 Mauvaise passerelle';

  @override
  String get serviceUnavailable => '503 Service Indisponible';

  @override
  String get gatewayTimeout => '504 portail expiré';

  @override
  String get hey => 'Hé';

  @override
  String get hello => 'Bonjour';

  @override
  String get thisFieldIsRequired => 'Ce champ est obligatoire';

  @override
  String get contactNumber => 'Numéro de contact';

  @override
  String get gallery => 'Galerie';

  @override
  String get camera => 'Caméra';

  @override
  String get editProfile => 'Editer le profil';

  @override
  String get update => 'Mise à jour';

  @override
  String get reload => 'Recharger';

  @override
  String get address => 'Adresse';

  @override
  String get viewAll => 'Voir tout';

  @override
  String get pressBackAgainToExitApp => 'Appuyez à nouveau pour quitter l\'application';

  @override
  String get invalidUrl => 'URL invalide';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteAccountConfirmation => 'Votre compte sera supprimé en permanence. Vos données ne seront plus restaurées.';

  @override
  String get demoUserCannotBeGrantedForThis => 'L\'utilisateur de démonstration ne peut pas être accordé pour cette action';

  @override
  String get somethingWentWrong => 'Quelque chose s\'est mal passé';

  @override
  String get yourInternetIsNotWorking => 'Votre Internet ne fonctionne pas';

  @override
  String get profileUpdatedSuccessfully => 'Mise à jour du profil réussie';

  @override
  String get wouldYouLikeToSetProfilePhotoAs => 'Souhaitez-vous définir cette photo comme photo de profil?';

  @override
  String get yourOldPasswordDoesnT => 'Votre ancien mot de passe ne corrige pas!';

  @override
  String get yourNewPasswordDoesnT => 'Votre nouveau mot de passe ne correspond pas à confirmer le mot de passe!';

  @override
  String get location => 'Emplacement';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get submit => 'Soumettre';

  @override
  String get firstName => 'Prénom';

  @override
  String get lastName => 'Nom de famille';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get yourNewPasswordMust => 'Votre nouveau mot de passe doit être différent de votre mot de passe précédent';

  @override
  String get password => 'Mot de passe';

  @override
  String get newPassword => 'nouveau mot de passe';

  @override
  String get confirmNewPassword => 'Confirmer le nouveau mot de passe';

  @override
  String get email => 'E-mail';

  @override
  String get mainStreet => 'Rue principale';

  @override
  String get toResetYourNew => 'Pour réinitialiser votre nouveau mot de passe, veuillez saisir votre adresse e-mail';

  @override
  String get stayTunedNoNew => 'Restez à l\'écoute! Pas de nouvelles notifications.';

  @override
  String get noNewNotificationsAt => 'Pas de nouvelles notifications pour le moment. Nous vous tiendrons au courant lorsqu\'il y aura une mise à jour.';

  @override
  String get signIn => 'Se connecter';

  @override
  String get explore => 'Explorer';

  @override
  String get settings => 'Paramètres';

  @override
  String get rateApp => 'Application de taux';

  @override
  String get aboutApp => 'À propos de l\'application';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get rememberMe => 'Souviens-toi de moi';

  @override
  String get forgotPassword => 'Mot de passe oublié?';

  @override
  String get forgotPasswordTitle => 'Mot de passe oublié';

  @override
  String get registerNow => 'S\'inscrire maintenant';

  @override
  String get createYourAccount => 'Créez votre compte';

  @override
  String get createYourAccountFor => 'Créez votre compte pour une meilleure expérience';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get alreadyHaveAnAccount => 'Vous avez déjà un compte?';

  @override
  String get yourPasswordHasBeen => 'Votre mot de passe a été réinitialisé avec succès';

  @override
  String get youCanNowLog => 'Vous pouvez maintenant vous connecter à votre nouveau compte avec votre nouveau mot de passe';

  @override
  String get done => 'Fait';

  @override
  String get pleaseAcceptTermsAnd => 'Veuillez accepter les termes et conditions';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get eG => 'par exemple.';

  @override
  String get merry => 'Joyeux';

  @override
  String get doe => 'Biche';

  @override
  String get welcomeBackToThe => 'Bienvenue à la';

  @override
  String get welcomeToThe => 'Bienvenue à la';

  @override
  String get doYouWantToLogout => 'Voulez-vous vous connecter?';

  @override
  String get appTheme => 'Thème de l\'application';

  @override
  String get guest => 'Invité';

  @override
  String get notifications => 'Notifications';

  @override
  String get newUpdate => 'Nouvelle mise à jour';

  @override
  String get anUpdateTo => 'Une mise à jour de';

  @override
  String get isAvailableGoTo => 'est disponible. Allez à Play Store et téléchargez la nouvelle version de l\'application.';

  @override
  String get later => 'Plus tard';

  @override
  String get closeApp => 'Fermer l\'application';

  @override
  String get updateNow => 'Mettez à jour maintenant';

  @override
  String get signInFailed => 'La connexion a échoué';

  @override
  String get userCancelled => 'Utilisateur annulé';

  @override
  String get appleSigninIsNot => 'Apple Signin n\'est pas disponible pour votre appareil';

  @override
  String get eventStatus => 'État de l\'événement';

  @override
  String get eventAddedSuccessfully => 'Événement ajouté avec succès';

  @override
  String get notRegistered => 'Non enregistré?';

  @override
  String get signInWithGoogle => 'Connectez-vous avec Google';

  @override
  String get signInWithApple => 'Connectez-vous avec Apple';

  @override
  String get orSignInWith => 'Ou se connecter avec';

  @override
  String get ohNoYouAreLeaving => 'Oh non, tu pars!';

  @override
  String get oldPassword => 'ancien mot de passe';

  @override
  String get oldAndNewPassword => 'Le mot de passe ancien et nouveau sont les mêmes.';

  @override
  String get personalizeYourProfile => 'Personnalisez votre profil';

  @override
  String get themeAndMore => 'Thème et plus';

  @override
  String get showSomeLoveShare => 'Montrez un peu d\'amour, partagez!';

  @override
  String get privacyPolicyTerms => 'Politique de confidentialité, Conditions générales';

  @override
  String get securelyLogOutOfAccount => 'Se déconnecter en toute sécurité';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get successfully => 'Avec succès';

  @override
  String get clearAll => 'Tout effacer';

  @override
  String get notificationDeleted => 'Notification supprimée';

  @override
  String get doYouWantToRemoveNotification => 'Voulez-vous supprimer la notification';

  @override
  String get doYouWantToClearAllNotification => 'Voulez-vous la notification de clairs';

  @override
  String get doYouWantToRemoveImage => 'Voulez-vous supprimer l\'image';

  @override
  String get locationPermissionDenied => 'Permission de localisation refusée';

  @override
  String get enableLocation => 'location disponible';

  @override
  String get permissionDeniedPermanently => 'autorisation refusée en permanence';

  @override
  String get chooseYourLocation => 'Choisissez votre emplacement';

  @override
  String get setAddress => 'Adresse définie';

  @override
  String get sorryUserCannotSignin => 'Désolé l\'utilisateur ne peut pas se connecter';

  @override
  String get iAgreeToThe => 'je suis d\'accord avec le';

  @override
  String get logIn => 'SE CONNECTER';

  @override
  String get country => 'Pays';

  @override
  String get selectCountry => 'Sélectionner le pays';

  @override
  String get state => 'État';

  @override
  String get selectState => 'Sélectionner l\'état';

  @override
  String get city => 'Ville';

  @override
  String get pinCode => 'Code postal';

  @override
  String get selectCity => 'Sélectionner la ville';

  @override
  String get addressLine => 'Adresse';

  @override
  String get searchHere => 'Rechercher ici';

  @override
  String get noDataFound => 'Aucune donnée trouvée';

  @override
  String get checkIn => 'Enregistrement';

  @override
  String get checkout => 'Départ';

  @override
  String get pending => 'En attente';

  @override
  String get completed => 'Terminé';

  @override
  String get confirmed => 'Confirmé';

  @override
  String get cancelled => 'Annulé';

  @override
  String get rejected => 'Rejeté';

  @override
  String get reject => 'Rejeter';

  @override
  String get processing => 'En cours de traitement';

  @override
  String get delivered => 'Livré';

  @override
  String get placed => 'Placé';

  @override
  String get inProgress => 'En cours';

  @override
  String get paid => 'Payé';

  @override
  String get failed => 'Échoué';

  @override
  String get approved => 'Approuvé';

  @override
  String get aboutSelf => 'À propos de soi';

  @override
  String get doYouWantToCancelBooking => 'Voulez-vous annuler la réservation';

  @override
  String get appliedTaxes => "Taxes appliquées";

  @override
  String get appointment => "Rendez-vous";

  @override
  String get online => "En ligne";

  @override
  String get inClinic => "En clinique";

  @override
  String get patient => "Patient";

  @override
  String get doctor => "Médecin";

  @override
  String get payment => "Paiement";

  @override
  String get videoCallLinkIsNotFound => "Le lien d'appel vidéo n'est pas trouvé!";

  @override
  String get thisIsNotAOnlineService => "Ce n'est pas un service en ligne!";

  @override
  String get oppsThisAppointmentIsNotConfirmedYet => "Opps!Ce rendez-vous n'est pas encore confirmé!";

  @override
  String get oppsThisAppointmentHasBeenCancelled => "Opps!Ce rendez-vous a été annulé!";

  @override
  String get oppsThisAppointmentHasBeenCompleted => "Opps!Ce rendez-vous est terminé!";

  @override
  String get dateTime => "Date et heure";

  @override
  String get appointmentType => "Type de rendez-vous";

  @override
  String get searchAppoinmentHere => "Recherchez Appoinment ici";

  @override
  String get noClinicsFoundAtAMoment => "Aucune clinique trouvée à un moment";

  @override
  String get looksLikeThereIsNoClinicsWellKeepYouPostedWhe => "On dirait qu'il n'y a pas de cliniques, nous vous tiendrons au courant lorsqu'il y aura une mise à jour.";

  @override
  String get searchDoctorHere => "Docteur de recherche ici";

  @override
  String get searchPatientHere => "Rechercher le patient ici";

  @override
  String get noPatientFound => "Aucun patient trouvé!";

  @override
  String get oppsNoPatientFoundAtMomentTryAgainLater => "Opps!Aucun patient trouvé au moment, réessayez plus tard.";

  @override
  String get searchServiceHere => "Service de recherche ici";

  @override
  String get noServiceFound => "Aucun service trouvé!";

  @override
  String get oppsNoServiceFoundAtMomentTryAgainLater => "Opps!Aucun service trouvé au moment réessayez plus tard.";

  @override
  String get filterBy => "Filtrer par";

  @override
  String get clearFilter => "Filtre effacer";

  @override
  String get doYouWantToPerformThisAction => "Voulez-vous effectuer cette action?";

  @override
  String get statusHasBeenUpdated => "Le statut a été mis à jour!";

  @override
  String get sessionSummary => "Résumé de la session";

  @override
  String get clinicInfo => "Info à la clinique";

  @override
  String get doctorInfo => "Info docteur";

  @override
  String get patientInfo => "Informations sur les patients";

  @override
  String get aboutService => "À propos du service";

  @override
  String get encounterDetails => "Rencontrez les détails";

  @override
  String get doctorName => "Nom du médecin";

  @override
  String get active => "ACTIF";

  @override
  String get closed => "FERMÉ";

  @override
  String get clinicName => "Nom de la clinique";

  @override
  String get description => "Description";

  @override
  String get usersMustClearPaymentBeforeAccessingCheckout => "Les utilisateurs doivent effacer le paiement avant d'accéder à la caisse";

  @override
  String get paymentDetails => "Détails de paiement";

  @override
  String get price => "Prix";

  @override
  String get discount => "Rabais";

  @override
  String get off => "moins";

  @override
  String get subtotal => "Sous-total";

  @override
  String get tax => "Impôt";

  @override
  String get total => "Total";

  @override
  String get appointments => "Nominations";

  @override
  String get noAppointmentsFound => "Aucun rendez-vous trouvé";

  @override
  String get thereAreCurrentlyNoAppointmentsAvailable => "Il n'y a actuellement aucun rendez-vous disponible.";

  @override
  String get resetYourPassword => "Réinitialisez votre mot de passe";

  @override
  String get enterYourEmailAddressToResetYourNewPassword => "Entrez votre adresse e-mail pour réinitialiser votre nouveau mot de passe.";

  @override
  String get sendCode => "Envoyer le code";

  @override
  String get edit => "MODIFIER";

  @override
  String get gender => "Genre";

  @override
  String get profile => "Profil";

  @override
  String get clinics => "Cliniques";

  @override
  String get manageClinics => "Gérer les cliniques";

  @override
  String get manageSessions => "Gérer les sessions";

  @override
  String get changeOrAddYourSessions => "Changer ou ajouter vos sessions";

  @override
  String get doctors => "Médecins";

  @override
  String get manageDoctors => "Gérer les médecins";

  @override
  String get requests => "Demandes";

  @override
  String get requestForServiceCategoryAndSpecialization => "Demande de service, de catégorie et de spécialisation";

  @override
  String get receptionists => "Réceptionniste";

  @override
  String get allReceptionist => "Toute réceptionniste";

  @override
  String get encounters => "Rencontres";

  @override
  String get manageEncouterData => "Gérer les données de l'encoche";

  @override
  String get userNotCreated => "Utilisateur non créé";

  @override
  String get pleaseSelectRoleToLogin => "Veuillez sélectionner le rôle pour vous connecter!";

  @override
  String get pleaseSelectRoleToRegister => "Veuillez sélectionner le rôle pour vous inscrire!";

  @override
  String get pleaseSelectClinicToRegister => "Veuillez sélectionner la clinique pour vous inscrire!";

  @override
  String get chooseYourRole => "Choisissez votre rôle";

  @override
  String get demoAccounts => "Comptes de démonstration";

  @override
  String get notAMember => "Pas un membre?";

  @override
  String get registerYourAccountForBetterExperience => "Enregistrez votre compte pour une meilleure expérience";

  @override
  String get selectUserRole => "Sélectionner le rôle utilisateur";

  @override
  String get selectClinic => "Sélectionner la clinique";

  @override
  String get termsConditions => "termes et conditions";

  @override
  String get and => "Et";

  @override
  String get privacyPolicy => "politique de confidentialité";

  @override
  String get areYouSureYouWantTonupdateTheService => "Êtes-vous sûr de souhaiter  mettre à jour le service?";

  @override
  String get save => "Sauvegarder";

  @override
  String get allCategory => "Toute catégorie";

  @override
  String get noCategoryFound => "Aucune catégorie trouvée";

  @override
  String get editClinic => "Modifier la clinique";

  @override
  String get addClinic => "Ajouter une clinique";

  @override
  String get clinicImage => "Image clinique";

  @override
  String get chooseImageToUpload => "Choisissez l'image à télécharger";

  @override
  String get chooseSpecialization => "Choisissez une spécialisation";

  @override
  String get searchForSpecialization => "Recherche de spécialisation";

  @override
  String get specialization => "Spécialisation";

  @override
  String get timeSlot => "Créneau horaire";

  @override
  String get chooseCountry => "Choisissez un pays";

  @override
  String get searchForCountry => "Recherche de pays";

  @override
  String get chooseState => "Choisissez l'état";

  @override
  String get searchForState => "Recherche d'état";

  @override
  String get chooseCity => "Choisissez la ville";

  @override
  String get searchForCity => "Rechercher la ville";

  @override
  String get postalCode => "Code Postal";

  @override
  String get latitude => "Latitude";

  @override
  String get longitude => "Longitude";

  @override
  String get writeHere => "Écrivez ici";

  @override
  String get status => "Statut";

  @override
  String get pleaseSelectAClinicImage => "Veuillez sélectionner une image clinique";

  @override
  String get addBreak => "Ajouter la pause";

  @override
  String get editBreak => "Modifier la pause";

  @override
  String get selectTime => "Sélectionner l'heure";

  @override
  String get startDateMustBeBeforeEndDate => "La date de début doit être après la date de fin";

  @override
  String get endDateMustBeAfterStartDate => "La date de fin doit être après la date de début";

  @override
  String get breakTimeIsOutsideShiftTime => "Le temps de pause est en dehors du temps de quart";

  @override
  String get lblBreak => "Casser";

  @override
  String get clinicSessions => "Séances de clinique";

  @override
  String get noSessionsFound => "Aucune séance trouvée!";

  @override
  String get oppsNoSessionsFoundAtMomentTryAgainLater => "Opps!Aucune séance trouvée au moment réessayez plus tard.";

  @override
  String get unavailable => "Indisponible";

  @override
  String get sessions => "Séances";

  @override
  String get clinicSessionsInformation => "Informations sur les sessions de la clinique";

  @override
  String get services => "Prestations de service";

  @override
  String get serviceAvaliable => "Service disponible";

  @override
  String get doctorsAvaliable => "Médecins disponibles";

  @override
  String get photosAvaliable => "Photos available";

  @override
  String get clinicDetail => "Détail de la clinique";

  @override
  String get readMore => "En savoir plus";

  @override
  String get readLess => "Lire moins";

  @override
  String get clinicGalleryDeleteSuccessfully => "Galerie de la clinique Supprimer avec succès";

  @override
  String get noGalleryFoundAtAMoment => "Aucune galerie trouvée à un moment";

  @override
  String get looksLikeThereIsNoGalleryForThisClinicWellKee => "On dirait qu'il n'y a pas de galerie pour cette clinique, nous vous tiendrons au courant lorsqu'il y aura une mise à jour.";

  @override
  String get pleaseSelectImages => "Veuillez sélectionner les images !!";

  @override
  String get noClinicsFound => "Aucune clinique trouvée!";

  @override
  String get addNewClinic => "Ajouter une nouvelle clinique";

  @override
  String get areYouSureYouWantToDeleteThisClinic => "Êtes-vous sûr de vouloir supprimer cette clinique?";

  @override
  String get clinicDeleteSuccessfully => "Clinique Supprimer avec succès";

  @override
  String get totalAppointments => "Rendez-vous total";

  @override
  String get totalServices => "Services totaux";

  @override
  String get totalPatient => "Patient total";

  @override
  String get totalEarning => "Gain total";

  @override
  String get welcomeBack => "Content de te revoir";

  @override
  String get totalDoctors => "Total des médecins";

  @override
  String get doYouWantToPerformThisChange => "Voulez-vous effectuer ce changement?";

  @override
  String get statusUpdatedSuccessfully => "Statut mis à jour avec succès";

  @override
  String get chooseClinic => "Choisissez la clinique";

  @override
  String get pleaseChooseClinic => "Veuillez choisir la clinique !!";

  @override
  String get oppsNoClinicsFoundAtMomentTryAgainLater => "Opps!Aucune clinique trouvée au moment réessayez plus tard.";

  @override
  String get change => "Changement";

  @override
  String get analytics => "Analytique";

  @override
  String get youDontHaveAnyServicesnPleaseAddYourServices => "Vous n'avez aucun service.  N Veuillez ajouter vos services";

  @override
  String get addService => "Ajouter un service";

  @override
  String get recentAppointment => "Nomination récente";

  @override
  String get yourService => "Ton service";

  @override
  String get patients => "Les patients";

  @override
  String get noPatientsFound => "Aucun patient trouvé!";

  @override
  String get oppsNoPatientsFoundAtMomentTryAgainLater => "Oops!Aucun patient trouvé au moment, réessayez plus tard.";

  @override
  String get patientDetail => "Détails du patient";

  @override
  String get appointmentsTillNow => "rendez-vous jusqu'à présent";

  @override
  String get payoutHistory => "Historique de paiement";

  @override
  String get noPayout => "Pas de paiement !!";

  @override
  String get oppsLooksLikeThereIsNoPayoutsAvailable => "Oops!On dirait qu'il n'y a pas de paiement disponible.";

  @override
  String get addReceptionist => "Ajouter la réceptionniste";

  @override
  String get selectClinicCenters => "Sélectionnez les centres de clinique";

  @override
  String get noReceptionistsFound => "Aucune réceptionniste trouvée!";

  @override
  String get oppsNoReceptionistsFoundAtMomentTryAgainLater => "Oops!Aucune réceptionniste trouvée au moment réessayez plus tard.";

  @override
  String get addRequest => "Ajouter une demande";

  @override
  String get name => "Nom";

  @override
  String get selectType => "Sélectionner le genre";

  @override
  String get requestList => "Liste de demandes";

  @override
  String get noRequestsFound => "Aucune demande trouvée!";

  @override
  String get oppsNoRequestsFoundAtMomentTryAgainLater => "Opps!Aucune demande trouvée au moment réessayez plus tard.";

  @override
  String get changePrice => "Change le prix";

  @override
  String get assignDoctor => "Affecter le médecin";

  @override
  String get priceUpdatedSuccessfully => "Prix ​​mis à jour avec succès !!";

  @override
  String get charges => "Des charges";

  @override
  String get doctorsAssignSuccessfully => "Les médecins affectent avec succès !!";

  @override
  String get pleaseSelectClinic => "Veuillez sélectionner la clinique !!";

  @override
  String get searchForClinic => "Rechercher une clinique";

  @override
  String get noDoctorsFound => "Pas de médecins trouvés!";

  @override
  String get looksLikeThereAreNoDoctorsAvilableToAssign => "On dirait qu'il n'y a pas de médecins disponibles.";

  @override
  String get socialMedia => "Réseaux sociaux";

  @override
  String get revenue => "Revenu";

  @override
  String get yearly => "Annuel";

  @override
  String get service => "Service";

  @override
  String get searchClinicHere => "Clinique de recherche ici";

  @override
  String get home => "Maison";

  @override
  String get payouts => "Paiements";

  @override
  String get editDoctor => "Modifier le médecin";

  @override
  String get addDoctor => "Ajouter le médecin";

  @override
  String get aboutMyself => "À propos de moi";

  @override
  String get experienceSpecializationContactInfo => "Expérience, spécialisation, coordonnées";

  @override
  String get doctorSessionsInformation => "Informations sur les séances de médecin";

  @override
  String get noServicesTillNow => "Pas de services jusqu'à présent";

  @override
  String get oopsThisDoctorDoesntHaveAnyServicesYet => "Oops!Ce médecin n'a pas encore de services.";

  @override
  String get reviews => "Commentaires";

  @override
  String get noReviewsTillNow => "Aucune critique jusqu'à présent";

  @override
  String get oopsThisDoctorDoesntHaveAnyReviewsYet => "Oops!Ce médecin n'a pas encore de critiques.";

  @override
  String get qualification => "Qualification";

  @override
  String get qualificationDetailIsNotAvilable => "Les détails de qualification ne sont pas disponibles";

  @override
  String get qualificationInDetail => "Qualification en détail";

  @override
  String get year => "Année";

  @override
  String get degree => "Degré";

  @override
  String get university => "Université";

  @override
  String get by => "Par";

  @override
  String get breaks => "Pause";

  @override
  String get noWeekListFound => "Aucune liste de semaine trouvée!";

  @override
  String get oppsNoWeekListFoundAtMomentTryAgainLater => "Opps!Aucune liste de semaines trouvées au moment réessayez plus tard.";

  @override
  String get addDayOff => "Ajouter un jour de congé";

  @override
  String get assignClinics => "Affecter les cliniques";

  @override
  String get oppsNoDoctorFoundAtMomentTryAgainLater => "Opps!Aucun médecin trouvé au moment, réessayez plus tard.";

  @override
  String get sessionSavedSuccessfully => "Session enregistrée avec succès";

  @override
  String get doctorSession => "Séance de médecin";

  @override
  String get selectDoctor => "Sélectionner le médecin";

  @override
  String get pleaseSelectDoctor => "Veuillez sélectionner le médecin ... !!";

  @override
  String get allSession => "Toute session";

  @override
  String get addSession => "Ajouter la session";

  @override
  String get noDoctorSessionFound => "Aucune session de médecin trouvé!";

  @override
  String get thereAreCurrentlyNoDoctorSessionAvailable => "Il n'y a actuellement aucune session de médecin disponible.";

  @override
  String get oppsNoReviewFoundAtMomentTryAgainLater => "Opps!Aucune critique trouvée au moment réessayez plus tard.";

  @override
  String get noServicesFound => "Aucun service trouvé!";

  @override
  String get oppsNoServicesFoundAtMomentTryAgainLater => "Opps!Aucun service trouvé au moment, réessayez plus tard.";

  @override
  String get invoice => "Facture";

  @override
  String get encounter => "Rencontre";

  @override
  String get totalPayableAmountWithTax => "Montant total payable avec taxe";

  @override
  String get discountAmount => "Montant de réduction";

  @override
  String get servicePrice => "Prix ​​du service";

  @override
  String get contactInfo => "Informations de contact";

  @override
  String get experience => "Expérience";

  @override
  String get about => "À propos";

  @override
  String get myProfile => "Mon profil";

  @override
  String get doctorDetail => "Détail du docteur";

  @override
  String get areYouSureYouWantToDeleteThisDoctor => "Êtes-vous sûr de vouloir supprimer ce médecin?";

  @override
  String get doctorDeleteSuccessfully => "Docteur supprime avec succès";

  @override
  String get noQualificationsFound => "Aucune qualification trouvée!";

  @override
  String get looksLikeThereAreNoQualificationsAddedByThisD => "On dirait qu'il n'y a pas de qualifications ajoutées par ce médecin.";

  @override
  String get addEncounter => "Ajouter la rencontre";

  @override
  String get fillPatientEncounterDetails => "Remplissez les détails de la rencontre du patient";

  @override
  String get dateIsNotSelected => "La date n'est pas sélectionnée";

  @override
  String get date => "Date";

  @override
  String get chooseDoctor => "Choisissez Docteur";

  @override
  String get choosePatient => "Choisir le patient";

  @override
  String get searchForPatient => "Recherche de patient";

  @override
  String get bodyChart => "Graphique de carrosserie";

  @override
  String get imageDetails => "Détails de l'image";

  @override
  String get reset => "Réinitialiser";

  @override
  String get imageTitle => "Titre d'image";

  @override
  String get imageDescription => "description de l'image";

  @override
  String get pleaseUploadTheImage => "Veuillez télécharger l'image !!";

  @override
  String get patientName => "Nom du patient";

  @override
  String get lastUpdate => "Dernière mise à jour";

  @override
  String get noBodyChartsFound => "Aucun graphique corporel trouvé!";

  @override
  String get oppsNoBodyChartsFoundAtMomentTryAgainLater => "Opps!Aucun graphique corporel trouvé au moment, réessayez plus tard.";

  @override
  String get areYouSureYouWantToDeleteThisBodyChart => "Êtes-vous sûr de vouloir supprimer ce tableau corporel?";

  @override
  String get editPrescription => "Modifier la prescription";

  @override
  String get addPrescription => "Ajouter la prescription";

  @override
  String get frequency => "Fréquence";

  @override
  String get duration => "Durée";

  @override
  String get instruction => "Instruction";

  @override
  String get noNotesAdded => "Aucune note ajoutée";

  @override
  String get chooseOrAddNotes => "Choisissez ou ajoutez des notes";

  @override
  String get writeNotes => "Notes d'écriture";

  @override
  String get add => "Ajouter";

  @override
  String get notes => "Remarques";

  @override
  String get observations => "Observations";

  @override
  String get chooseOrAddObservation => "Choisissez ou ajoutez l'observation";

  @override
  String get writeObservation => "Écrire une observation";

  @override
  String get noObservationAdded => "Aucune observation ajoutée";

  @override
  String get otherInformation => "les autres informations";

  @override
  String get write => "Écrire...";

  @override
  String get prescription => "Ordonnance";

  @override
  String get noPrescriptionAdded => "Aucune prescription ajoutée";

  @override
  String get days => "Jours";

  @override
  String get problems => "Problèmes";

  @override
  String get chooseOrAddProblems => "Choisissez ou ajoutez des problèmes";

  @override
  String get writeProblem => "Écrire un problème";

  @override
  String get noProblemAdded => "Aucun problème ajouté";

  @override
  String get clinicalDetail => "Détail clinique";

  @override
  String get moreInformation => "Plus d'information";

  @override
  String get patientHealthInformation => "Informations sur la santé des patients";

  @override
  String get showBodyChartRelatedInformation => "Afficher les informations liées au tableau du corps";

  @override
  String get viewReport => "Voir le rapport";

  @override
  String get showReportRelatedInformation => "Afficher le rapport des informations connexes";

  @override
  String get billDetails => "Détails de la facture";

  @override
  String get showBillDetailsRelatedInformation => "Afficher les détails de la facture des informations connexes";

  @override
  String get clinic => "Clinique";

  @override
  String get encounterDate => "Date de rencontre";

  @override
  String get unpaid => "Non payé";

  @override
  String get totalPrice => "Prix ​​total";

  @override
  String get enterDiscount => "Entrer une remise";

  @override
  String get enterPayableAmount => "Entrez le montant payable";

  @override
  String get paymentStatus => "Statut de paiement";

  @override
  String get toCloseTheEncounterInvoicePaymentIsMandatory => "Pour fermer la rencontre, le paiement de la facture est obligatoire";

  @override
  String get noInvoiceDetailsFound => "Aucun détail de facture trouvé!";

  @override
  String get oppsNoInvoiceDetailsFoundAtMomentTryAgainLate => "Opps!Aucun détail de facture trouvé au moment réessayez plus tard.";

  @override
  String get invoiceDetail => "Détail de facture";

  @override
  String get noInvoiceFound => "Aucune facture trouvée!";

  @override
  String get oppsNoInvoiceFoundAtMomentTryAgainLater => "Oops!Aucune facture trouvée au moment réessayez plus tard.";

  @override
  String get generateInvoice => "Générez la facture !!";

  @override
  String get invoiceId => "ID de facture";

  @override
  String get patientDetails => "Détails du patient";

  @override
  String get editMedicalReport => "Modifier le rapport médical";

  @override
  String get addMedicalReport => "Ajouter un rapport médical";

  @override
  String get uploadMedicalReport => "Télécharger un rapport médical";

  @override
  String get pleaseUploadAMedicalReport => "Veuillez télécharger un rapport médical";

  @override
  String get medicalReports => "Rapports médicaux";

  @override
  String get thereIsNoMedicalReportsAvilableAtThisMoment => "Aucun rapport médical n'est disponible en ce moment.";

  @override
  String get noMedicalReportsFound => "Aucun rapport médical trouvé !!";

  @override
  String get areYouSureYouWantToDeleteThisMedicalReport => "Êtes-vous sûr de vouloir supprimer ce rapport médical?";

  @override
  String get medicalReportDeleteSuccessfully => "Rapport médical Supprimer avec succès";

  @override
  String get noEncountersFound => "Aucune rencontre trouvée!";

  @override
  String get areYouSureYouWantToDeleteThisEncounter => "Êtes-vous sûr de vouloir supprimer cette rencontre?";

  @override
  String get totalClinic => "Clinique totale";

  @override
  String get subjectiveObjectiveAssessmentAndPlan => "Subjectif, objectif, évaluation et plan.";

  @override
  String get noteTheAcronymSoapStandsForSubjectiveObjectiv =>
      "Remarque: Le savon acronyme signifie subjectif, objectif, évaluation et plan.Cette méthode standardisée de documentation des rencontres pour les patients permet aux fournisseurs d'enregistrer concise les informations avec les patients.";

  @override
  String get subjective => "Subjetivo";

  @override
  String get objective => "Objectif";

  @override
  String get assessment => "Évaluation";

  @override
  String get plan => "Plan";

  @override
  String get clearAllFilters => "Effacer tous les filtres";

  @override
  String get apply => "Appliquer";

  @override
  String get reportDetails => "Détails de rapport";

  @override
  String get yearIsRequired => "L'année est requise";

  @override
  String get enterAValidYearBetween1900And => "Entrez une année valide entre 1900 et";

  @override
  String get pleaseEnterYourDegree => "Veuillez saisir votre diplôme";

  @override
  String get pleaseEnterDegree => "Veuillez entrer un diplôme";

  @override
  String get pleaseEnterUniversity => "Veuillez entrer à l'université";

  @override
  String get selectYear => "Sélectionner l'année";

  @override
  String get somethingWentWrongPleaseTryAgainLater => "Quelque chose s'est mal passé.Veuillez réessayer plus tard.";

  @override
  String get advancePayableAmount => "Prévu à payer le montant";

  @override
  String get advancePaidAmount => "Montant rémunéré à l'avance";

  @override
  String get remainingPayableAmount => "Montant restant payable";

  @override
  String get addYourSignature => "Ajoutez votre signature";

  @override
  String get verifyWithEaseYourDigitalMark => "Vérifiez avec facilité: votre marque numérique";

  @override
  String get clear => "Clair";

  @override
  String get doctorImage => "Image du médecin";

  @override
  String get serviceTotal => "Total du service";

  @override
  String get expert => "Expert";

  @override
  String get percent => "Pour cent";

  @override
  String get fixed => "Fixé";

  @override
  String get discoutValue => "Valeur de réduction";

  @override
  String get editDiscount => "Modifier la remise";

  @override
  String get addDiscount => "Ajouter une remise";

  @override
  String get totalAmount => "Montant total";

  @override
  String get addBillingItem => "Ajouter un article de facturation";

  @override
  String get serviceImage => "Image de service";

  @override
  String get editService => "Modifier le service";

  @override
  String get great => "Super!";

  @override
  String get bookingSuccessful => "Réserver réussi";

  @override
  String get yourAppointmentHasBeenBookedSuccessfully => "Votre rendez-vous a été réservé avec succès";

  @override
  String get totalPayment => "Paiement total";

  @override
  String get goToAppointments => "Aller aux rendez-vous";

  @override
  String get addAppointment => 'Ajouter un rendez-vous';

  @override
  String get selectService => 'Sélectionnez un service';

  @override
  String get chooseDate => 'Choisir une date';

  @override
  String get noTimeSlotsAvailable => 'Aucun créneau horaire disponible';

  @override
  String get chooseTime => "Choisissez l'heure";

  @override
  String get asPerDoctorCharges => '*selon les tarifs du médecin';

  @override
  String get remainingAmount => 'Montant restant';

  @override
  String get refundableAmount => 'Montant remboursable';

  @override
  String get version => 'Version';

  @override
  String get passwordLengthShouldBe8To14Characters => 'La longueur du mot de passe doit être comprise entre 8 et 14 caractères';

  @override
  String get theConfirmPasswordAndPasswordMustMatch => 'Le mot de passe de confirmation et le mot de passe doivent correspondre.';

  @override
  String get chooseCommission => 'Choisissez les commissions';

  @override
  String get searchForCommission => 'Rechercher des commissions';

  @override
  String get noCommissionFound => 'Aucune commission trouvée';

  @override
  String get commission => 'Commission';

  @override
  String get selectServices => 'Sélectionnez les services';

  @override
  String get facebookLink => 'Lien Facebook';

  @override
  String get instagramLink => 'Lien Instagram';

  @override
  String get twitterLink => 'Lien Twitter';

  @override
  String get dribbleLink => 'Lien de dribble';

  @override
  String get signature => 'Signature';

  @override
  String get addNew => 'Ajouter un nouveau';

  @override
  String get pleaseSelectADoctorImage => 'Veuillez sélectionner une image de médecin';

  @override
  String get remove => 'Retirer';

  @override
  String get degreecertification => 'Diplôme/Certification';

  @override
  String get noReviewsFoundAtAMoment => 'Aucun avis trouvé pour le moment';

  @override
  String get looksLikeThereIsNoReviewsWellKeepYouPostedWhe => "Il semble qu'il n'y ait pas d'avis, nous vous tiendrons au courant lorsqu'il y aura une mise à jour.";

  @override
  String get addNewDoctor => 'Ajouter un nouveau médecin';

  @override
  String get bodyChartDeleteSuccessfully => 'Le diagramme corporel a été supprimé avec succès';

  @override
  String get editBillingItem => "Modifier l'élément de facturation";

  @override
  String get quantity => 'Quantité';

  @override
  String get areYouSureYouWantToDeleteThisBillingItem => 'Etes-vous sûr de vouloir supprimer ce poste de facturation?';

  @override
  String get pleaseWaitWhileItsLoading => 'Veuillez patienter pendant son chargement...';

  @override
  String get billingItemRemovedSuccessfully => 'Élément de facturation supprimé avec succès';

  @override
  String get closeCheckoutEncounter => 'Rencontre de clôture et de paiement';

  @override
  String get file => 'Déposer';

  @override
  String get serviceName => 'Nom du service';

  @override
  String get serviceDurationMin => 'Durée du service (min)';

  @override
  String get defaultPrice => 'Prix par défaut';

  @override
  String get chooseCategory => 'Choisir une catégorie';

  @override
  String get searchForCategory => 'Rechercher une catégorie';

  @override
  String get category => 'Catégorie';

  @override
  String get enterDescription => 'Entrez la description';

  @override
  String get pleaseSelectAServiceImage => 'Veuillez sélectionner une image de service';

  @override
  String get sServices => 'Services';
}
