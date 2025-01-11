import 'package:json_annotation/json_annotation.dart';
part 'medical_record_model.g.dart';

enum BloodType {
  @JsonValue('A_POSITIVE')
  aPositive,
  @JsonValue('A_NEGATIVE')
  aNegative,
  @JsonValue('B_POSITIVE')
  bPositive,
  @JsonValue('B_NEGATIVE')
  bNegative,
  @JsonValue('AB_POSITIVE')
  abPositive,
  @JsonValue('AB_NEGATIVE')
  abNegative,
  @JsonValue('O_POSITIVE')
  oPositive,
  @JsonValue('O_NEGATIVE')
  oNegative
}

enum AdditionalInfoType {
  @JsonValue('PREVIOUS_SURGERIES')
  previousSurgeries,
  @JsonValue('PREVIOUS_ILLNESSES')
  previousIllness,
  @JsonValue('FAMILY_HISTORY_OF_ILLNESSES')
  familyHistoryOfIllnesses,
  @JsonValue('ALLERGIES')
  allergies,
}

@JsonSerializable()
class MedicalRecordPostModel {
  final String? data;
  final String? msg;
  MedicalRecordPostModel({required this.data, required this.msg});

  factory MedicalRecordPostModel.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalRecordPostModelToJson(this);
}

@JsonSerializable()
class MedicalRecordModel {
  final MedicalRecordModelData? data;
  final String? msg;
  MedicalRecordModel({required this.data, required this.msg});

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalRecordModelToJson(this);
}

@JsonSerializable()
class MedicalRecordModelData {
  final int id;
  final bool coffee;
  final bool alcohol;
  final bool married;
  final bool smoker;
  final bool covidVaccine;
  final double height;
  final double weight;
  final BloodType bloodType;
  final List<AdditionalRecordInfoResponse> previousSurgeries;
  final List<AdditionalRecordInfoResponse> previousIllnesses;
  final List<AdditionalRecordInfoResponse> allergies;
  final List<AdditionalRecordInfoResponse> familyHistoryOfIllnesses;

  MedicalRecordModelData({
    required this.id,
    required this.coffee,
    required this.alcohol,
    required this.married,
    required this.smoker,
    required this.covidVaccine,
    required this.height,
    required this.weight,
    required this.bloodType,
    required this.previousSurgeries,
    required this.previousIllnesses,
    required this.allergies,
    required this.familyHistoryOfIllnesses,
  });
  factory MedicalRecordModelData.fromJson(Map<String, dynamic> json) =>
      _$MedicalRecordModelDataFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalRecordModelDataToJson(this);
}

@JsonSerializable()
class AdditionalRecordInfoResponse {
  final int id;
  final String name;
  final String description;
  final AdditionalInfoType type;

  AdditionalRecordInfoResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
  });

  factory AdditionalRecordInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$AdditionalRecordInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AdditionalRecordInfoResponseToJson(this);
}
