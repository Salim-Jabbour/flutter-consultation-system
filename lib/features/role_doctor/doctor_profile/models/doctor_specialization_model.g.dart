// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_specialization_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorSpecializationModel _$DoctorSpecializationModelFromJson(
        Map<String, dynamic> json) =>
    DoctorSpecializationModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => Specialization.fromJson(e as Map<String, dynamic>?))
          .toList(),
      msg: json['msg'] as String,
    );

Map<String, dynamic> _$DoctorSpecializationModelToJson(
        DoctorSpecializationModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'msg': instance.msg,
    };
