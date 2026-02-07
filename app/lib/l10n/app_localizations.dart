import 'package:flutter/material.dart';

/// Traductions FR / EN / AR / IT / DE pour l'app
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('fr'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  String get _localeKey => _localizedValues.containsKey(locale.languageCode) ? locale.languageCode : 'fr';

  String get appName => _localizedValues[_localeKey]!['appName']!;
  String get login => _localizedValues[_localeKey]!['login']!;
  String get loginSubtitle => _localizedValues[_localeKey]!['loginSubtitle']!;
  String get name => _localizedValues[_localeKey]!['name']!;
  String get password => _localizedValues[_localeKey]!['password']!;
  String get connect => _localizedValues[_localeKey]!['connect']!;
  String get continueVisitor => _localizedValues[_localeKey]!['continueVisitor']!;
  String get news => _localizedValues[_localeKey]!['news']!;
  String get history => _localizedValues[_localeKey]!['history']!;
  String get presentation => _localizedValues[_localeKey]!['presentation']!;
  String get home => _localizedValues[_localeKey]!['home']!;
  String get events => _localizedValues[_localeKey]!['events']!;
  String get error => _localizedValues[_localeKey]!['error']!;
  String get refresh => _localizedValues[_localeKey]!['refresh']!;
  String get close => _localizedValues[_localeKey]!['close']!;
  String get language => _localizedValues[_localeKey]!['language']!;
  String get nameRequired => _localizedValues[_localeKey]!['nameRequired']!;
  String get passwordRequired => _localizedValues[_localeKey]!['passwordRequired']!;
  String get groups => _localizedValues[_localeKey]!['groups']!;
  String get administration => _localizedValues[_localeKey]!['administration']!;
  String get programmes => _localizedValues[_localeKey]!['programmes']!;
  String get connectTooltip => _localizedValues[_localeKey]!['connectTooltip']!;
  String get logoutTooltip => _localizedValues[_localeKey]!['logoutTooltip']!;
  String get welcomeLabel => _localizedValues[_localeKey]!['welcomeLabel']!;
  String get loginScreenLabel => _localizedValues[_localeKey]!['loginScreenLabel']!;
  String get mainScreenLabel => _localizedValues[_localeKey]!['mainScreenLabel']!;
  String get retry => _localizedValues[_localeKey]!['retry']!;
  String get noEventInHistory => _localizedValues[_localeKey]!['noEventInHistory']!;
  String get noNews => _localizedValues[_localeKey]!['noNews']!;
  String get historyTitle => _localizedValues[_localeKey]!['historyTitle']!;
  String get presentationTitle => _localizedValues[_localeKey]!['presentationTitle']!;
  String get required => _localizedValues[_localeKey]!['required']!;
  String get cancel => _localizedValues[_localeKey]!['cancel']!;
  String get save => _localizedValues[_localeKey]!['save']!;
  String get create => _localizedValues[_localeKey]!['create']!;
  String get delete => _localizedValues[_localeKey]!['delete']!;
  String get edit => _localizedValues[_localeKey]!['edit']!;
  String get users => _localizedValues[_localeKey]!['users']!;
  String get createUser => _localizedValues[_localeKey]!['createUser']!;
  String get noUser => _localizedValues[_localeKey]!['noUser']!;
  String get editUser => _localizedValues[_localeKey]!['editUser']!;
  String get newUser => _localizedValues[_localeKey]!['newUser']!;
  String get deleteUser => _localizedValues[_localeKey]!['deleteUser']!;
  String deleteUserConfirm(String name) => _localizedValues[_localeKey]!['deleteUserConfirm']!.replaceAll('{name}', name);
  String get userDeleted => _localizedValues[_localeKey]!['userDeleted']!;
  String get userModified => _localizedValues[_localeKey]!['userModified']!;
  String get userCreated => _localizedValues[_localeKey]!['userCreated']!;
  String get phone => _localizedValues[_localeKey]!['phone']!;
  String get description => _localizedValues[_localeKey]!['description']!;
  String get trainingProgrammes => _localizedValues[_localeKey]!['trainingProgrammes']!;
  String get createProgramme => _localizedValues[_localeKey]!['createProgramme']!;
  String get noProgramme => _localizedValues[_localeKey]!['noProgramme']!;
  String get deleteProgramme => _localizedValues[_localeKey]!['deleteProgramme']!;
  String get programmeDeleted => _localizedValues[_localeKey]!['programmeDeleted']!;
  String get programmeModified => _localizedValues[_localeKey]!['programmeModified']!;
  String get programmeCreated => _localizedValues[_localeKey]!['programmeCreated']!;
  String get editProgramme => _localizedValues[_localeKey]!['editProgramme']!;
  String get newProgramme => _localizedValues[_localeKey]!['newProgramme']!;
  String get selectGroup => _localizedValues[_localeKey]!['selectGroup']!;
  String get selectGroupSnackbar => _localizedValues[_localeKey]!['selectGroupSnackbar']!;
  String get startDate => _localizedValues[_localeKey]!['startDate']!;
  String get endDate => _localizedValues[_localeKey]!['endDate']!;
  String get shareToAdherents => _localizedValues[_localeKey]!['shareToAdherents']!;
  String get permissions => _localizedValues[_localeKey]!['permissions']!;
  String get createPermission => _localizedValues[_localeKey]!['createPermission']!;
  String get noPermission => _localizedValues[_localeKey]!['noPermission']!;
  String get notDefined => _localizedValues[_localeKey]!['notDefined']!;
  String get adminPrincipal => _localizedValues[_localeKey]!['adminPrincipal']!;
  String get adminCoach => _localizedValues[_localeKey]!['adminCoach']!;
  String get adminGroup => _localizedValues[_localeKey]!['adminGroup']!;
  String get adherent => _localizedValues[_localeKey]!['adherent']!;
  String get hello => _localizedValues[_localeKey]!['hello']!;
  String get createEvent => _localizedValues[_localeKey]!['createEvent']!;
  String get firstName => _localizedValues[_localeKey]!['firstName']!;
  String get email => _localizedValues[_localeKey]!['email']!;
  String get role => _localizedValues[_localeKey]!['role']!;
  String get cin => _localizedValues[_localeKey]!['cin']!;
  String get title => _localizedValues[_localeKey]!['title']!;
  String get group => _localizedValues[_localeKey]!['group']!;
  String get presentationHistorySection => _localizedValues[_localeKey]!['presentationHistorySection']!;
  String get presentationHistoryContent => _localizedValues[_localeKey]!['presentationHistoryContent']!;
  String get presentationValuesSection => _localizedValues[_localeKey]!['presentationValuesSection']!;
  String get presentationValuesContent => _localizedValues[_localeKey]!['presentationValuesContent']!;
  String get presentationObjectivesSection => _localizedValues[_localeKey]!['presentationObjectivesSection']!;
  String get presentationObjectivesContent => _localizedValues[_localeKey]!['presentationObjectivesContent']!;
  String get presentationCharterSection => _localizedValues[_localeKey]!['presentationCharterSection']!;
  String get presentationCharterContent => _localizedValues[_localeKey]!['presentationCharterContent']!;
  String get presentationGroupsSection => _localizedValues[_localeKey]!['presentationGroupsSection']!;
  String get presentationGroupsContent => _localizedValues[_localeKey]!['presentationGroupsContent']!;
  String get createSeries => _localizedValues[_localeKey]!['createSeries']!;
  String get themeTooltip => _localizedValues[_localeKey]!['themeTooltip']!;
  String get themeLight => _localizedValues[_localeKey]!['themeLight']!;
  String get themeDark => _localizedValues[_localeKey]!['themeDark']!;
  String get themeHighContrast => _localizedValues[_localeKey]!['themeHighContrast']!;
  String get userManagement => _localizedValues[_localeKey]!['userManagement']!;
  String get userManagementSubtitle => _localizedValues[_localeKey]!['userManagementSubtitle']!;
  String get permissionsManagement => _localizedValues[_localeKey]!['permissionsManagement']!;
  String get permissionsManagementSubtitle => _localizedValues[_localeKey]!['permissionsManagementSubtitle']!;
  String get daily => _localizedValues[_localeKey]!['daily']!;
  String get weekly => _localizedValues[_localeKey]!['weekly']!;
  String get time => _localizedValues[_localeKey]!['time']!;
  String get from => _localizedValues[_localeKey]!['from']!;
  String get to => _localizedValues[_localeKey]!['to']!;
  String get choose => _localizedValues[_localeKey]!['choose']!;
  String get dayOfWeek => _localizedValues[_localeKey]!['dayOfWeek']!;
  String eventsWillBeCreated(int n) => _localizedValues[_localeKey]!['eventsWillBeCreated']!.replaceAll('{n}', '$n');
  String get chooseDates => _localizedValues[_localeKey]!['chooseDates']!;
  String createEvents(int n) => _localizedValues[_localeKey]!['createEvents']!.replaceAll('{n}', '$n');
  String eventsCreated(int n) => _localizedValues[_localeKey]!['eventsCreated']!.replaceAll('{n}', '$n');
  String get noDateInRange => _localizedValues[_localeKey]!['noDateInRange']!;
  String errorAfterCreate(int n) => _localizedValues[_localeKey]!['errorAfterCreate']!.replaceAll('{n}', '$n');
  String get dayMonday => _localizedValues[_localeKey]!['dayMonday']!;
  String get dayTuesday => _localizedValues[_localeKey]!['dayTuesday']!;
  String get dayWednesday => _localizedValues[_localeKey]!['dayWednesday']!;
  String get dayThursday => _localizedValues[_localeKey]!['dayThursday']!;
  String get dayFriday => _localizedValues[_localeKey]!['dayFriday']!;
  String get daySaturday => _localizedValues[_localeKey]!['daySaturday']!;
  String get daySunday => _localizedValues[_localeKey]!['daySunday']!;
  String get hintDailyEvent => _localizedValues[_localeKey]!['hintDailyEvent']!;
  String get hintWeeklyEvent => _localizedValues[_localeKey]!['hintWeeklyEvent']!;
  String get newEvent => _localizedValues[_localeKey]!['newEvent']!;
  String get editEvent => _localizedValues[_localeKey]!['editEvent']!;
  String get eventModified => _localizedValues[_localeKey]!['eventModified']!;
  String get eventCreated => _localizedValues[_localeKey]!['eventCreated']!;
  String get cannotLoadGroups => _localizedValues[_localeKey]!['cannotLoadGroups']!;
  String get hintTitleEvent => _localizedValues[_localeKey]!['hintTitleEvent']!;
  String get titleRequired => _localizedValues[_localeKey]!['titleRequired']!;
  String get hintEventDetails => _localizedValues[_localeKey]!['hintEventDetails']!;
  String get type => _localizedValues[_localeKey]!['type']!;
  String get typeDaily => _localizedValues[_localeKey]!['typeDaily']!;
  String get typeLongRun => _localizedValues[_localeKey]!['typeLongRun']!;
  String get typeNationalRace => _localizedValues[_localeKey]!['typeNationalRace']!;
  String get typeOther => _localizedValues[_localeKey]!['typeOther']!;
  String get groupRequired => _localizedValues[_localeKey]!['groupRequired']!;
  String get noGroupAvailable => _localizedValues[_localeKey]!['noGroupAvailable']!;
  String get date => _localizedValues[_localeKey]!['date']!;

  static final Map<String, Map<String, String>> _localizedValues = {
    'fr': {
      'appName': 'Running Club Tunis',
      'login': 'Connexion',
      'loginSubtitle': 'Nom + mot de passe (3 derniers chiffres CIN)',
      'name': 'Nom',
      'password': 'Mot de passe (3 derniers chiffres CIN)',
      'connect': 'Se connecter',
      'continueVisitor': 'Continuer en visiteur',
      'news': 'Actualités',
      'history': 'Historique',
      'presentation': 'Présentation',
      'home': 'Accueil',
      'events': 'Événements',
      'error': 'Erreur',
      'refresh': 'Actualiser',
      'close': 'Fermer',
      'language': 'Langue',
      'nameRequired': 'Le nom est requis',
      'passwordRequired': 'Le mot de passe est requis',
      'groups': 'Groupes',
      'administration': 'Administration',
      'programmes': 'Programmes',
      'connectTooltip': 'Se connecter',
      'logoutTooltip': 'Déconnexion',
      'welcomeLabel': 'Accueil Running Club Tunis',
      'loginScreenLabel': 'Écran de connexion',
      'mainScreenLabel': 'Écran principal Running Club Tunis',
      'retry': 'Réessayer',
      'noEventInHistory': 'Aucun événement dans l\'historique',
      'noNews': 'Aucune actualité pour le moment',
      'historyTitle': 'Historique du club',
      'presentationTitle': 'Présentation du club',
      'required': 'Requis',
      'cancel': 'Annuler',
      'save': 'Enregistrer',
      'create': 'Créer',
      'delete': 'Supprimer',
      'edit': 'Modifier',
      'users': 'Utilisateurs',
      'createUser': 'Créer un utilisateur',
      'noUser': 'Aucun utilisateur',
      'editUser': 'Modifier l\'utilisateur',
      'newUser': 'Nouvel utilisateur',
      'deleteUser': 'Supprimer l\'utilisateur',
      'deleteUserConfirm': 'Supprimer {name} ? Cette action est irréversible.',
      'userDeleted': 'Utilisateur supprimé',
      'userModified': 'Utilisateur modifié',
      'userCreated': 'Utilisateur créé',
      'phone': 'Téléphone',
      'description': 'Description',
      'trainingProgrammes': 'Programmes d\'entraînement',
      'createProgramme': 'Créer un programme',
      'noProgramme': 'Aucun programme',
      'deleteProgramme': 'Supprimer le programme',
      'programmeDeleted': 'Programme supprimé',
      'programmeModified': 'Programme modifié',
      'programmeCreated': 'Programme créé',
      'editProgramme': 'Modifier le programme',
      'newProgramme': 'Nouveau programme',
      'selectGroup': 'Sélectionnez un groupe',
      'selectGroupSnackbar': 'Veuillez sélectionner un groupe',
      'startDate': 'Date de début',
      'endDate': 'Date de fin',
      'shareToAdherents': 'Partager aux adhérents',
      'permissions': 'Permissions',
      'createPermission': 'Créer une permission',
      'noPermission': 'Aucune permission',
      'notDefined': 'Non défini',
      'adminPrincipal': 'Admin principal',
      'adminCoach': 'Admin coach',
      'adminGroup': 'Admin groupe',
      'adherent': 'Adhérent',
      'hello': 'Bonjour !',
      'createEvent': 'Créer un événement',
      'firstName': 'Prénom',
      'email': 'Email',
      'role': 'Rôle',
      'cin': 'CIN',
      'title': 'Titre',
      'group': 'Groupe',
      'presentationHistorySection': 'Historique',
      'presentationHistoryContent': 'Le Running Club Tunis est un club de course à pied fondé à Tunis. '
          'Depuis sa création, le club rassemble des passionnés de running '
          'pour partager des moments de sport, de dépassement et de convivialité.',
      'presentationValuesSection': 'Nos valeurs',
      'presentationValuesContent': '• Passion : L\'amour du running nous rassemble\n'
          '• Solidarité : Chacun avance à son rythme, ensemble\n'
          '• Respect : De soi, des autres et de l\'environnement\n'
          '• Dépassement : Se fixer des objectifs et les atteindre',
      'presentationObjectivesSection': 'Objectifs',
      'presentationObjectivesContent': '• Promouvoir la pratique de la course à pied à Tunis\n'
          '• Organiser des sorties régulières et des événements\n'
          '• Créer une communauté de coureurs bienveillante\n'
          '• Représenter le club lors de courses nationales',
      'presentationCharterSection': 'Charte',
      'presentationCharterContent': 'En rejoignant le Running Club Tunis, chaque membre s\'engage à :\n'
          '• Respecter les horaires et lieux de rendez-vous\n'
          '• Être ponctuel et prévenir en cas d\'absence\n'
          '• Adopter un comportement bienveillant envers tous\n'
          '• Participer activement à la vie du club',
      'presentationGroupsSection': 'Organisation des groupes',
      'presentationGroupsContent': 'Le club est organisé en plusieurs groupes selon les niveaux et objectifs :\n'
          '• Débutants : Découverte du running\n'
          '• Intermédiaires : Progression et régularité\n'
          '• Confirmés : Performances et compétitions\n'
          'Chaque groupe dispose d\'un responsable et d\'un programme adapté.',
      'createSeries': 'Création en série',
      'themeTooltip': 'Changer le thème (Clair / Sombre / Contraste élevé)',
      'themeLight': 'Clair',
      'themeDark': 'Sombre',
      'themeHighContrast': 'Contraste élevé (daltonien)',
      'userManagement': 'Gestion des utilisateurs',
      'userManagementSubtitle': 'Créer, modifier, supprimer les comptes et attribuer les rôles',
      'permissionsManagement': 'Gestion des permissions',
      'permissionsManagementSubtitle': 'Créer, modifier, supprimer les permissions',
      'daily': 'Quotidien',
      'weekly': 'Hebdomadaire',
      'time': 'Heure',
      'from': 'Du',
      'to': 'Au',
      'choose': 'Choisir',
      'dayOfWeek': 'Jour de la semaine',
      'eventsWillBeCreated': '{n} événement(s) seront créés',
      'chooseDates': 'Choisir les dates',
      'createEvents': 'Créer {n} événement(s)',
      'eventsCreated': '{n} événement(s) créé(s)',
      'noDateInRange': 'Aucune date dans la plage (vérifiez les dates ou le jour pour hebdo)',
      'errorAfterCreate': 'Erreur après {n} création(s): ',
      'dayMonday': 'Lundi',
      'dayTuesday': 'Mardi',
      'dayWednesday': 'Mercredi',
      'dayThursday': 'Jeudi',
      'dayFriday': 'Vendredi',
      'daySaturday': 'Samedi',
      'daySunday': 'Dimanche',
      'hintDailyEvent': 'Ex: Footing matinal',
      'hintWeeklyEvent': 'Ex: Sortie longue',
      'newEvent': 'Nouvel événement',
      'editEvent': 'Modifier l\'événement',
      'eventModified': 'Événement modifié.',
      'eventCreated': 'Événement créé.',
      'cannotLoadGroups': 'Impossible de charger les groupes. Vérifiez le backend.',
      'hintTitleEvent': 'Ex: Entraînement matinal',
      'titleRequired': 'Le titre est requis',
      'hintEventDetails': 'Détails de l\'événement...',
      'type': 'Type',
      'typeDaily': 'Entraînement quotidien',
      'typeLongRun': 'Sortie longue (hebdo)',
      'typeNationalRace': 'Course nationale',
      'typeOther': 'Autre',
      'groupRequired': 'Le groupe est requis',
      'noGroupAvailable': 'Aucun groupe disponible. Créez d\'abord un groupe.',
      'date': 'Date',
    },
    'en': {
      'appName': 'Running Club Tunis',
      'login': 'Login',
      'loginSubtitle': 'Name + password (last 3 digits of ID)',
      'name': 'Name',
      'password': 'Password (last 3 digits of ID)',
      'connect': 'Sign in',
      'continueVisitor': 'Continue as visitor',
      'news': 'News',
      'history': 'History',
      'presentation': 'Presentation',
      'home': 'Home',
      'events': 'Events',
      'error': 'Error',
      'refresh': 'Refresh',
      'close': 'Close',
      'language': 'Language',
      'nameRequired': 'Name is required',
      'passwordRequired': 'Password is required',
      'groups': 'Groups',
      'administration': 'Administration',
      'programmes': 'Programmes',
      'connectTooltip': 'Sign in',
      'logoutTooltip': 'Logout',
      'welcomeLabel': 'Running Club Tunis Home',
      'loginScreenLabel': 'Login screen',
      'mainScreenLabel': 'Running Club Tunis main screen',
      'retry': 'Retry',
      'noEventInHistory': 'No events in history',
      'noNews': 'No news at the moment',
      'historyTitle': 'Club history',
      'presentationTitle': 'Club presentation',
      'required': 'Required',
      'cancel': 'Cancel',
      'save': 'Save',
      'create': 'Create',
      'delete': 'Delete',
      'edit': 'Edit',
      'users': 'Users',
      'createUser': 'Create user',
      'noUser': 'No user',
      'editUser': 'Edit user',
      'newUser': 'New user',
      'deleteUser': 'Delete user',
      'deleteUserConfirm': 'Delete {name}? This action cannot be undone.',
      'userDeleted': 'User deleted',
      'userModified': 'User modified',
      'userCreated': 'User created',
      'phone': 'Phone',
      'description': 'Description',
      'trainingProgrammes': 'Training programmes',
      'createProgramme': 'Create programme',
      'noProgramme': 'No programme',
      'deleteProgramme': 'Delete programme',
      'programmeDeleted': 'Programme deleted',
      'programmeModified': 'Programme modified',
      'programmeCreated': 'Programme created',
      'editProgramme': 'Edit programme',
      'newProgramme': 'New programme',
      'selectGroup': 'Select a group',
      'selectGroupSnackbar': 'Please select a group',
      'startDate': 'Start date',
      'endDate': 'End date',
      'shareToAdherents': 'Share to members',
      'permissions': 'Permissions',
      'createPermission': 'Create permission',
      'noPermission': 'No permission',
      'notDefined': 'Not defined',
      'adminPrincipal': 'Principal admin',
      'adminCoach': 'Coach admin',
      'adminGroup': 'Group admin',
      'adherent': 'Member',
      'hello': 'Hello!',
      'createEvent': 'Create event',
      'firstName': 'First name',
      'email': 'Email',
      'role': 'Role',
      'cin': 'ID number',
      'title': 'Title',
      'group': 'Group',
      'presentationHistorySection': 'History',
      'presentationHistoryContent': 'Running Club Tunis is a running club founded in Tunis. '
          'Since its creation, the club brings together running enthusiasts '
          'to share moments of sport, achievement and conviviality.',
      'presentationValuesSection': 'Our values',
      'presentationValuesContent': '• Passion: Love of running brings us together\n'
          '• Solidarity: Everyone progresses at their own pace, together\n'
          '• Respect: For oneself, others and the environment\n'
          '• Achievement: Setting goals and reaching them',
      'presentationObjectivesSection': 'Objectives',
      'presentationObjectivesContent': '• Promote running practice in Tunis\n'
          '• Organize regular outings and events\n'
          '• Create a welcoming community of runners\n'
          '• Represent the club at national races',
      'presentationCharterSection': 'Charter',
      'presentationCharterContent': 'By joining Running Club Tunis, each member commits to:\n'
          '• Respecting meeting times and places\n'
          '• Being on time and notifying in case of absence\n'
          '• Adopting a welcoming attitude towards everyone\n'
          '• Actively participating in club life',
      'presentationGroupsSection': 'Group organization',
      'presentationGroupsContent': 'The club is organized into several groups according to levels and objectives:\n'
          '• Beginners: Discovering running\n'
          '• Intermediate: Progress and regularity\n'
          '• Advanced: Performance and competitions\n'
          'Each group has a leader and an adapted programme.',
      'createSeries': 'Series creation',
      'themeTooltip': 'Change theme (Light / Dark / High contrast)',
      'themeLight': 'Light',
      'themeDark': 'Dark',
      'themeHighContrast': 'High contrast (colorblind)',
      'userManagement': 'User management',
      'userManagementSubtitle': 'Create, edit, delete accounts and assign roles',
      'permissionsManagement': 'Permissions management',
      'permissionsManagementSubtitle': 'Create, edit, delete permissions',
      'daily': 'Daily',
      'weekly': 'Weekly',
      'time': 'Time',
      'from': 'From',
      'to': 'To',
      'choose': 'Choose',
      'dayOfWeek': 'Day of the week',
      'eventsWillBeCreated': '{n} event(s) will be created',
      'chooseDates': 'Choose dates',
      'createEvents': 'Create {n} event(s)',
      'eventsCreated': '{n} event(s) created',
      'noDateInRange': 'No date in range (check dates or day for weekly)',
      'errorAfterCreate': 'Error after {n} creation(s): ',
      'dayMonday': 'Monday',
      'dayTuesday': 'Tuesday',
      'dayWednesday': 'Wednesday',
      'dayThursday': 'Thursday',
      'dayFriday': 'Friday',
      'daySaturday': 'Saturday',
      'daySunday': 'Sunday',
      'hintDailyEvent': 'Ex: Morning run',
      'hintWeeklyEvent': 'Ex: Long run',
      'newEvent': 'New event',
      'editEvent': 'Edit event',
      'eventModified': 'Event modified.',
      'eventCreated': 'Event created.',
      'cannotLoadGroups': 'Unable to load groups. Please check the backend.',
      'hintTitleEvent': 'Ex: Morning training',
      'titleRequired': 'Title is required',
      'hintEventDetails': 'Event details...',
      'type': 'Type',
      'typeDaily': 'Daily training',
      'typeLongRun': 'Long run (weekly)',
      'typeNationalRace': 'National race',
      'typeOther': 'Other',
      'groupRequired': 'Group is required',
      'noGroupAvailable': 'No group available. Create a group first.',
      'date': 'Date',
    },
    'ar': {
      'appName': 'نادي الجري تونس',
      'login': 'تسجيل الدخول',
      'loginSubtitle': 'الاسم + كلمة المرور (آخر 3 أرقام البطاقة)',
      'name': 'الاسم',
      'password': 'كلمة المرور (آخر 3 أرقام البطاقة)',
      'connect': 'دخول',
      'continueVisitor': 'متابعة كزائر',
      'news': 'الأخبار',
      'history': 'التاريخ',
      'presentation': 'العرض',
      'home': 'الرئيسية',
      'events': 'الفعاليات',
      'error': 'خطأ',
      'refresh': 'تحديث',
      'close': 'إغلاق',
      'language': 'اللغة',
      'nameRequired': 'الاسم مطلوب',
      'passwordRequired': 'كلمة المرور مطلوبة',
      'groups': 'المجموعات',
      'administration': 'الإدارة',
      'programmes': 'البرامج',
      'connectTooltip': 'دخول',
      'logoutTooltip': 'تسجيل الخروج',
      'welcomeLabel': 'نادي الجري تونس الرئيسية',
      'loginScreenLabel': 'شاشة الدخول',
      'mainScreenLabel': 'الشاشة الرئيسية',
      'retry': 'إعادة المحاولة',
      'noEventInHistory': 'لا أحداث في السجل',
      'noNews': 'لا أخبار حالياً',
      'historyTitle': 'تاريخ النادي',
      'presentationTitle': 'عرض النادي',
      'required': 'مطلوب',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'create': 'إنشاء',
      'delete': 'حذف',
      'edit': 'تعديل',
      'users': 'المستخدمون',
      'createUser': 'إنشاء مستخدم',
      'noUser': 'لا مستخدم',
      'editUser': 'تعديل المستخدم',
      'newUser': 'مستخدم جديد',
      'deleteUser': 'حذف المستخدم',
      'deleteUserConfirm': 'حذف {name}؟ لا يمكن التراجع عن هذا الإجراء.',
      'userDeleted': 'تم حذف المستخدم',
      'userModified': 'تم تعديل المستخدم',
      'userCreated': 'تم إنشاء المستخدم',
      'phone': 'الهاتف',
      'description': 'الوصف',
      'trainingProgrammes': 'برامج التدريب',
      'createProgramme': 'إنشاء برنامج',
      'noProgramme': 'لا برنامج',
      'deleteProgramme': 'حذف البرنامج',
      'programmeDeleted': 'تم حذف البرنامج',
      'programmeModified': 'تم تعديل البرنامج',
      'programmeCreated': 'تم إنشاء البرنامج',
      'editProgramme': 'تعديل البرنامج',
      'newProgramme': 'برنامج جديد',
      'selectGroup': 'اختر مجموعة',
      'selectGroupSnackbar': 'الرجاء اختيار مجموعة',
      'startDate': 'تاريخ البداية',
      'endDate': 'تاريخ النهاية',
      'shareToAdherents': 'مشاركة مع الأعضاء',
      'permissions': 'الصلاحيات',
      'createPermission': 'إنشاء صلاحية',
      'noPermission': 'لا صلاحيات',
      'notDefined': 'غير محدد',
      'adminPrincipal': 'مدير رئيسي',
      'adminCoach': 'مدرب',
      'adminGroup': 'مدير مجموعة',
      'adherent': 'عضو',
      'hello': 'مرحباً!',
      'createEvent': 'إنشاء حدث',
      'firstName': 'الاسم الأول',
      'email': 'البريد',
      'role': 'الدور',
      'cin': 'رقم البطاقة',
      'title': 'العنوان',
      'group': 'المجموعة',
      'presentationHistorySection': 'التاريخ',
      'presentationHistoryContent': 'نادي الجري تونس نادي للجري تأسس في تونس. '
          'منذ تأسيسه، يجمع النادي عشاق الجري '
          'لتبادل لحظات الرياضة والإنجاز والود.',
      'presentationValuesSection': 'قيمنا',
      'presentationValuesContent': '• الشغف: حب الجري يجمعنا\n'
          '• التضامن: الجميع يتقدم بوتيرته، معاً\n'
          '• الاحترام: للنفس والآخرين والبيئة\n'
          '• التجاوز: تحديد الأهداف وتحقيقها',
      'presentationObjectivesSection': 'الأهداف',
      'presentationObjectivesContent': '• تشجيع ممارسة الجري في تونس\n'
          '• تنظيم خرجات ومناسبات منتظمة\n'
          '• إنشاء مجتمع مرحب بالعدائين\n'
          '• تمثيل النادي في السباقات الوطنية',
      'presentationCharterSection': 'الميثاق',
      'presentationCharterContent': 'بالانضمام إلى نادي الجري تونس، يلتزم كل عضو بـ:\n'
          '• احترام أوقات وأماكن اللقاءات\n'
          '• الالتزام بالمواعيد والتنبيه في حالة الغياب\n'
          '• اعتماد سلوك مرحب تجاه الجميع\n'
          '• المشاركة الفاعلة في حياة النادي',
      'presentationGroupsSection': 'تنظيم المجموعات',
      'presentationGroupsContent': 'النادي منظم في عدة مجموعات حسب المستويات والأهداف:\n'
          '• المبتدئون: اكتشاف الجري\n'
          '• المتوسطون: التقدم والانتظام\n'
          '• المتقدمون: الأداء والمنافسات\n'
          'كل مجموعة لها مسؤول وبرنامج ملائم.',
      'createSeries': 'إنشاء متسلسل',
      'themeTooltip': 'تغيير السمة (فاتح / داكن / تباين عالٍ)',
      'themeLight': 'فاتح',
      'themeDark': 'داكن',
      'themeHighContrast': 'تباين عالٍ (للمصابين بعمى الألوان)',
      'userManagement': 'إدارة المستخدمين',
      'userManagementSubtitle': 'إنشاء وتعديل وحذف الحسابات وتعيين الأدوار',
      'permissionsManagement': 'إدارة الصلاحيات',
      'permissionsManagementSubtitle': 'إنشاء وتعديل وحذف الصلاحيات',
      'daily': 'يومي',
      'weekly': 'أسبوعي',
      'time': 'الوقت',
      'from': 'من',
      'to': 'إلى',
      'choose': 'اختر',
      'dayOfWeek': 'يوم الأسبوع',
      'eventsWillBeCreated': 'سيتم إنشاء {n} حدث',
      'chooseDates': 'اختر التواريخ',
      'createEvents': 'إنشاء {n} حدث',
      'eventsCreated': 'تم إنشاء {n} حدث',
      'noDateInRange': 'لا تواريخ في النطاق (تحقق من التواريخ أو اليوم للأسبوعي)',
      'errorAfterCreate': 'خطأ بعد {n} إنشاء: ',
      'dayMonday': 'الإثنين',
      'dayTuesday': 'الثلاثاء',
      'dayWednesday': 'الأربعاء',
      'dayThursday': 'الخميس',
      'dayFriday': 'الجمعة',
      'daySaturday': 'السبت',
      'daySunday': 'الأحد',
      'hintDailyEvent': 'مثال: جري صباحي',
      'hintWeeklyEvent': 'مثال: جري طويل',
      'newEvent': 'حدث جديد',
      'editEvent': 'تعديل الحدث',
      'eventModified': 'تم تعديل الحدث.',
      'eventCreated': 'تم إنشاء الحدث.',
      'cannotLoadGroups': 'تعذر تحميل المجموعات. تحقق من الخادم.',
      'hintTitleEvent': 'مثال: تدريب صباحي',
      'titleRequired': 'العنوان مطلوب',
      'hintEventDetails': 'تفاصيل الحدث...',
      'type': 'النوع',
      'typeDaily': 'تدريب يومي',
      'typeLongRun': 'جري طويل (أسبوعي)',
      'typeNationalRace': 'سباق وطني',
      'typeOther': 'آخر',
      'groupRequired': 'المجموعة مطلوبة',
      'noGroupAvailable': 'لا توجد مجموعة. أنشئ مجموعة أولاً.',
      'date': 'التاريخ',
    },
    'it': {
      'appName': 'Running Club Tunis',
      'login': 'Accesso',
      'loginSubtitle': 'Nome + password (ultime 3 cifre del documento)',
      'name': 'Nome',
      'password': 'Password (ultime 3 cifre del documento)',
      'connect': 'Accedi',
      'continueVisitor': 'Continua come visitatore',
      'news': 'Notizie',
      'history': 'Cronologia',
      'presentation': 'Presentazione',
      'home': 'Home',
      'events': 'Eventi',
      'error': 'Errore',
      'refresh': 'Aggiorna',
      'close': 'Chiudi',
      'language': 'Lingua',
      'nameRequired': 'Il nome è obbligatorio',
      'passwordRequired': 'La password è obbligatoria',
      'groups': 'Gruppi',
      'administration': 'Amministrazione',
      'programmes': 'Programmi',
      'connectTooltip': 'Accedi',
      'logoutTooltip': 'Esci',
      'welcomeLabel': 'Running Club Tunis',
      'loginScreenLabel': 'Schermata di accesso',
      'mainScreenLabel': 'Schermata principale',
      'retry': 'Riprova',
      'noEventInHistory': 'Nessun evento nella cronologia',
      'noNews': 'Nessuna notizia al momento',
      'historyTitle': 'Storia del club',
      'presentationTitle': 'Presentazione del club',
      'required': 'Obbligatorio',
      'cancel': 'Annulla',
      'save': 'Salva',
      'create': 'Crea',
      'delete': 'Elimina',
      'edit': 'Modifica',
      'users': 'Utenti',
      'createUser': 'Crea utente',
      'noUser': 'Nessun utente',
      'editUser': 'Modifica utente',
      'newUser': 'Nuovo utente',
      'deleteUser': 'Elimina utente',
      'deleteUserConfirm': 'Eliminare {name}? Questa azione non può essere annullata.',
      'userDeleted': 'Utente eliminato',
      'userModified': 'Utente modificato',
      'userCreated': 'Utente creato',
      'phone': 'Telefono',
      'description': 'Descrizione',
      'trainingProgrammes': 'Programmi di allenamento',
      'createProgramme': 'Crea programma',
      'noProgramme': 'Nessun programma',
      'deleteProgramme': 'Elimina programma',
      'programmeDeleted': 'Programma eliminato',
      'programmeModified': 'Programma modificato',
      'programmeCreated': 'Programma creato',
      'editProgramme': 'Modifica programma',
      'newProgramme': 'Nuovo programma',
      'selectGroup': 'Seleziona un gruppo',
      'selectGroupSnackbar': 'Seleziona un gruppo',
      'startDate': 'Data di inizio',
      'endDate': 'Data di fine',
      'shareToAdherents': 'Condividi con i membri',
      'permissions': 'Permessi',
      'createPermission': 'Crea permesso',
      'noPermission': 'Nessun permesso',
      'notDefined': 'Non definito',
      'adminPrincipal': 'Admin principale',
      'adminCoach': 'Admin allenatore',
      'adminGroup': 'Admin gruppo',
      'adherent': 'Membro',
      'hello': 'Ciao!',
      'createEvent': 'Crea evento',
      'firstName': 'Nome',
      'email': 'Email',
      'role': 'Ruolo',
      'cin': 'Documento',
      'title': 'Titolo',
      'group': 'Gruppo',
      'presentationHistorySection': 'Storia',
      'presentationHistoryContent': 'Running Club Tunis è un club di corsa fondato a Tunisi. '
          'Dalla sua creazione, il club riunisce appassionati di running '
          'per condividere momenti di sport, superamento e convivialità.',
      'presentationValuesSection': 'I nostri valori',
      'presentationValuesContent': '• Passione: L\'amore per la corsa ci unisce\n'
          '• Solidarietà: Ognuno avanza al proprio ritmo, insieme\n'
          '• Rispetto: Per sé, gli altri e l\'ambiente\n'
          '• Superamento: Porsi obiettivi e raggiungerli',
      'presentationObjectivesSection': 'Obiettivi',
      'presentationObjectivesContent': '• Promuovere la pratica della corsa a Tunisi\n'
          '• Organizzare uscite regolari e eventi\n'
          '• Creare una comunità di corridori accogliente\n'
          '• Rappresentare il club nelle gare nazionali',
      'presentationCharterSection': 'Carta',
      'presentationCharterContent': 'Unendosi al Running Club Tunis, ogni membro si impegna a:\n'
          '• Rispettare orari e luoghi di incontro\n'
          '• Essere puntuale e avvisare in caso di assenza\n'
          '• Adottare un atteggiamento accogliente verso tutti\n'
          '• Partecipare attivamente alla vita del club',
      'presentationGroupsSection': 'Organizzazione dei gruppi',
      'presentationGroupsContent': 'Il club è organizzato in diversi gruppi in base ai livelli e agli obiettivi:\n'
          '• Principianti: Scoperta del running\n'
          '• Intermedi: Progressione e regolarità\n'
          '• Confermati: Prestazioni e competizioni\n'
          'Ogni gruppo ha un responsabile e un programma adatto.',
      'createSeries': 'Creazione in serie',
      'themeTooltip': 'Cambia tema (Chiaro / Scuro / Alto contrasto)',
      'themeLight': 'Chiaro',
      'themeDark': 'Scuro',
      'themeHighContrast': 'Alto contrasto (daltonico)',
      'userManagement': 'Gestione utenti',
      'userManagementSubtitle': 'Crea, modifica, elimina account e assegna ruoli',
      'permissionsManagement': 'Gestione permessi',
      'permissionsManagementSubtitle': 'Crea, modifica, elimina permessi',
      'daily': 'Quotidiano',
      'weekly': 'Settimanale',
      'time': 'Ora',
      'from': 'Da',
      'to': 'A',
      'choose': 'Scegli',
      'dayOfWeek': 'Giorno della settimana',
      'eventsWillBeCreated': '{n} evento/i saranno creati',
      'chooseDates': 'Scegli le date',
      'createEvents': 'Crea {n} evento/i',
      'eventsCreated': '{n} evento/i creati',
      'noDateInRange': 'Nessuna data nell\'intervallo (controlla date o giorno per settimanale)',
      'errorAfterCreate': 'Errore dopo {n} creazione/i: ',
      'dayMonday': 'Lunedì',
      'dayTuesday': 'Martedì',
      'dayWednesday': 'Mercoledì',
      'dayThursday': 'Giovedì',
      'dayFriday': 'Venerdì',
      'daySaturday': 'Sabato',
      'daySunday': 'Domenica',
      'hintDailyEvent': 'Es: Corsa mattutina',
      'hintWeeklyEvent': 'Es: Uscita lunga',
      'newEvent': 'Nuovo evento',
      'editEvent': 'Modifica evento',
      'eventModified': 'Evento modificato.',
      'eventCreated': 'Evento creato.',
      'cannotLoadGroups': 'Impossibile caricare i gruppi. Verifica il backend.',
      'hintTitleEvent': 'Es: Allenamento mattutino',
      'titleRequired': 'Il titolo è obbligatorio',
      'hintEventDetails': 'Dettagli dell\'evento...',
      'type': 'Tipo',
      'typeDaily': 'Allenamento quotidiano',
      'typeLongRun': 'Uscita lunga (settimanale)',
      'typeNationalRace': 'Corsa nazionale',
      'typeOther': 'Altro',
      'groupRequired': 'Il gruppo è obbligatorio',
      'noGroupAvailable': 'Nessun gruppo disponibile. Crea prima un gruppo.',
      'date': 'Data',
    },
    'de': {
      'appName': 'Running Club Tunis',
      'login': 'Anmeldung',
      'loginSubtitle': 'Name + Passwort (letzte 3 Ziffern Ausweis)',
      'name': 'Name',
      'password': 'Passwort (letzte 3 Ziffern Ausweis)',
      'connect': 'Anmelden',
      'continueVisitor': 'Als Besucher fortfahren',
      'news': 'Neuigkeiten',
      'history': 'Verlauf',
      'presentation': 'Präsentation',
      'home': 'Startseite',
      'events': 'Veranstaltungen',
      'error': 'Fehler',
      'refresh': 'Aktualisieren',
      'close': 'Schließen',
      'language': 'Sprache',
      'nameRequired': 'Der Name ist erforderlich',
      'passwordRequired': 'Das Passwort ist erforderlich',
      'groups': 'Gruppen',
      'administration': 'Verwaltung',
      'programmes': 'Programme',
      'connectTooltip': 'Anmelden',
      'logoutTooltip': 'Abmelden',
      'welcomeLabel': 'Running Club Tunis',
      'loginScreenLabel': 'Anmeldebildschirm',
      'mainScreenLabel': 'Hauptbildschirm',
      'retry': 'Erneut versuchen',
      'noEventInHistory': 'Keine Ereignisse in der Chronik',
      'noNews': 'Keine Neuigkeiten',
      'historyTitle': 'Vereinsgeschichte',
      'presentationTitle': 'Vereinspräsentation',
      'required': 'Erforderlich',
      'cancel': 'Abbrechen',
      'save': 'Speichern',
      'create': 'Erstellen',
      'delete': 'Löschen',
      'edit': 'Bearbeiten',
      'users': 'Benutzer',
      'createUser': 'Benutzer erstellen',
      'noUser': 'Kein Benutzer',
      'editUser': 'Benutzer bearbeiten',
      'newUser': 'Neuer Benutzer',
      'deleteUser': 'Benutzer löschen',
      'deleteUserConfirm': '{name} löschen? Diese Aktion kann nicht rückgängig gemacht werden.',
      'userDeleted': 'Benutzer gelöscht',
      'userModified': 'Benutzer geändert',
      'userCreated': 'Benutzer erstellt',
      'phone': 'Telefon',
      'description': 'Beschreibung',
      'trainingProgrammes': 'Trainingsprogramme',
      'createProgramme': 'Programm erstellen',
      'noProgramme': 'Kein Programm',
      'deleteProgramme': 'Programm löschen',
      'programmeDeleted': 'Programm gelöscht',
      'programmeModified': 'Programm geändert',
      'programmeCreated': 'Programm erstellt',
      'editProgramme': 'Programm bearbeiten',
      'newProgramme': 'Neues Programm',
      'selectGroup': 'Gruppe auswählen',
      'selectGroupSnackbar': 'Bitte Gruppe auswählen',
      'startDate': 'Startdatum',
      'endDate': 'Enddatum',
      'shareToAdherents': 'An Mitglieder teilen',
      'permissions': 'Berechtigungen',
      'createPermission': 'Berechtigung erstellen',
      'noPermission': 'Keine Berechtigung',
      'notDefined': 'Nicht definiert',
      'adminPrincipal': 'Hauptadmin',
      'adminCoach': 'Trainer-Admin',
      'adminGroup': 'Gruppen-Admin',
      'adherent': 'Mitglied',
      'hello': 'Hallo!',
      'createEvent': 'Event erstellen',
      'firstName': 'Vorname',
      'email': 'E-Mail',
      'role': 'Rolle',
      'cin': 'Ausweisnummer',
      'title': 'Titel',
      'group': 'Gruppe',
      'presentationHistorySection': 'Geschichte',
      'presentationHistoryContent': 'Running Club Tunis ist ein in Tunis gegründeter Laufverein. '
          'Seit seiner Gründung bringt der Verein Laufbegeisterte zusammen '
          'um Momente des Sports, der Leistung und der Geselligkeit zu teilen.',
      'presentationValuesSection': 'Unsere Werte',
      'presentationValuesContent': '• Leidenschaft: Die Liebe zum Laufen verbindet uns\n'
          '• Solidarität: Jeder macht in seinem Tempo Fortschritte, gemeinsam\n'
          '• Respekt: Für sich selbst, andere und die Umwelt\n'
          '• Überwindung: Ziele setzen und erreichen',
      'presentationObjectivesSection': 'Ziele',
      'presentationObjectivesContent': '• Laufen in Tunis fördern\n'
          '• Regelmäßige Ausflüge und Veranstaltungen organisieren\n'
          '• Eine herzliche Läufergemeinschaft schaffen\n'
          '• Den Verein bei nationalen Rennen vertreten',
      'presentationCharterSection': 'Charta',
      'presentationCharterContent': 'Mit dem Beitritt zum Running Club Tunis verpflichtet sich jedes Mitglied:\n'
          '• Treffzeiten und -orte zu respektieren\n'
          '• Pünktlich zu sein und bei Abwesenheit Bescheid zu geben\n'
          '• Eine einladende Haltung gegenüber allen zu zeigen\n'
          '• Aktiv am Vereinsleben teilzunehmen',
      'presentationGroupsSection': 'Gruppenorganisation',
      'presentationGroupsContent': 'Der Verein ist je nach Niveau und Zielen in mehrere Gruppen organisiert:\n'
          '• Anfänger: Laufen entdecken\n'
          '• Fortgeschrittene: Fortschritt und Regelmäßigkeit\n'
          '• Bestätigte: Leistung und Wettkämpfe\n'
          'Jede Gruppe hat einen Leiter und ein angepasstes Programm.',
      'createSeries': 'Serienerstellung',
      'themeTooltip': 'Theme ändern (Hell / Dunkel / Hoher Kontrast)',
      'themeLight': 'Hell',
      'themeDark': 'Dunkel',
      'themeHighContrast': 'Hoher Kontrast (farbenblind)',
      'userManagement': 'Benutzerverwaltung',
      'userManagementSubtitle': 'Konten erstellen, bearbeiten, löschen und Rollen zuweisen',
      'permissionsManagement': 'Berechtigungsverwaltung',
      'permissionsManagementSubtitle': 'Berechtigungen erstellen, bearbeiten, löschen',
      'daily': 'Täglich',
      'weekly': 'Wöchentlich',
      'time': 'Uhrzeit',
      'from': 'Von',
      'to': 'Bis',
      'choose': 'Wählen',
      'dayOfWeek': 'Wochentag',
      'eventsWillBeCreated': '{n} Veranstaltung(en) werden erstellt',
      'chooseDates': 'Daten wählen',
      'createEvents': '{n} Veranstaltung(en) erstellen',
      'eventsCreated': '{n} Veranstaltung(en) erstellt',
      'noDateInRange': 'Kein Datum im Bereich (Daten oder Tag für wöchentlich prüfen)',
      'errorAfterCreate': 'Fehler nach {n} Erstellung(en): ',
      'dayMonday': 'Montag',
      'dayTuesday': 'Dienstag',
      'dayWednesday': 'Mittwoch',
      'dayThursday': 'Donnerstag',
      'dayFriday': 'Freitag',
      'daySaturday': 'Samstag',
      'daySunday': 'Sonntag',
      'hintDailyEvent': 'z.B. Morgentraining',
      'hintWeeklyEvent': 'z.B. Langer Lauf',
      'newEvent': 'Neue Veranstaltung',
      'editEvent': 'Veranstaltung bearbeiten',
      'eventModified': 'Veranstaltung geändert.',
      'eventCreated': 'Veranstaltung erstellt.',
      'cannotLoadGroups': 'Gruppen konnten nicht geladen werden. Backend prüfen.',
      'hintTitleEvent': 'z.B. Morgentraining',
      'titleRequired': 'Der Titel ist erforderlich',
      'hintEventDetails': 'Details der Veranstaltung...',
      'type': 'Typ',
      'typeDaily': 'Tägliches Training',
      'typeLongRun': 'Langer Lauf (wöchentlich)',
      'typeNationalRace': 'Nationales Rennen',
      'typeOther': 'Sonstiges',
      'groupRequired': 'Die Gruppe ist erforderlich',
      'noGroupAvailable': 'Keine Gruppe verfügbar. Erstellen Sie zuerst eine Gruppe.',
      'date': 'Datum',
    },
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['fr', 'en', 'ar', 'it', 'de'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
