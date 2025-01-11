import 'package:shared_preferences/shared_preferences.dart';

abstract class ActivityLocalDataSource {
  const ActivityLocalDataSource();
}

class ActivityLocalDataSourceImpl extends ActivityLocalDataSource {
  ActivityLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;
}
