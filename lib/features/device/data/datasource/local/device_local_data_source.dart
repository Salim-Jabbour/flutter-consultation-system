import 'package:shared_preferences/shared_preferences.dart';

abstract class DeviceLocalDataSource {
  const DeviceLocalDataSource();
}

class DeviceLocalDataSourceImpl extends DeviceLocalDataSource {
  DeviceLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;

}
