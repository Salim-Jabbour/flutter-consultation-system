// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceModel _$DeviceModelFromJson(Map<String, dynamic> json) => DeviceModel(
      id: (json['id'] as num).toInt(),
      count: (json['count'] as num).toInt(),
      reservedCount: (json['reservedCount'] as num).toInt(),
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      imagePublicId: json['imagePublicId'] as String,
    );

Map<String, dynamic> _$DeviceModelToJson(DeviceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'count': instance.count,
      'reservedCount': instance.reservedCount,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'imagePublicId': instance.imagePublicId,
    };
