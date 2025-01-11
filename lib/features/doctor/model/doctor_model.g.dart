// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) => DoctorModel(
      doctorDataModel: (json['data'] as List<dynamic>?)
          ?.map((e) => DoctorDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$DoctorModelToJson(DoctorModel instance) =>
    <String, dynamic>{
      'data': instance.doctorDataModel,
      'message': instance.message,
    };

DoctorDataModel _$DoctorDataModelFromJson(Map<String, dynamic> json) =>
    DoctorDataModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      profileImage: json['profileImage'] as String?,
      description: json['description'] as String?,
      location: json['location'] as String?,
      openingTimes: json['openingTimes'] as String?,
      answeredConsultation: (json['answeredConsultation'] as num?)?.toInt(),
      specialization: json['specialization'] == null
          ? null
          : Specialization.fromJson(
              json['specialization'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$DoctorDataModelToJson(DoctorDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'profileImage': instance.profileImage,
      'phoneNumber': instance.phoneNumber,
      'description': instance.description,
      'location': instance.location,
      'openingTimes': instance.openingTimes,
      'answeredConsultation': instance.answeredConsultation,
      'specialization': instance.specialization,
    };
