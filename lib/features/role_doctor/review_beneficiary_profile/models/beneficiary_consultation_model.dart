import 'package:json_annotation/json_annotation.dart';

import '../../../consultation/models/specialization.dart';
part 'beneficiary_consultation_model.g.dart';

@JsonSerializable()
class BeneficiaryConsultationModel {
  final List<BeneficiaryConsultationDetails> data;
  final String? msg;

  BeneficiaryConsultationModel({required this.data, required this.msg});

  factory BeneficiaryConsultationModel.fromJson(Map<String, dynamic> json) =>
      _$BeneficiaryConsultationModelFromJson(json);

  Map<String, dynamic> toJson() => _$BeneficiaryConsultationModelToJson(this);
}

@JsonSerializable()
class BeneficiaryConsultationDetails {
  final int? id;
  final String? consultationText;
  final String? consultationAnswer;
  final List<String>? images;
  final Specialization? specialization;
  final User? beneficiary;
  final User? doctor;
  final String? title;
  final bool? isChatOpen;

  BeneficiaryConsultationDetails({
    required this.id,
    required this.consultationText,
    required this.consultationAnswer,
    required this.images,
    required this.specialization,
    required this.beneficiary,
    required this.doctor,
    required this.title,
    required this.isChatOpen,
  });

  factory BeneficiaryConsultationDetails.fromJson(Map<String, dynamic> json) =>
      _$BeneficiaryConsultationDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$BeneficiaryConsultationDetailsToJson(this);
}

@JsonSerializable()
class User {
  final int id;
  final String? name;
  final String? profileImg;
  final String? gender;

  User({
    required this.id,
    required this.name,
    required this.profileImg,
    required this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
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
