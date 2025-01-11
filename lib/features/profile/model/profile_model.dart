import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  @JsonKey(name: 'data')
  final ProfileDataModel? profileDataModel;
  final String? message;
  ProfileModel({required this.profileDataModel, required this.message});

  /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}

@JsonSerializable()
class ProfileDataModel {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? dob;
  final String gender;
  final String? profileImage;

  ProfileDataModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.dob,
    required this.gender,
    required this.profileImage,
  });

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDataModelToJson(this);
}
