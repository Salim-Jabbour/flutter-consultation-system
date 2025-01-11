import 'package:shared_preferences/shared_preferences.dart';

abstract class ConsultationLogLocalDataSource {
  const ConsultationLogLocalDataSource();
}

class ConsultationLogLocalDataSourceImpl extends ConsultationLogLocalDataSource {
  ConsultationLogLocalDataSourceImpl(this._prefs);

  final SharedPreferences _prefs;
}
