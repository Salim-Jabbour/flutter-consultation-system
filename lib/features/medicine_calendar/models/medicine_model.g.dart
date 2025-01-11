// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicineModel _$MedicineModelFromJson(Map<String, dynamic> json) =>
    MedicineModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => MedicineModelData.fromJson(e as Map<String, dynamic>))
          .toList(),
      msg: json['msg'] as String?,
    );

Map<String, dynamic> _$MedicineModelToJson(MedicineModel instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'data': instance.data,
    };

MedicineModelData _$MedicineModelDataFromJson(Map<String, dynamic> json) =>
    MedicineModelData(
      id: (json['id'] as num).toInt(),
      localId: (json['localId'] as num).toInt(),
      name: json['name'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      alarmTimes: (json['alarmTimes'] as List<dynamic>)
          .map((e) => AlarmTimes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MedicineModelDataToJson(MedicineModelData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'localId': instance.localId,
      'name': instance.name,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'alarmTimes': instance.alarmTimes,
    };

AlarmTimes _$AlarmTimesFromJson(Map<String, dynamic> json) => AlarmTimes(
      time: json['time'] as String,
      taken: json['taken'] as bool,
    );

Map<String, dynamic> _$AlarmTimesToJson(AlarmTimes instance) =>
    <String, dynamic>{
      'time': instance.time,
      'taken': instance.taken,
    };
