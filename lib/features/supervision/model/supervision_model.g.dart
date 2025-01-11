// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supervision_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupervisionModel _$SupervisionModelFromJson(Map<String, dynamic> json) =>
    SupervisionModel(
      supervisonDataModel: (json['data'] as List<dynamic>?)
          ?.map((e) => SupervisionDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      msg: json['msg'] as String?,
    );

Map<String, dynamic> _$SupervisionModelToJson(SupervisionModel instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'data': instance.supervisonDataModel,
    };

SupervisionDataModel _$SupervisionDataModelFromJson(
        Map<String, dynamic> json) =>
    SupervisionDataModel(
      id: (json['id'] as num).toInt(),
      supervisor: UserLessResponseModel.fromJson(
          json['supervisor'] as Map<String, dynamic>),
      supervised: UserLessResponseModel.fromJson(
          json['supervised'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SupervisionDataModelToJson(
        SupervisionDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'supervisor': instance.supervisor,
      'supervised': instance.supervised,
    };

SupervisionUserModel _$SupervisionUserModelFromJson(
        Map<String, dynamic> json) =>
    SupervisionUserModel(
      msg: json['msg'] as String?,
      usersList: (json['data'] as List<dynamic>?)
          ?.map(
              (e) => UserLessResponseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SupervisionUserModelToJson(
        SupervisionUserModel instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'data': instance.usersList,
    };

UserLessResponseModel _$UserLessResponseModelFromJson(
        Map<String, dynamic> json) =>
    UserLessResponseModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      profileImg: json['profileImg'] as String?,
    );

Map<String, dynamic> _$UserLessResponseModelToJson(
        UserLessResponseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'profileImg': instance.profileImg,
    };
