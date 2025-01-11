// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorPostModel _$DoctorPostModelFromJson(Map<String, dynamic> json) =>
    DoctorPostModel(
      data: (json['data'] as List<dynamic>)
          .map(
              (e) => DoctorPostDetailsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      msg: json['msg'] as String,
    );

Map<String, dynamic> _$DoctorPostModelToJson(DoctorPostModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'msg': instance.msg,
    };

DoctorPostDetailsModel _$DoctorPostDetailsModelFromJson(
        Map<String, dynamic> json) =>
    DoctorPostDetailsModel(
      id: (json['id'] as num).toInt(),
      doctor: json['doctor'] == null
          ? null
          : User.fromJson(json['doctor'] as Map<String, dynamic>),
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String?,
      likesCount: (json['likesCount'] as num?)?.toInt(),
      commentsCount: (json['commentsCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DoctorPostDetailsModelToJson(
        DoctorPostDetailsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'doctor': instance.doctor,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'likesCount': instance.likesCount,
      'commentsCount': instance.commentsCount,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      profileImage: json['profileImage'] as String?,
      email: json['email'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profileImage': instance.profileImage,
      'email': instance.email,
    };
