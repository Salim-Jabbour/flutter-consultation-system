// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beneficiary_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BeneficiaryProfileModel _$BeneficiaryProfileModelFromJson(
        Map<String, dynamic> json) =>
    BeneficiaryProfileModel(
      data: json['data'] == null
          ? null
          : BeneficiaryProfileDetails.fromJson(
              json['data'] as Map<String, dynamic>),
      msg: json['msg'] as String?,
    );

Map<String, dynamic> _$BeneficiaryProfileModelToJson(
        BeneficiaryProfileModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'msg': instance.msg,
    };

BeneficiaryProfileDetails _$BeneficiaryProfileDetailsFromJson(
        Map<String, dynamic> json) =>
    BeneficiaryProfileDetails(
      name: json['name'] as String?,
      profileImage: json['profileImage'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      dob: json['dob'] as String?,
      gender: json['gender'] as String?,
    );

Map<String, dynamic> _$BeneficiaryProfileDetailsToJson(
        BeneficiaryProfileDetails instance) =>
    <String, dynamic>{
      'name': instance.name,
      'profileImage': instance.profileImage,
      'phoneNumber': instance.phoneNumber,
      'dob': instance.dob,
      'gender': instance.gender,
    };
