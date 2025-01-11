// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalInfoModel _$PersonalInfoModelFromJson(Map<String, dynamic> json) =>
    PersonalInfoModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      dob: json['dob'] == null ? null : DateTime.parse(json['dob'] as String),
      profileImage: json['profileImage'] as String?,
      gender: json['gender'] as String?,
    );

Map<String, dynamic> _$PersonalInfoModelToJson(PersonalInfoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'dob': instance.dob?.toIso8601String(),
      'profileImage': instance.profileImage,
      'gender': instance.gender,
    };
