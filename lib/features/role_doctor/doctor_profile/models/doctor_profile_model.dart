import 'package:json_annotation/json_annotation.dart';

import '../../../consultation/models/specialization.dart';
part 'doctor_profile_model.g.dart';

@JsonSerializable()
class DoctorProfileModel {
  final DoctorProfileDetailsModel data;
  final String msg;

  DoctorProfileModel({required this.data, required this.msg});

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorProfileModelToJson(this);
}

@JsonSerializable()
class DoctorProfileDetailsModel {
  final int id;
  final String? profileImage;
  final String? name;
  final String? location;
  final String? openingTimes;
  final String? description;
  final Specialization? specialization;

  DoctorProfileDetailsModel({
    required this.id,
    required this.profileImage,
    required this.name,
    required this.location,
    required this.openingTimes,
    required this.description,
    required this.specialization,
  });

  factory DoctorProfileDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorProfileDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorProfileDetailsModelToJson(this);
}

// @JsonSerializable()
// class Specialization {
//   final int id;
//   final String specializationType;

//   Specialization({
//     required this.id,
//     required this.specializationType,
//   });

//   factory Specialization.fromJson(Map<String, dynamic> json) =>
//       _$SpecializationFromJson(json);

//   Map<String, dynamic> toJson() => _$SpecializationToJson(this);
// }
