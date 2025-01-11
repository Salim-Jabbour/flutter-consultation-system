// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_consultation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageConsultationModel _$MessageConsultationModelFromJson(
        Map<String, dynamic> json) =>
    MessageConsultationModel(
      statusCode: (json['statusCode'] as num).toInt(),
      msg: json['msg'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => DataItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MessageConsultationModelToJson(
        MessageConsultationModel instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'msg': instance.msg,
      'data': instance.data,
    };

DataItem _$DataItemFromJson(Map<String, dynamic> json) => DataItem(
      id: (json['id'] as num).toInt(),
      textMessage: json['textMessage'] as String,
      userLessResponse: UserLessResponse.fromJson(
          json['userLessResponse'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataItemToJson(DataItem instance) => <String, dynamic>{
      'id': instance.id,
      'textMessage': instance.textMessage,
      'userLessResponse': instance.userLessResponse,
    };

UserLessResponse _$UserLessResponseFromJson(Map<String, dynamic> json) =>
    UserLessResponse(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      profileImg: json['profileImg'] as String?,
    );

Map<String, dynamic> _$UserLessResponseToJson(UserLessResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'profileImg': instance.profileImg,
    };
