// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorProfileModel _$DoctorProfileModelFromJson(Map<String, dynamic> json) =>
    DoctorProfileModel(
      data: DoctorProfileDetailsModel.fromJson(
          json['data'] as Map<String, dynamic>),
      msg: json['msg'] as String,
    );

Map<String, dynamic> _$DoctorProfileModelToJson(DoctorProfileModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'msg': instance.msg,
    };

DoctorProfileDetailsModel _$DoctorProfileDetailsModelFromJson(
        Map<String, dynamic> json) =>
    DoctorProfileDetailsModel(
      id: (json['id'] as num).toInt(),
      profileImage: json['profileImage'] as String?,
      name: json['name'] as String?,
      location: json['location'] as String?,
      openingTimes: json['openingTimes'] as String?,
      description: json['description'] as String?,
      specialization: json['specialization'] == null
          ? null
          : Specialization.fromJson(
              json['specialization'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$DoctorProfileDetailsModelToJson(
        DoctorProfileDetailsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profileImage': instance.profileImage,
      'name': instance.name,
      'location': instance.location,
      'openingTimes': instance.openingTimes,
      'description': instance.description,
      'specialization': instance.specialization,
    };
