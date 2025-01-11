// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceLogModel _$DeviceLogModelFromJson(Map<String, dynamic> json) =>
    DeviceLogModel(
      id: (json['id'] as num).toInt(),
      status: json['status'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      expirationTime: json['expirationTime'] == null
          ? null
          : DateTime.parse(json['expirationTime'] as String),
      takeTime: json['takeTime'] == null
          ? null
          : DateTime.parse(json['takeTime'] as String),
      rewindTime: json['rewindTime'] == null
          ? null
          : DateTime.parse(json['rewindTime'] as String),
      medicalDevice:
          DeviceModel.fromJson(json['medicalDevice'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeviceLogModelToJson(DeviceLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'timestamp': instance.timestamp?.toIso8601String(),
      'expirationTime': instance.expirationTime?.toIso8601String(),
      'takeTime': instance.takeTime?.toIso8601String(),
      'rewindTime': instance.rewindTime?.toIso8601String(),
      'medicalDevice': instance.medicalDevice,
    };
