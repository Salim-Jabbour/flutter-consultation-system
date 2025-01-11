import 'dart:io';

import 'package:akemha/core/storage/alarm_preferences.dart';
import 'package:akemha/core/utils/dbg_print.dart';
import 'package:akemha/features/alarm/models/alarm_info.dart';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';

import '../../../core/resource/asset_manager.dart';
import '../../../core/resource/string_manager.dart';

var _tag = "alarm_scheduler";
var alarmRepo = GetIt.I.get<AlarmPreferences>();
const int _offsetScheduler = 90;

_saveAlarm(MedicamentAlarmData medicamentAlarm) async {
  // save the alarm data like name, times, type, durations... in SharedPref
  await alarmRepo.addAlarm(
      medicamentAlarm); // had sh3'al llkl mo bs ll daily, al s7 ykon al asm addAlarm
}

_updateAlarm(MedicamentAlarmData medicamentAlarm) async {
  // save the alarm data like name, times, type, durations... in SharedPref
  await alarmRepo.updateAlarm(medicamentAlarm);
}

deleteAlarm(MedicamentAlarmData medicamentAlarm) async {
  for (var element in medicamentAlarm.alarmIdsInLib) {
    Alarm.stop(element);
  }
  await alarmRepo.deleteDailyAlarmById(medicamentAlarm.id);
}

/// * @example
/// final dailyAlarm = DailyMedicamentAlarm(
///    id: alarmsHolderId,
///    medicamentName: "medicamentName",
///    medicamentType: "medicamentType",
///    alarmRoutineType: event.routineType,
///    dailyFrequently: 3,
///    alarmTimes: alarmReferences,
///    startingDate: event.startDate,
///    durationInWeeks: event.duration,
///  );
///
Future<bool> schedulerDailyAlarm(MedicamentAlarmData medicamentAlarm, //myModel
    {List<int>? savedIds,
    DateTime? newStart}) async {
  List<int> alarmIds = savedIds ?? [];
  final startDate = newStart ?? medicamentAlarm.startDate;
  late DateTime endDate2;

  if (medicamentAlarm.endDate != null) {
    endDate2 = medicamentAlarm.endDate!;
  } else {
    endDate2 = medicamentAlarm.startDate.add(const Duration(
        days:
            _offsetScheduler)); // _offsetScheduler is 90 days, this is if al marad mzmn
  }
  endDate2 = endDate2.copyWith(hour: 23, minute: 59);
  List<DateTime> daysList = _generateDaysList(startDate, endDate2);
  dbgt(_tag,
      "daysList: ${daysList.length}"); // TODO: make sure that the last day was included.
  for (var day in daysList) {
    for (var time in medicamentAlarm.alarmTimes) {
      dbgt(_tag, "alarmRef: $time");
      // Update the datetime to have the correct day,
      // with correct HH:mm for an alarm
      DateTime modifiedTime = day.copyWith(
        hour: time.hour,
        minute: time.minute,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

      final id = await alarmRepo
          .getSequenceId(); // id al alarm al marbot local bl mobile
      alarmIds.add(id); //al alarms yli bl debug
      final alarmSettings = AlarmSettings(
        id: id,
        dateTime: modifiedTime,
        assetAudioPath: AssetAudioManager.alarmAudio,
        // assetAudioPath: 'asset/audio/cambo.mp3',
        loopAudio: true,
        vibrate: true,
        volume: 0.8,
        fadeDuration: 3.0,
        notificationTitle: StringManager.medicineTime.tr(),
        notificationBody:
            '${StringManager.itsMedicineTime.tr()} ${medicamentAlarm.medicamentName}',
        enableNotificationOnKill: true,
        androidFullScreenIntent: true,
      );
      await Alarm.set(
          alarmSettings: alarmSettings); //al mktbeh 7tt 3nda al alarm
    }
  }

  medicamentAlarm.alarmIdsInLib = alarmIds;
  if (newStart != null) {
    _updateAlarm(medicamentAlarm);
  } else {
    _saveAlarm(medicamentAlarm);
  }
  return true;
}

Future<bool> schedulerWeeklyAlarm(MedicamentAlarmData medicamentAlarm,
    {List<int>? savedIds, DateTime? newStart}) async {
  List<int> alarmIds = savedIds ?? [];
  final startDate = newStart ?? medicamentAlarm.startDate;
  final endDate = medicamentAlarm.endDate ??
      medicamentAlarm.startDate.add(const Duration(days: _offsetScheduler));

  // list of days from start day until end date
  List<DateTime> daysList = _getWeekDayBetween(
      startDate, endDate, medicamentAlarm.alarmWeekDay!.number);
  for (var day in daysList) {
    // for (var time in dailyMedicamentAlarm.alarmTimes) {
    dbgt(_tag, "getWeekDayBetween day: $day");
    // Update the datetime to have the correct day,
    // with correct HH:mm for an alarm
    DateTime modifiedTime = day.copyWith(
      hour: medicamentAlarm.alarmTimes[0].hour,
      minute: medicamentAlarm.alarmTimes[0].minute,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );

    final id = await alarmRepo.getSequenceId();
    alarmIds.add(id);

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: modifiedTime,
      assetAudioPath: AssetAudioManager.alarmAudio,
      // assetAudioPath: 'asset/audio/cambo.mp3',
      loopAudio: false,
      vibrate: true,
      volume: 0.8,
      fadeDuration: 3.0,
      notificationTitle: StringManager.medicineTime.tr(),
      notificationBody:
          '${StringManager.itsMedicineTime.tr()} ${medicamentAlarm.medicamentName}',
      enableNotificationOnKill: Platform.isIOS,
      androidFullScreenIntent: true,
    );
    await Alarm.set(alarmSettings: alarmSettings);
  }

  medicamentAlarm.alarmIdsInLib = alarmIds;
  if (newStart != null) {
    _updateAlarm(medicamentAlarm);
  } else {
    _saveAlarm(medicamentAlarm);
  }
  return true;
}

