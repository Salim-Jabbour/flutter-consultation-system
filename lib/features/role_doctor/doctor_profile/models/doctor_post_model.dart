import 'package:json_annotation/json_annotation.dart';
part 'doctor_post_model.g.dart';

@JsonSerializable()
class DoctorPostModel {
  final List<DoctorPostDetailsModel> data;
  final String msg;

  DoctorPostModel({required this.data, required this.msg});

  factory DoctorPostModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorPostModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorPostModelToJson(this);
}

@JsonSerializable()
class DoctorPostDetailsModel {
  final int id;
  final User? doctor;
  final String? imageUrl;
  final String? description;
  final int? likesCount;
  final int? commentsCount;

  DoctorPostDetailsModel({
    required this.id,
    required this.doctor,
    required this.imageUrl,
    required this.description,
    required this.likesCount,
    required this.commentsCount,
  });

  factory DoctorPostDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorPostDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorPostDetailsModelToJson(this);
}

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String? profileImage;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
