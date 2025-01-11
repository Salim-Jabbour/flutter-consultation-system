import 'package:json_annotation/json_annotation.dart';

part 'personal_info_model.g.dart';

@JsonSerializable()
class PersonalInfoModel {
  final int? id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final DateTime? dob;
  final String? profileImage;
  final String? gender;

  PersonalInfoModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.dob,
    required this.profileImage,
    required this.gender,
  });


  factory PersonalInfoModel.fromJson(Map<String, dynamic> json) =>
      _$PersonalInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalInfoModelToJson(this);
}