Future<bool> schedulerMonthlyAlarm(MedicamentAlarmData medicamentAlarm,
    {List<int>? savedIds, DateTime? newStart}) async {
  List<int> alarmIds = savedIds ?? [];
  final startDate = newStart ?? medicamentAlarm.startDate;
  final endDate = medicamentAlarm.endDate ??
      medicamentAlarm.startDate.add(const Duration(days: 365));

  // list of days from start day until end date
  List<DateTime> daysList = _getDayInMonthBetween(
      startDate, endDate, medicamentAlarm.selectedDayInMonth!);
  dbgt(_tag, "schedulerMonthlyAlarm daysList: ${daysList.length}");

  for (var day in daysList) {
    // for (var time in dailyMedicamentAlarm.alarmTimes) {
    dbgt(_tag, "schedulerMonthlyAlarm day: $day");
    // Update the datetime to have the correct day,
    // with correct HH:mm for an alarm
    DateTime modifiedTime = day.copyWith(
      hour: medicamentAlarm.alarmTimes[0].hour,
      minute: medicamentAlarm.alarmTimes[0].minute,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );

    final id = await alarmRepo.getSequenceId();
    alarmIds.add(id);

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: modifiedTime,
      assetAudioPath: AssetAudioManager.alarmAudio,
      // assetAudioPath: 'asset/audio/cambo.mp3',
      loopAudio: false,
      vibrate: true,
      volume: 0.8,
      fadeDuration: 3.0,
      notificationTitle: StringManager.medicineTime.tr(),
      notificationBody:
          '${StringManager.itsMedicineTime.tr()} ${medicamentAlarm.medicamentName}',
      enableNotificationOnKill: Platform.isIOS,
      androidFullScreenIntent: true,
    );
    await Alarm.set(alarmSettings: alarmSettings);
  }
  medicamentAlarm.alarmIdsInLib = alarmIds;
  if (newStart != null) {
    _updateAlarm(medicamentAlarm);
  } else {
    _saveAlarm(medicamentAlarm);
  }
  return true;
}

List<DateTime> _generateDaysList(DateTime startDate, DateTime endDate) {
  //3m trj3 list bkl tware5 al ayam yle ben start w end date included
  List<DateTime> days = [];
  int totalDays = endDate.difference(startDate).inDays +
      1; // Adding 1 to include endDate in the list

  for (int i = 0; i < totalDays; i++) {
    DateTime currentDay = startDate.add(Duration(days: i));
    days.add(currentDay);
  }

  return days;
}

List<DateTime> _getWeekDayBetween(
    //enum week days has numbers for ayam al asbo3
//exaplme: if the user chose monday i'll send weekDayNumber = 2 w al fun r7 yrj3 kl dateTime l ayam al monday between start and end date
    DateTime startDate,
    DateTime endDate,
    int weekDayNumber) {
  List<DateTime> requiredWeekDay = [];

  // Find the first Friday on or after the startDate
  DateTime firstWeekDay = startDate;
  while (firstWeekDay.weekday != weekDayNumber) {
    firstWeekDay = firstWeekDay.add(const Duration(days: 1));
  }

  // Add all Fridays from firstFriday to endDate
  DateTime currentWeekDay = firstWeekDay;
  while (currentWeekDay.isBefore(endDate) ||
      currentWeekDay.isAtSameMomentAs(endDate)) {
    requiredWeekDay.add(currentWeekDay);
    currentWeekDay = currentWeekDay.add(const Duration(days: 7));
  }

  return requiredWeekDay;
}

List<DateTime> _getDayInMonthBetween(
    DateTime startDate, DateTime endDate, int dayInMonth) {
  List<DateTime> days = [];

  // Start with the year and month of the startDate
  int year = startDate.year;
  int month = startDate.month;

  while (DateTime(year, month, dayInMonth).isBefore(endDate) ||
      DateTime(year, month, 5).isAtSameMomentAs(endDate)) {
    DateTime theDay = DateTime(year, month, dayInMonth);

    // Check if the fifthDay is within the date range
    if (theDay.isAfter(startDate) || theDay.isAtSameMomentAs(startDate)) {
      days.add(theDay);
    }

    // Move to the next month
    if (month == 12) {
      year++;
      month = 1;
    } else {
      month++;
    }
  }

  return days;
}

// called in main
Future<bool> continueSchedulerDailyAlarm(
  MedicamentAlarmData medicamentAlarm,
  DateTime start,
) async {
  dbgt(_tag, "continueSchedulerDailyAlarm");
  schedulerDailyAlarm(
    medicamentAlarm,
    savedIds: medicamentAlarm.alarmIdsInLib,
    newStart: start.add(const Duration(days: 1)),
  );
  return true;
}

// never called FIXME: ask sami
Future<bool> continueSchedulerWeeklyAlarm(
  MedicamentAlarmData medicamentAlarm,
  DateTime start,
) async {
  schedulerWeeklyAlarm(
    medicamentAlarm,
    savedIds: medicamentAlarm.alarmIdsInLib,
    newStart: start.add(const Duration(days: 1)),
  );
  return true;
}

// never called FIXME: ask sami
Future<bool> continueSchedulerMonthlyAlarm(
  MedicamentAlarmData medicamentAlarm,
  DateTime start,
) async {
  schedulerMonthlyAlarm(
    medicamentAlarm,
    savedIds: medicamentAlarm.alarmIdsInLib,
    newStart: start.add(const Duration(days: 1)),
  );
  return true;
}
