import 'package:json_annotation/json_annotation.dart';
part 'beneficiary_profile_model.g.dart';

@JsonSerializable()
class BeneficiaryProfileModel {
  final BeneficiaryProfileDetails? data;
  final String? msg;

  BeneficiaryProfileModel({required this.data, required this.msg});

  factory BeneficiaryProfileModel.fromJson(Map<String, dynamic> json) =>
      _$BeneficiaryProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$BeneficiaryProfileModelToJson(this);
}

@JsonSerializable()
class BeneficiaryProfileDetails {
  final String? name;
  final String? profileImage;
  final String? phoneNumber;
  final String? dob;
  final String? gender;

  BeneficiaryProfileDetails({
    required this.name,
    required this.profileImage,
    required this.phoneNumber,
    required this.dob,
    required this.gender,
  });

  factory BeneficiaryProfileDetails.fromJson(Map<String, dynamic> json) =>
      _$BeneficiaryProfileDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$BeneficiaryProfileDetailsToJson(this);
}
