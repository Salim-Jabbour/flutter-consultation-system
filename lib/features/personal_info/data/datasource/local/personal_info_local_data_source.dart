import 'package:shared_preferences/shared_preferences.dart';

abstract class PersonalInfoLocalDataSource {
  const PersonalInfoLocalDataSource();
}

class PersonalInfoLocalDataSourceImpl extends PersonalInfoLocalDataSource {
  PersonalInfoLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;
}
