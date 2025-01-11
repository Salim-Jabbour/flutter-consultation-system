import 'package:akemha/features/alarm/presentation/enums/alarm_routine.dart';
import 'package:akemha/features/alarm/presentation/enums/alarm_routine_type.dart';
import 'package:akemha/features/alarm/presentation/enums/days.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alarm_info.g.dart';

@JsonSerializable()
class MedicamentAlarmData extends MedicamentAlarm {
  final List<DateTime>
      alarmTimes; // list in daily case, list of one item in other cases
  final AlarmWeekDay? alarmWeekDay; // for weekly case
  final int? selectedDayInMonth; // for monthly case
  List<int> alarmIdsInLib = [];

  MedicamentAlarmData({
    required super.id,
    required super.medicamentName,
    required super.medicamentType, // 7bob abreh, kza;
    required super.alarmRoutine, //weekly ,,,etc
    required super.alarmRoutineType, // mdeh m7ddeh, mzmn
    required super.startDate,
    required super.endDate,
    required this.alarmTimes, //list if it daily, or list has one time if it is weekly
    required this.alarmWeekDay, //mano null if it is weekly
    required this.selectedDayInMonth,
  });

  factory MedicamentAlarmData.fromJson(Map<String, dynamic> json) =>
      _$MedicamentAlarmDataFromJson(json);

  Map<String, dynamic> toJson() => _$MedicamentAlarmDataToJson(this);
}

@JsonSerializable()
class MedicamentAlarm {
  int id;
  String medicamentName;
  String medicamentType;
  AlarmRoutine alarmRoutine;
  AlarmRoutineType alarmRoutineType;
  DateTime startDate;
  DateTime? endDate;

  MedicamentAlarm({
    required this.id,
    required this.medicamentName,
    required this.medicamentType,
    required this.alarmRoutine,
    required this.alarmRoutineType,
    required this.startDate,
    required this.endDate,
  });
}
