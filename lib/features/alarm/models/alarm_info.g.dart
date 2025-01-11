// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicamentAlarmData _$MedicamentAlarmDataFromJson(Map<String, dynamic> json) =>
    MedicamentAlarmData(
      id: (json['id'] as num).toInt(),
      medicamentName: json['medicamentName'] as String,
      medicamentType: json['medicamentType'] as String,
      alarmRoutine: $enumDecode(_$AlarmRoutineEnumMap, json['alarmRoutine']),
      alarmRoutineType:
          $enumDecode(_$AlarmRoutineTypeEnumMap, json['alarmRoutineType']),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      alarmTimes: (json['alarmTimes'] as List<dynamic>)
          .map((e) => DateTime.parse(e as String))
          .toList(),
      alarmWeekDay:
          $enumDecodeNullable(_$AlarmWeekDayEnumMap, json['alarmWeekDay']),
      selectedDayInMonth: (json['selectedDayInMonth'] as num?)?.toInt(),
    )..alarmIdsInLib = (json['alarmIdsInLib'] as List<dynamic>)
        .map((e) => (e as num).toInt())
        .toList();

Map<String, dynamic> _$MedicamentAlarmDataToJson(
        MedicamentAlarmData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'medicamentName': instance.medicamentName,
      'medicamentType': instance.medicamentType,
      'alarmRoutine': _$AlarmRoutineEnumMap[instance.alarmRoutine]!,
      'alarmRoutineType': _$AlarmRoutineTypeEnumMap[instance.alarmRoutineType]!,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'alarmTimes':
          instance.alarmTimes.map((e) => e.toIso8601String()).toList(),
      'alarmWeekDay': _$AlarmWeekDayEnumMap[instance.alarmWeekDay],
      'selectedDayInMonth': instance.selectedDayInMonth,
      'alarmIdsInLib': instance.alarmIdsInLib,
    };

const _$AlarmRoutineEnumMap = {
  AlarmRoutine.daily: 'daily',
  AlarmRoutine.weekly: 'weekly',
  AlarmRoutine.monthly: 'monthly',
};

const _$AlarmRoutineTypeEnumMap = {
  AlarmRoutineType.acute: 'acute',
  AlarmRoutineType.chronic: 'chronic',
};

const _$AlarmWeekDayEnumMap = {
  AlarmWeekDay.monday: 'monday',
  AlarmWeekDay.tuesday: 'tuesday',
  AlarmWeekDay.wednesday: 'wednesday',
  AlarmWeekDay.thursday: 'thursday',
  AlarmWeekDay.friday: 'friday',
  AlarmWeekDay.saturday: 'saturday',
  AlarmWeekDay.sunday: 'sunday',
};

MedicamentAlarm _$MedicamentAlarmFromJson(Map<String, dynamic> json) =>
    MedicamentAlarm(
      id: (json['id'] as num).toInt(),
      medicamentName: json['medicamentName'] as String,
      medicamentType: json['medicamentType'] as String,
      alarmRoutine: $enumDecode(_$AlarmRoutineEnumMap, json['alarmRoutine']),
      alarmRoutineType:
          $enumDecode(_$AlarmRoutineTypeEnumMap, json['alarmRoutineType']),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$MedicamentAlarmToJson(MedicamentAlarm instance) =>
    <String, dynamic>{
      'id': instance.id,
      'medicamentName': instance.medicamentName,
      'medicamentType': instance.medicamentType,
      'alarmRoutine': _$AlarmRoutineEnumMap[instance.alarmRoutine]!,
      'alarmRoutineType': _$AlarmRoutineTypeEnumMap[instance.alarmRoutineType]!,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
    };
