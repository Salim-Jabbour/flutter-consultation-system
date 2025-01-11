import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/alarm/models/alarm_info.dart';

const String _kDailyAlarms = "preference_daily_alarms";
const String _kSequenceId = "preference_alarms_sequence_id";

void initPreferences() {
  GetIt.instance.registerSingleton<AlarmPreferences>(_AlarmPreferencesImpl());
}

abstract class AlarmPreferences {
  // sets the sequence number, and u get the value of it from this variable _kSequenceId
  Future<int> getSequenceId();

  // set the daily alarms as string, and u get the value of it from this variable _kDailyAlarms
  // its not used anywhere else
  // must be used when loggin in
  Future<bool> setDailyAlarms(List<MedicamentAlarmData> dailyMedicamentAlarm);

  // load daily alarms as List<MedicamentAlarmData>, and u get the value of it from this variable _kDailyAlarms
  // its used in main and alarm_list_page
  Future<List<MedicamentAlarmData>> getDailyAlarms();

  Future<bool> addAlarm(MedicamentAlarmData dailyMedicamentAlarm);

  Future<bool> updateAlarm(MedicamentAlarmData dailyMedicamentAlarm);

  // only used in this file
  Future<MedicamentAlarmData> getDailyAlarmById(int alarmId);

  // FIXME: ask sami what is this
  Future<MedicamentAlarmData?> getMedicamentAlarmDataByAlarmLibId(int alarmId);

  Future<bool> deleteDailyAlarmById(int alarmId);

  // must be used when loggin out
  Future<bool> clearDailyAlarms();
}

class _AlarmPreferencesImpl extends AlarmPreferences {
  @override
  Future<int> getSequenceId() async {
    final preferences = await SharedPreferences.getInstance();

    int? generatedId = preferences.getInt(_kSequenceId);
    generatedId ??= 0;
    await preferences.setInt(_kSequenceId, generatedId + 1);
    return preferences.getInt(_kSequenceId)!;
  }

  @override
  Future<List<MedicamentAlarmData>> getDailyAlarms() async {
    final preferences = await SharedPreferences.getInstance();

    String? alarmJsonList = preferences.getString(_kDailyAlarms);
    if (alarmJsonList == null) {
      return [];
    }
    Iterable l = json.decode(alarmJsonList);
    List<MedicamentAlarmData> posts = List<MedicamentAlarmData>.from(
        l.map((model) => MedicamentAlarmData.fromJson(model)));
    return posts;
  }

  @override
  Future<MedicamentAlarmData?> getMedicamentAlarmDataByAlarmLibId(
    int alarmId,
  ) async {
    var list = await getDailyAlarms();
    for (var alarmData in list) {
      for (var alarmLibId in alarmData.alarmIdsInLib) {
        if (alarmId == alarmLibId) {
          return alarmData;
        }
      }
    }
    return null;
  }

  @override
  Future<bool> setDailyAlarms(List<MedicamentAlarmData> alarms) async {
    final prefs = await SharedPreferences.getInstance();
    var json = jsonEncode(alarms);
    return await prefs.setString(_kDailyAlarms, json);
  }

  @override
  Future<bool> addAlarm(MedicamentAlarmData dailyMedicamentAlarm) async {
    var list = await getDailyAlarms();
    list.add(dailyMedicamentAlarm);
    await setDailyAlarms(list);
    return true;
  }

  @override
  Future<bool> updateAlarm(MedicamentAlarmData dailyMedicamentAlarm) async {
    var list = await getDailyAlarms();
    list[list.indexWhere((element) => element.id == dailyMedicamentAlarm.id)] =
        dailyMedicamentAlarm;
    await setDailyAlarms(list);
    return true;
  }

  @override
  Future<bool> clearDailyAlarms() async {
    await setDailyAlarms([]);
    return true;
  }

  @override
  Future<bool> deleteDailyAlarmById(int alarmId) async {
    var list = await getDailyAlarms();
    var sizeBeforeDelete = list.length;
    list.removeWhere((element) => element.id == alarmId);
    await setDailyAlarms(list);
    var sizeAfterDelete = list.length;
    return sizeBeforeDelete > sizeAfterDelete;
  }

  @override
  Future<MedicamentAlarmData> getDailyAlarmById(int alarmId) async {
    var list = await getDailyAlarms();
    var target = list.firstWhere((element) => element.id == alarmId);
    return target;
  }
}
