// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
      profileDataModel: json['data'] == null
          ? null
          : ProfileDataModel.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'data': instance.profileDataModel,
      'message': instance.message,
    };

ProfileDataModel _$ProfileDataModelFromJson(Map<String, dynamic> json) =>
    ProfileDataModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      dob: json['dob'] as String?,
      gender: json['gender'] as String,
      profileImage: json['profileImage'] as String?,
    );

Map<String, dynamic> _$ProfileDataModelToJson(ProfileDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'dob': instance.dob,
      'gender': instance.gender,
      'profileImage': instance.profileImage,
    };
