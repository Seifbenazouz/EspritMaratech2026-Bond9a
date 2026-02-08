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
  String get presentationWhoWeAre => _localizedValues[_localeKey]!['presentationWhoWeAre']!;
  String get presentationWhoWeAreContent => _localizedValues[_localeKey]!['presentationWhoWeAreContent']!;
  String get presentationMotto => _localizedValues[_localeKey]!['presentationMotto']!;
  String get presentationJoinUs => _localizedValues[_localeKey]!['presentationJoinUs']!;
  String get presentationLearnMore => _localizedValues[_localeKey]!['presentationLearnMore']!;
  String get presentationBlog => _localizedValues[_localeKey]!['presentationBlog']!;
  String get presentationInstagram => _localizedValues[_localeKey]!['presentationInstagram']!;
  String get presentationFacebook => _localizedValues[_localeKey]!['presentationFacebook']!;
  String get publishNews => _localizedValues[_localeKey]!['publishNews']!;
  String get publishNewsSubtitle => _localizedValues[_localeKey]!['publishNewsSubtitle']!;
  String get newsPublished => _localizedValues[_localeKey]!['newsPublished']!;
  String get newsFeatured => _localizedValues[_localeKey]!['newsFeatured']!;
  String get readMore => _localizedValues[_localeKey]!['readMore']!;
  String newsCount(int n) => _localizedValues[_localeKey]!['newsCount']!.replaceAll('{n}', '$n');
  String get newsEmptySubtitle => _localizedValues[_localeKey]!['newsEmptySubtitle']!;
  String get createSeries => _localizedValues[_localeKey]!['createSeries']!;
  String get createSeriesSubtitle => _localizedValues[_localeKey]!['createSeriesSubtitle']!;
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
  String get createGroup => _localizedValues[_localeKey]!['createGroup']!;
  String get editGroup => _localizedValues[_localeKey]!['editGroup']!;
  String get groupCreated => _localizedValues[_localeKey]!['groupCreated']!;
  String get groupModified => _localizedValues[_localeKey]!['groupModified']!;
  String get groupLevelBeginner => _localizedValues[_localeKey]!['groupLevelBeginner']!;
  String get groupLevelIntermediate => _localizedValues[_localeKey]!['groupLevelIntermediate']!;
  String get groupLevelAdvanced => _localizedValues[_localeKey]!['groupLevelAdvanced']!;
  String get selectResponsable => _localizedValues[_localeKey]!['selectResponsable']!;
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
  String get monGroupe => _localizedValues[_localeKey]!['monGroupe']!;
  String get noGroupsForMember => _localizedValues[_localeKey]!['noGroupsForMember']!;
  String get responsableLabel => _localizedValues[_localeKey]!['responsableLabel']!;
  String membersCount(int n) => _localizedValues[_localeKey]!['membersCount']!.replaceAll('{n}', '$n');
  String groupCount(int n) => _localizedValues[_localeKey]!['groupCount']!.replaceAll('{n}', '$n');
  String get addMember => _localizedValues[_localeKey]!['addMember']!;
  String get remove => _localizedValues[_localeKey]!['remove']!;
  String get removeMemberTitle => _localizedValues[_localeKey]!['removeMemberTitle']!;
  String removeMemberConfirm(String name) => _localizedValues[_localeKey]!['removeMemberConfirm']!.replaceAll('{name}', name);
  String get memberRemoved => _localizedValues[_localeKey]!['memberRemoved']!;
  String get members => _localizedValues[_localeKey]!['members']!;
  String get findPartner => _localizedValues[_localeKey]!['findPartner']!;
  String get matchingInProgress => _localizedValues[_localeKey]!['matchingInProgress']!;
  String get noPartnerMatch => _localizedValues[_localeKey]!['noPartnerMatch']!;
  String get noPartnerMatchHint => _localizedValues[_localeKey]!['noPartnerMatchHint']!;
  String get inviterPartenaire => _localizedValues[_localeKey]!['inviterPartenaire']!;
  String get invitationEnvoyee => _localizedValues[_localeKey]!['invitationEnvoyee']!;
  String get invitationErreur => _localizedValues[_localeKey]!['invitationErreur']!;
  String get matchFound => _localizedValues[_localeKey]!['matchFound']!;
  String get filterByGroup => _localizedValues[_localeKey]!['filterByGroup']!;
  String get filterByDate => _localizedValues[_localeKey]!['filterByDate']!;
  String get allGroups => _localizedValues[_localeKey]!['allGroups']!;
  String get periodAll => _localizedValues[_localeKey]!['periodAll']!;
  String get periodToday => _localizedValues[_localeKey]!['periodToday']!;
  String get periodThisWeek => _localizedValues[_localeKey]!['periodThisWeek']!;
  String get periodThisMonth => _localizedValues[_localeKey]!['periodThisMonth']!;
  String get noMembers => _localizedValues[_localeKey]!['noMembers']!;
  String get noAdherentAvailable => _localizedValues[_localeKey]!['noAdherentAvailable']!;
  String get statsTitle => _localizedValues[_localeKey]!['statsTitle']!;
  String get statsTotalKm => _localizedValues[_localeKey]!['statsTotalKm']!;
  String get statsNbSorties => _localizedValues[_localeKey]!['statsNbSorties']!;
  String get statsPaceMoyen => _localizedValues[_localeKey]!['statsPaceMoyen']!;
  String get statsNbEvenements => _localizedValues[_localeKey]!['statsNbEvenements']!;
  String get statsPlusLongueSortie => _localizedValues[_localeKey]!['statsPlusLongueSortie']!;
  String get statsMeilleurPace => _localizedValues[_localeKey]!['statsMeilleurPace']!;
  String get statsEmptyHint => _localizedValues[_localeKey]!['statsEmptyHint']!;
  String get statsRecordRunHint => _localizedValues[_localeKey]!['statsRecordRunHint']!;

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
      'presentationTitle': 'Présentation du Running Club Tunis',
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
      'presentationWhoWeAre': 'Qui sommes-nous ?',
      'presentationWhoWeAreContent': 'Le Running Club Tunis (RCT) est une association sportive tunisienne passionnée par la course à pied et le sport en général. Fondé pour promouvoir la pratique du running accessible à tous, quel que soit le niveau, le RCT offre des séances de coaching adaptées ou personnalisées pour ses membres.',
      'presentationMotto': '« Running Club Tunis... Plus qu\'un club... une famille. »',
      'presentationHistorySection': 'Historique du Club',
      'presentationHistoryContent': 'Depuis sa création, le RCT s\'est engagé à créer une communauté soudée autour de la course à pied. Au fil des années, le club a organisé et participé à de nombreux événements, renforçant ainsi son rôle dans la promotion du sport en Tunisie.',
      'presentationValuesSection': 'Nos valeurs',
      'presentationValuesContent': '• Accessibilité : Offrir la possibilité à chacun de pratiquer la course à pied, peu importe son niveau.\n'
          '• Solidarité : Favoriser l\'entraide et le soutien mutuel entre les membres.\n'
          '• Engagement : Encourager la participation active dans les activités du club et au sein de la communauté.\n'
          '• Respect : Promouvoir le respect des autres, de soi-même et de l\'environnement.',
      'presentationObjectivesSection': 'Objectifs du Club',
      'presentationObjectivesContent': '• Encourager la pratique régulière de la course à pied.\n'
          '• Organiser des événements sportifs pour rassembler la communauté.\n'
          '• Offrir des séances d\'entraînement adaptées aux besoins de chacun.\n'
          '• Promouvoir un mode de vie sain et actif.',
      'presentationCharterSection': 'Charte éthique',
      'presentationCharterContent': 'Le club a élaboré une charte éthique sportive, approuvée à l\'unanimité, qui reflète son engagement envers des pratiques sportives responsables et respectueuses.',
      'presentationGroupsSection': 'Organisation des groupes',
      'presentationGroupsContent': 'Le RCT structure ses activités en différents groupes pour répondre aux besoins variés de ses membres :\n'
          '• Débutants : Pour ceux qui souhaitent découvrir la course à pied en douceur.\n'
          '• Intermédiaires : Pour les coureurs ayant une certaine expérience et désirant progresser.\n'
          '• Avancés : Pour les coureurs expérimentés visant des performances spécifiques.\n'
          'Des séances spécifiques, comme des entraînements en piscine ou des sorties vélo, sont également organisées pour diversifier les activités.',
      'publishNews': 'Publier une actualité',
      'publishNewsSubtitle': 'Créer une news visible dans la page Actualités',
      'newsPublished': 'Actualité publiée avec succès',
      'newsFeatured': 'À la une',
      'readMore': 'Lire la suite',
      'newsCount': '{n} actualité(s)',
      'newsEmptySubtitle': 'Les actualités du club apparaîtront ici.',
      'presentationJoinUs': 'Rejoignez-nous !',
      'presentationLearnMore': 'Pour en savoir plus sur nos activités et rejoindre la communauté RCT :',
      'presentationBlog': 'Blog officiel',
      'presentationInstagram': 'Instagram',
      'presentationFacebook': 'Facebook',
      'createSeries': 'Création en série',
      'createSeriesSubtitle': 'Créer plusieurs événements à la fois',
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
      'createGroup': 'Créer un groupe',
      'editGroup': 'Modifier le groupe',
      'groupCreated': 'Groupe créé',
      'groupModified': 'Groupe modifié',
      'groupLevelBeginner': 'Débutant',
      'groupLevelIntermediate': 'Intermédiaire',
      'groupLevelAdvanced': 'Avancé',
      'selectResponsable': 'Responsable du groupe',
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
      'monGroupe': 'Mon groupe',
      'noGroupsForMember': 'Vous n\'appartenez à aucun groupe pour le moment.',
      'responsableLabel': 'Responsable',
      'membersCount': '{n} membre(s)',
      'groupCount': '{n} groupe(s)',
      'addMember': 'Ajouter',
      'remove': 'Retirer',
      'removeMemberTitle': 'Retirer du groupe',
      'removeMemberConfirm': 'Retirer {name} du groupe ?',
      'memberRemoved': 'Membre retiré du groupe',
      'members': 'Membres',
      'findPartner': 'Trouver un partenaire',
      'matchingInProgress': 'Recherche de partenaires en cours...',
      'noPartnerMatch': 'Aucun partenaire trouvé pour le moment.',
      'noPartnerMatchHint': 'Rejoignez un groupe et participez aux événements pour obtenir des suggestions.',
      'inviterPartenaire': 'Inviter à courir',
      'invitationEnvoyee': 'Invitation envoyée !',
      'invitationErreur': 'Impossible d\'envoyer l\'invitation',
      'matchFound': 'Matchs trouvés !',
      'filterByGroup': 'Filtrer par groupe',
      'filterByDate': 'Filtrer par date',
      'allGroups': 'Tous les groupes',
      'periodAll': 'Tous',
      'periodToday': 'Aujourd\'hui',
      'periodThisWeek': 'Cette semaine',
      'periodThisMonth': 'Ce mois',
      'noMembers': 'Aucun membre',
      'noAdherentAvailable': 'Aucun adhérent disponible à ajouter',
      'statsTitle': 'Mes statistiques',
      'statsTotalKm': 'Km courus',
      'statsNbSorties': 'Sorties',
      'statsPaceMoyen': 'Pace moyen',
      'statsNbEvenements': 'Événements',
      'statsPlusLongueSortie': 'Plus longue sortie',
      'statsMeilleurPace': 'Meilleur pace',
      'statsEmptyHint': 'Enregistrez des sorties et participez aux événements pour voir vos stats.',
      'statsRecordRunHint': 'Enregistrer une sortie',
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
      'presentationTitle': 'Running Club Tunis Presentation',
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
      'presentationWhoWeAre': 'Who are we?',
      'presentationWhoWeAreContent': 'Running Club Tunis (RCT) is a Tunisian sports association passionate about running and sport in general. Founded to promote running practice accessible to all, regardless of level, RCT offers adapted or personalized coaching sessions for its members.',
      'presentationMotto': '"Running Club Tunis... More than a club... a family."',
      'presentationHistorySection': 'Club History',
      'presentationHistoryContent': 'Since its creation, RCT has been committed to building a close-knit community around running. Over the years, the club has organized and participated in numerous events, strengthening its role in promoting sport in Tunisia.',
      'presentationValuesSection': 'Our values',
      'presentationValuesContent': '• Accessibility: Offer everyone the opportunity to practice running, whatever their level.\n'
          '• Solidarity: Foster mutual support among members.\n'
          '• Commitment: Encourage active participation in club activities and the community.\n'
          '• Respect: Promote respect for others, oneself and the environment.',
      'presentationObjectivesSection': 'Club Objectives',
      'presentationObjectivesContent': '• Encourage regular running practice.\n'
          '• Organize sports events to bring the community together.\n'
          '• Offer training sessions adapted to everyone\'s needs.\n'
          '• Promote a healthy and active lifestyle.',
      'presentationCharterSection': 'Ethical Charter',
      'presentationCharterContent': 'The club has developed a sports ethical charter, approved unanimously, which reflects its commitment to responsible and respectful sports practices.',
      'presentationGroupsSection': 'Group Organization',
      'presentationGroupsContent': 'RCT structures its activities in different groups to meet the varied needs of its members:\n'
          '• Beginners: For those who want to discover running gently.\n'
          '• Intermediate: For runners with some experience wanting to progress.\n'
          '• Advanced: For experienced runners aiming for specific performances.\n'
          'Specific sessions, such as pool training or bike outings, are also organized to diversify activities.',
      'publishNews': 'Publish news',
      'publishNewsSubtitle': 'Create a news item visible on the News page',
      'newsPublished': 'News published successfully',
      'newsFeatured': 'Featured',
      'readMore': 'Read more',
      'newsCount': '{n} news item(s)',
      'newsEmptySubtitle': 'Club news will appear here.',
      'presentationJoinUs': 'Join us!',
      'presentationLearnMore': 'To learn more about our activities and join the RCT community:',
      'presentationBlog': 'Official blog',
      'presentationInstagram': 'Instagram',
      'presentationFacebook': 'Facebook',
      'createSeries': 'Series creation',
      'createSeriesSubtitle': 'Create multiple events at once',
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
      'createGroup': 'Create group',
      'editGroup': 'Edit group',
      'groupCreated': 'Group created',
      'groupModified': 'Group modified',
      'groupLevelBeginner': 'Beginner',
      'groupLevelIntermediate': 'Intermediate',
      'groupLevelAdvanced': 'Advanced',
      'selectResponsable': 'Group manager',
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
      'monGroupe': 'My group',
      'noGroupsForMember': 'You are not in any group yet.',
      'responsableLabel': 'Manager',
      'membersCount': '{n} member(s)',
      'groupCount': '{n} group(s)',
      'addMember': 'Add',
      'remove': 'Remove',
      'removeMemberTitle': 'Remove from group',
      'removeMemberConfirm': 'Remove {name} from group?',
      'memberRemoved': 'Member removed from group',
      'members': 'Members',
      'findPartner': 'Find a partner',
      'matchingInProgress': 'Searching for partners...',
      'noPartnerMatch': 'No partner found at the moment.',
      'noPartnerMatchHint': 'Join a group and participate in events to get suggestions.',
      'inviterPartenaire': 'Invite to run',
      'invitationEnvoyee': 'Invitation sent!',
      'invitationErreur': 'Unable to send invitation',
      'matchFound': 'Matches found!',
      'filterByGroup': 'Filter by group',
      'filterByDate': 'Filter by date',
      'allGroups': 'All groups',
      'periodAll': 'All',
      'periodToday': 'Today',
      'periodThisWeek': 'This week',
      'periodThisMonth': 'This month',
      'noMembers': 'No members',
      'noAdherentAvailable': 'No adherent available to add',
      'statsTitle': 'My statistics',
      'statsTotalKm': 'Km run',
      'statsNbSorties': 'Runs',
      'statsPaceMoyen': 'Average pace',
      'statsNbEvenements': 'Events',
      'statsPlusLongueSortie': 'Longest run',
      'statsMeilleurPace': 'Best pace',
      'statsEmptyHint': 'Record runs and participate in events to see your stats.',
      'statsRecordRunHint': 'Record a run',
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
      'presentationTitle': 'عرض نادي الجري تونس',
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
      'presentationWhoWeAre': 'من نحن؟',
      'presentationWhoWeAreContent': 'نادي الجري تونس (RCT) جمعية رياضية تونسية شغوفة بالجري والرياضة بشكل عام. تأسس لتعزيز ممارسة الجري المتاحة للجميع، بغض النظر عن المستوى، يقدم RCT جلسات تدريبية مناسبة أو مخصصة لأعضائه.',
      'presentationMotto': '"نادي الجري تونس... أكثر من نادي... عائلة."',
      'presentationHistorySection': 'تاريخ النادي',
      'presentationHistoryContent': 'منذ تأسيسه، التزم RCT ببناء مجتمع متماسك حول الجري. على مر السنين، نظم النادي وشارك في أحداث عديدة، مما عزز دوره في تعزيز الرياضة في تونس.',
      'presentationValuesSection': 'قيمنا',
      'presentationValuesContent': '• إمكانية الوصول: توفير الفرصة للجميع لممارسة الجري، مهما كان مستواهم.\n'
          '• التضامن: تشجيع المساعدة والدعم المتبادل بين الأعضاء.\n'
          '• الالتزام: تشجيع المشاركة النشطة في أنشطة النادي والمجتمع.\n'
          '• الاحترام: تعزيز احترام الآخرين والنفس والبيئة.',
      'presentationObjectivesSection': 'أهداف النادي',
      'presentationObjectivesContent': '• تشجيع ممارسة الجري بانتظام.\n'
          '• تنظيم أحداث رياضية لتجمع المجتمع.\n'
          '• تقديم جلسات تدريبية ملائمة لاحتياجات كل فرد.\n'
          '• تعزيز أسلوب حياة صحي ونشط.',
      'presentationCharterSection': 'الميثاق الأخلاقي',
      'presentationCharterContent': 'أعد النادي ميثاقًا أخلاقيًا رياضيًا، تمت الموافقة عليه بالإجماع، ويعكس التزامه بممارسات رياضية مسؤولة ومحترمة.',
      'presentationGroupsSection': 'تنظيم المجموعات',
      'presentationGroupsContent': 'ينظم RCT أنشطته في مجموعات مختلفة لتلبية احتياجات أعضائه المتنوعة:\n'
          '• المبتدئون: لمن يريد اكتشاف الجري بلطف.\n'
          '• المتوسطون: للعدائين ذوي الخبرة الراغبين في التقدم.\n'
          '• المتقدمون: للعدائين ذوي الخبرة الساعين لأداء محدد.\n'
          'تُنظم أيضًا جلسات خاصة مثل تدريب المسبح أو رحلات الدراجات لتنويع الأنشطة.',
      'publishNews': 'نشر خبر',
      'publishNewsSubtitle': 'إنشاء خبر يظهر في صفحة الأخبار',
      'newsPublished': 'تم نشر الخبر بنجاح',
      'newsFeatured': 'مميز',
      'readMore': 'اقرأ المزيد',
      'newsCount': '{n} خبر',
      'newsEmptySubtitle': 'ستظهر أخبار النادي هنا.',
      'presentationJoinUs': 'انضم إلينا!',
      'presentationLearnMore': 'لمعرفة المزيد عن أنشطتنا والانضمام إلى مجتمع RCT:',
      'presentationBlog': 'المدونة الرسمية',
      'presentationInstagram': 'إنستغرام',
      'presentationFacebook': 'فيسبوك',
      'createSeries': 'إنشاء متسلسل',
      'createSeriesSubtitle': 'إنشاء عدة أحداث دفعة واحدة',
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
      'createGroup': 'إنشاء مجموعة',
      'editGroup': 'تعديل المجموعة',
      'groupCreated': 'تم إنشاء المجموعة',
      'groupModified': 'تم تعديل المجموعة',
      'groupLevelBeginner': 'مبتدئ',
      'groupLevelIntermediate': 'متوسط',
      'groupLevelAdvanced': 'متقدم',
      'selectResponsable': 'مسؤول المجموعة',
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
      'monGroupe': 'مجموعتي',
      'noGroupsForMember': 'أنت لا تنتمي إلى أي مجموعة حتى الآن.',
      'responsableLabel': 'المسؤول',
      'membersCount': '{n} عضو/أعضاء',
      'groupCount': '{n} مجموعة/مجموعات',
      'addMember': 'إضافة',
      'remove': 'إزالة',
      'removeMemberTitle': 'إزالة من المجموعة',
      'removeMemberConfirm': 'إزالة {name} من المجموعة؟',
      'memberRemoved': 'تمت إزالة العضو من المجموعة',
      'members': 'الأعضاء',
      'findPartner': 'البحث عن شريك',
      'matchingInProgress': 'جاري البحث عن شركاء...',
      'noPartnerMatch': 'لم يتم العثور على شريك في الوقت الحالي.',
      'noPartnerMatchHint': 'انضم إلى مجموعة وشارك في الفعاليات للحصول على اقتراحات.',
      'inviterPartenaire': 'دعوة للجري',
      'invitationEnvoyee': 'تم إرسال الدعوة!',
      'invitationErreur': 'تعذر إرسال الدعوة',
      'matchFound': 'تم العثور على تطابقات!',
      'filterByGroup': 'تصفية حسب المجموعة',
      'filterByDate': 'تصفية حسب التاريخ',
      'allGroups': 'جميع المجموعات',
      'periodAll': 'الكل',
      'periodToday': 'اليوم',
      'periodThisWeek': 'هذا الأسبوع',
      'periodThisMonth': 'هذا الشهر',
      'noMembers': 'لا يوجد أعضاء',
      'noAdherentAvailable': 'لا يوجد أعضاء متاحين للإضافة',
      'statsTitle': 'إحصائياتي',
      'statsTotalKm': 'كم مر',
      'statsNbSorties': 'جولات',
      'statsPaceMoyen': 'السرعة المتوسطة',
      'statsNbEvenements': 'فعاليات',
      'statsPlusLongueSortie': 'أطول جولة',
      'statsMeilleurPace': 'أفضل سرعة',
      'statsEmptyHint': 'سجّل الجولات وشارك في الفعاليات لرؤية إحصائياتك.',
      'statsRecordRunHint': 'تسجيل جولة',
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
      'presentationTitle': 'Presentazione Running Club Tunis',
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
      'presentationWhoWeAre': 'Chi siamo?',
      'presentationWhoWeAreContent': 'Running Club Tunis (RCT) è un\'associazione sportiva tunisina appassionata di corsa e sport in generale. Fondato per promuovere la corsa accessibile a tutti, qualunque sia il livello, il RCT offre sessioni di coaching adattate o personalizzate per i suoi membri.',
      'presentationMotto': '"Running Club Tunis... Più di un club... una famiglia."',
      'presentationHistorySection': 'Storia del club',
      'presentationHistoryContent': 'Dalla sua creazione, il RCT si è impegnato a creare una comunità unita attorno alla corsa. Nel corso degli anni, il club ha organizzato e partecipato a numerosi eventi, rafforzando il suo ruolo nella promozione dello sport in Tunisia.',
      'presentationValuesSection': 'I nostri valori',
      'presentationValuesContent': '• Accessibilità: Offrire a tutti la possibilità di praticare la corsa, qualunque sia il livello.\n'
          '• Solidarietà: Favorire il sostegno reciproco tra i membri.\n'
          '• Impegno: Incoraggiare la partecipazione attiva nelle attività del club e nella comunità.\n'
          '• Rispetto: Promuovere il rispetto per gli altri, sé stessi e l\'ambiente.',
      'presentationObjectivesSection': 'Obiettivi del club',
      'presentationObjectivesContent': '• Incoraggiare la pratica regolare della corsa.\n'
          '• Organizzare eventi sportivi per riunire la comunità.\n'
          '• Offrire sessioni di allenamento adattate alle esigenze di ciascuno.\n'
          '• Promuovere uno stile di vita sano e attivo.',
      'presentationCharterSection': 'Carta etica',
      'presentationCharterContent': 'Il club ha elaborato una carta etica sportiva, approvata all\'unanimità, che riflette il suo impegno verso pratiche sportive responsabili e rispettose.',
      'presentationGroupsSection': 'Organizzazione dei gruppi',
      'presentationGroupsContent': 'Il RCT struttura le sue attività in diversi gruppi per rispondere alle esigenze variate dei suoi membri:\n'
          '• Principianti: Per chi vuole scoprire la corsa con dolcezza.\n'
          '• Intermedi: Per i corridori con una certa esperienza che desiderano progredire.\n'
          '• Avanzati: Per i corridori esperti che mirano a prestazioni specifiche.\n'
          'Sono inoltre organizzate sessioni specifiche, come allenamenti in piscina o uscite in bici, per diversificare le attività.',
      'publishNews': 'Pubblica notizia',
      'publishNewsSubtitle': 'Crea una notizia visibile nella pagina Notizie',
      'newsPublished': 'Notizia pubblicata con successo',
      'newsFeatured': 'In evidenza',
      'readMore': 'Leggi di più',
      'newsCount': '{n} notizia/e',
      'newsEmptySubtitle': 'Le notizie del club appariranno qui.',
      'presentationJoinUs': 'Unisciti a noi!',
      'presentationLearnMore': 'Per saperne di più sulle nostre attività e unirti alla comunità RCT:',
      'presentationBlog': 'Blog ufficiale',
      'presentationInstagram': 'Instagram',
      'presentationFacebook': 'Facebook',
      'createSeries': 'Creazione in serie',
      'createSeriesSubtitle': 'Crea più eventi in una volta',
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
      'createGroup': 'Crea gruppo',
      'editGroup': 'Modifica gruppo',
      'groupCreated': 'Gruppo creato',
      'groupModified': 'Gruppo modificato',
      'groupLevelBeginner': 'Principiante',
      'groupLevelIntermediate': 'Intermedio',
      'groupLevelAdvanced': 'Avanzato',
      'selectResponsable': 'Responsabile del gruppo',
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
      'monGroupe': 'Il mio gruppo',
      'noGroupsForMember': 'Non fai parte di nessun gruppo al momento.',
      'responsableLabel': 'Responsabile',
      'membersCount': '{n} membro/i',
      'groupCount': '{n} gruppo/i',
      'addMember': 'Aggiungi',
      'remove': 'Rimuovi',
      'removeMemberTitle': 'Rimuovi dal gruppo',
      'removeMemberConfirm': 'Rimuovere {name} dal gruppo?',
      'memberRemoved': 'Membro rimosso dal gruppo',
      'members': 'Membri',
      'findPartner': 'Trova un partner',
      'matchingInProgress': 'Ricerca partner in corso...',
      'noPartnerMatch': 'Nessun partner trovato al momento.',
      'noPartnerMatchHint': 'Unisciti a un gruppo e partecipa agli eventi per ottenere suggerimenti.',
      'inviterPartenaire': 'Invita a correre',
      'invitationEnvoyee': 'Invito inviato!',
      'invitationErreur': 'Impossibile inviare l\'invito',
      'matchFound': 'Match trovati!',
      'filterByGroup': 'Filtra per gruppo',
      'filterByDate': 'Filtra per data',
      'allGroups': 'Tutti i gruppi',
      'periodAll': 'Tutti',
      'periodToday': 'Oggi',
      'periodThisWeek': 'Questa settimana',
      'periodThisMonth': 'Questo mese',
      'noMembers': 'Nessun membro',
      'noAdherentAvailable': 'Nessun aderente disponibile da aggiungere',
      'statsTitle': 'Le mie statistiche',
      'statsTotalKm': 'Km percorsi',
      'statsNbSorties': 'Uscite',
      'statsPaceMoyen': 'Passo medio',
      'statsNbEvenements': 'Eventi',
      'statsPlusLongueSortie': 'Uscita più lunga',
      'statsMeilleurPace': 'Miglior passo',
      'statsEmptyHint': 'Registra le uscite e partecipa agli eventi per vedere le tue statistiche.',
      'statsRecordRunHint': 'Registra un\'uscita',
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
      'presentationTitle': 'Präsentation Running Club Tunis',
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
      'presentationWhoWeAre': 'Wer sind wir?',
      'presentationWhoWeAreContent': 'Running Club Tunis (RCT) ist ein tunesischer Sportverein, der sich für Laufen und Sport im Allgemeinen begeistert. Gegründet, um das Laufen für alle zugänglich zu machen, unabhängig vom Niveau, bietet der RCT angepasste oder personalisierte Coaching-Sitzungen für seine Mitglieder an.',
      'presentationMotto': '"Running Club Tunis... Mehr als ein Verein... eine Familie."',
      'presentationHistorySection': 'Vereinsgeschichte',
      'presentationHistoryContent': 'Seit seiner Gründung hat sich der RCT verpflichtet, eine feste Gemeinschaft rund ums Laufen aufzubauen. Im Laufe der Jahre hat der Verein zahlreiche Veranstaltungen organisiert und daran teilgenommen und so seine Rolle bei der Förderung des Sports in Tunesien gestärkt.',
      'presentationValuesSection': 'Unsere Werte',
      'presentationValuesContent': '• Zugänglichkeit: Jedem die Möglichkeit bieten, Laufen zu praktizieren, unabhängig vom Niveau.\n'
          '• Solidarität: Gegenseitige Unterstützung unter den Mitgliedern fördern.\n'
          '• Engagement: Aktive Teilnahme an Vereinsaktivitäten und der Gemeinschaft fördern.\n'
          '• Respekt: Respekt für andere, sich selbst und die Umwelt fördern.',
      'presentationObjectivesSection': 'Vereinsziele',
      'presentationObjectivesContent': '• Regelmäßige Laufpraxis fördern.\n'
          '• Sportveranstaltungen organisieren, um die Gemeinschaft zusammenzubringen.\n'
          '• Angepasste Trainingseinheiten für die Bedürfnisse jedes Einzelnen anbieten.\n'
          '• Einen gesunden und aktiven Lebensstil fördern.',
      'presentationCharterSection': 'Ethische Charta',
      'presentationCharterContent': 'Der Verein hat eine sportliche ethische Charta erarbeitet, einstimmig genehmigt, die sein Engagement für verantwortungsvolle und respektvolle Sportpraktiken widerspiegelt.',
      'presentationGroupsSection': 'Gruppenorganisation',
      'presentationGroupsContent': 'Der RCT strukturiert seine Aktivitäten in verschiedenen Gruppen, um die vielfältigen Bedürfnisse seiner Mitglieder zu erfüllen:\n'
          '• Anfänger: Für diejenigen, die das Laufen sanft entdecken möchten.\n'
          '• Fortgeschrittene: Für Läufer mit etwas Erfahrung, die sich verbessern möchten.\n'
          '• Erfahren: Für erfahrene Läufer mit spezifischen Leistungszielen.\n'
          'Spezifische Sitzungen wie Schwimmtraining oder Radausflüge werden ebenfalls organisiert, um die Aktivitäten zu diversifizieren.',
      'publishNews': 'News veröffentlichen',
      'publishNewsSubtitle': 'Eine Nachricht erstellen, die auf der News-Seite sichtbar ist',
      'newsPublished': 'News erfolgreich veröffentlicht',
      'newsFeatured': 'Im Fokus',
      'readMore': 'Weiterlesen',
      'newsCount': '{n} Nachricht(en)',
      'newsEmptySubtitle': 'Die Vereinsnachrichten erscheinen hier.',
      'presentationJoinUs': 'Werden Sie Mitglied!',
      'presentationLearnMore': 'Erfahren Sie mehr über unsere Aktivitäten und treten Sie der RCT-Community bei:',
      'presentationBlog': 'Offizieller Blog',
      'presentationInstagram': 'Instagram',
      'presentationFacebook': 'Facebook',
      'createSeries': 'Serienerstellung',
      'createSeriesSubtitle': 'Mehrere Veranstaltungen auf einmal erstellen',
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
      'createGroup': 'Gruppe erstellen',
      'editGroup': 'Gruppe bearbeiten',
      'groupCreated': 'Gruppe erstellt',
      'groupModified': 'Gruppe geändert',
      'groupLevelBeginner': 'Anfänger',
      'groupLevelIntermediate': 'Fortgeschrittene',
      'groupLevelAdvanced': 'Erfahren',
      'selectResponsable': 'Gruppenleiter',
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
      'monGroupe': 'Meine Gruppe',
      'noGroupsForMember': 'Sie gehören momentan keiner Gruppe an.',
      'responsableLabel': 'Verantwortlicher',
      'membersCount': '{n} Mitglied(er)',
      'groupCount': '{n} Gruppe(n)',
      'addMember': 'Hinzufügen',
      'remove': 'Entfernen',
      'removeMemberTitle': 'Aus Gruppe entfernen',
      'removeMemberConfirm': '{name} aus der Gruppe entfernen?',
      'memberRemoved': 'Mitglied aus Gruppe entfernt',
      'members': 'Mitglieder',
      'findPartner': 'Partner finden',
      'matchingInProgress': 'Partnersuche läuft...',
      'noPartnerMatch': 'Derzeit kein Partner gefunden.',
      'noPartnerMatchHint': 'Treten Sie einer Gruppe bei und nehmen Sie an Veranstaltungen teil.',
      'inviterPartenaire': 'Zum Laufen einladen',
      'invitationEnvoyee': 'Einladung gesendet!',
      'invitationErreur': 'Einladung konnte nicht gesendet werden',
      'matchFound': 'Matches gefunden!',
      'filterByGroup': 'Nach Gruppe filtern',
      'filterByDate': 'Nach Datum filtern',
      'allGroups': 'Alle Gruppen',
      'periodAll': 'Alle',
      'periodToday': 'Heute',
      'periodThisWeek': 'Diese Woche',
      'periodThisMonth': 'Diesen Monat',
      'noMembers': 'Keine Mitglieder',
      'noAdherentAvailable': 'Kein Adherent zum Hinzufügen verfügbar',
      'statsTitle': 'Meine Statistiken',
      'statsTotalKm': 'Gelaufene Km',
      'statsNbSorties': 'Läufe',
      'statsPaceMoyen': 'Durchschnittliches Tempo',
      'statsNbEvenements': 'Veranstaltungen',
      'statsPlusLongueSortie': 'Längster Lauf',
      'statsMeilleurPace': 'Bestes Tempo',
      'statsEmptyHint': 'Registrieren Sie Läufe und nehmen Sie an Veranstaltungen teil, um Ihre Statistiken zu sehen.',
      'statsRecordRunHint': 'Lauf aufzeichnen',
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
