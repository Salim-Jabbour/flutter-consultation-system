// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalRecordPostModel _$MedicalRecordPostModelFromJson(
        Map<String, dynamic> json) =>
    MedicalRecordPostModel(
      data: json['data'] as String?,
      msg: json['msg'] as String?,
    );

Map<String, dynamic> _$MedicalRecordPostModelToJson(
        MedicalRecordPostModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'msg': instance.msg,
    };

MedicalRecordModel _$MedicalRecordModelFromJson(Map<String, dynamic> json) =>
    MedicalRecordModel(
      data: json['data'] == null
          ? null
          : MedicalRecordModelData.fromJson(
              json['data'] as Map<String, dynamic>),
      msg: json['msg'] as String?,
    );

Map<String, dynamic> _$MedicalRecordModelToJson(MedicalRecordModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'msg': instance.msg,
    };

MedicalRecordModelData _$MedicalRecordModelDataFromJson(
        Map<String, dynamic> json) =>
    MedicalRecordModelData(
      id: (json['id'] as num).toInt(),
      coffee: json['coffee'] as bool,
      alcohol: json['alcohol'] as bool,
      married: json['married'] as bool,
      smoker: json['smoker'] as bool,
      covidVaccine: json['covidVaccine'] as bool,
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      bloodType: $enumDecode(_$BloodTypeEnumMap, json['bloodType']),
      previousSurgeries: (json['previousSurgeries'] as List<dynamic>)
          .map((e) =>
              AdditionalRecordInfoResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      previousIllnesses: (json['previousIllnesses'] as List<dynamic>)
          .map((e) =>
              AdditionalRecordInfoResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      allergies: (json['allergies'] as List<dynamic>)
          .map((e) =>
              AdditionalRecordInfoResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      familyHistoryOfIllnesses: (json['familyHistoryOfIllnesses']
              as List<dynamic>)
          .map((e) =>
              AdditionalRecordInfoResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MedicalRecordModelDataToJson(
        MedicalRecordModelData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'coffee': instance.coffee,
      'alcohol': instance.alcohol,
      'married': instance.married,
      'smoker': instance.smoker,
      'covidVaccine': instance.covidVaccine,
      'height': instance.height,
      'weight': instance.weight,
      'bloodType': _$BloodTypeEnumMap[instance.bloodType]!,
      'previousSurgeries': instance.previousSurgeries,
      'previousIllnesses': instance.previousIllnesses,
      'allergies': instance.allergies,
      'familyHistoryOfIllnesses': instance.familyHistoryOfIllnesses,
    };

const _$BloodTypeEnumMap = {
  BloodType.aPositive: 'A_POSITIVE',
  BloodType.aNegative: 'A_NEGATIVE',
  BloodType.bPositive: 'B_POSITIVE',
  BloodType.bNegative: 'B_NEGATIVE',
  BloodType.abPositive: 'AB_POSITIVE',
  BloodType.abNegative: 'AB_NEGATIVE',
  BloodType.oPositive: 'O_POSITIVE',
  BloodType.oNegative: 'O_NEGATIVE',
};

AdditionalRecordInfoResponse _$AdditionalRecordInfoResponseFromJson(
        Map<String, dynamic> json) =>
    AdditionalRecordInfoResponse(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$AdditionalInfoTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$AdditionalRecordInfoResponseToJson(
        AdditionalRecordInfoResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$AdditionalInfoTypeEnumMap[instance.type]!,
    };

const _$AdditionalInfoTypeEnumMap = {
  AdditionalInfoType.previousSurgeries: 'PREVIOUS_SURGERIES',
  AdditionalInfoType.previousIllness: 'PREVIOUS_ILLNESSES',
  AdditionalInfoType.familyHistoryOfIllnesses: 'FAMILY_HISTORY_OF_ILLNESSES',
  AdditionalInfoType.allergies: 'ALLERGIES',
};
