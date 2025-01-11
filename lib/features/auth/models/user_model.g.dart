// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      data: UserData.fromJson(json['data'] as Map<String, dynamic>),
      msg: json['msg'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'msg': instance.msg,
      'data': instance.data,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      token: json['token'] as String,
      id: (json['id'] as num).toInt(),
      userEmail: json['userEmail'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'token': instance.token,
      'userEmail': instance.userEmail,
      'role': instance.role,
    };
