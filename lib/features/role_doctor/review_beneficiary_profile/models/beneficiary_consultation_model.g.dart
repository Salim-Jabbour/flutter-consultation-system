// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beneficiary_consultation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BeneficiaryConsultationModel _$BeneficiaryConsultationModelFromJson(
        Map<String, dynamic> json) =>
    BeneficiaryConsultationModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => BeneficiaryConsultationDetails.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      msg: json['msg'] as String?,
    );

Map<String, dynamic> _$BeneficiaryConsultationModelToJson(
        BeneficiaryConsultationModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'msg': instance.msg,
    };

BeneficiaryConsultationDetails _$BeneficiaryConsultationDetailsFromJson(
        Map<String, dynamic> json) =>
    BeneficiaryConsultationDetails(
      id: (json['id'] as num?)?.toInt(),
      consultationText: json['consultationText'] as String?,
      consultationAnswer: json['consultationAnswer'] as String?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      specialization: json['specialization'] == null
          ? null
          : Specialization.fromJson(
              json['specialization'] as Map<String, dynamic>?),
      beneficiary: json['beneficiary'] == null
          ? null
          : User.fromJson(json['beneficiary'] as Map<String, dynamic>),
      doctor: json['doctor'] == null
          ? null
          : User.fromJson(json['doctor'] as Map<String, dynamic>),
      title: json['title'] as String?,
      isChatOpen: json['isChatOpen'] as bool?,
    );

Map<String, dynamic> _$BeneficiaryConsultationDetailsToJson(
        BeneficiaryConsultationDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'consultationText': instance.consultationText,
      'consultationAnswer': instance.consultationAnswer,
      'images': instance.images,
      'specialization': instance.specialization,
      'beneficiary': instance.beneficiary,
      'doctor': instance.doctor,
      'title': instance.title,
      'isChatOpen': instance.isChatOpen,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      profileImg: json['profileImg'] as String?,
      gender: json['gender'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profileImg': instance.profileImg,
      'gender': instance.gender,
    };
