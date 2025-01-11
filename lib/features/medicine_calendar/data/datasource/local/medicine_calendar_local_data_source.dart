// ignore_for_file: unused_field

import 'package:shared_preferences/shared_preferences.dart';

abstract class MedicineCalendarLocalDataSource {
  const MedicineCalendarLocalDataSource();
}

class MedicineCalendarLocalDataSourceImpl extends MedicineCalendarLocalDataSource {
  MedicineCalendarLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;
}
