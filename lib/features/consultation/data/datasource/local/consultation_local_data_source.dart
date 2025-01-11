import 'package:shared_preferences/shared_preferences.dart';

abstract class ConsultationLocalDataSource {
  const ConsultationLocalDataSource();
}

class ConsultationLocalDataSourceImpl extends ConsultationLocalDataSource {
  ConsultationLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;
}
