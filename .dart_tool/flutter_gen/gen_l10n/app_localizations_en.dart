


import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get comma => ',';

  @override
  String get toSybmol => '-';

  @override
  String get am => 'AM';

  @override
  String get pm => 'PM';

  @override
  String get on => 'On';

  @override
  String get off => 'Off';

  @override
  String get note => 'Note';

  @override
  String get remind => 'Remind';

  @override
  String get loading => 'Loading';

  @override
  String get downloading => 'Downloading';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get cannotBeEmpty => 'Cannot be empty';

  @override
  String get connectionError => 'There is an error when connecting to the server. Please try again';

  @override
  String get connectTimeoutError => 'Connecting time is too long.Please try again';

  @override
  String get receiveTimeoutError => 'The server currently is busy,Please try agin';

  @override
  String get otherError => 'Unexpected error occures. Please try again';
}
