import 'package:json_annotation/json_annotation.dart';

import '../../consultation/models/specialization.dart';

part 'doctor_model.g.dart';

const DoctorDataModel loadingDoctor = DoctorDataModel(
  id: 0,
  name: "hello world",
  email: "",
  phoneNumber: "",
  description: "",
  location: "",
  openingTimes: "",
  profileImage:
  "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200",
  specialization: null,
  answeredConsultation: null,
);

@JsonSerializable()
class DoctorModel {
  @JsonKey(name: 'data')
  final List<DoctorDataModel>? doctorDataModel;
  final String? message;

  DoctorModel({required this.doctorDataModel, required this.message});

  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorModelToJson(this);
}


@JsonSerializable()
class DoctorDataModel {
  final int id;
  final String? name;
  final String? email;
  final String? profileImage;
  final String? phoneNumber;
  final String? description;
  final String? location;
  final String? openingTimes;
  final int? answeredConsultation;
  final Specialization? specialization;

  const DoctorDataModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profileImage,
    required this.description,
    required this.location,
    required this.openingTimes,
    required this.answeredConsultation,
    required this.specialization,
  });

  factory DoctorDataModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorDataModelToJson(this);
}

// @JsonSerializable()
// class Specialization {
//   final int id;
//   final String? specializationType;

//   const Specialization({
//     required this.id,
//     required this.specializationType,
//   });

//   factory Specialization.fromJson(Map<String, dynamic> json) =>
//       _$SpecializationFromJson(json);

//   Map<String, dynamic> toJson() => _$SpecializationToJson(this);
// }
