import 'package:shared_preferences/shared_preferences.dart';

abstract class HomeLocalDataSource {
  const HomeLocalDataSource();
}

class HomeLocalDataSourceImpl extends HomeLocalDataSource {
  HomeLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;
}
