import 'package:json_annotation/json_annotation.dart';

part 'supervision_model.g.dart';

@JsonSerializable()
class SupervisionModel {
  final String? msg;
  @JsonKey(name: 'data')
  final List<SupervisionDataModel>? supervisonDataModel;

  SupervisionModel({
    required this.supervisonDataModel,
    required this.msg,
  });
  factory SupervisionModel.fromJson(Map<String, dynamic> json) =>
      _$SupervisionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupervisionModelToJson(this);
}

@JsonSerializable()
class SupervisionDataModel {
  final int id;
  final UserLessResponseModel supervisor;
  final UserLessResponseModel supervised;

  SupervisionDataModel({
    required this.id,
    required this.supervisor,
    required this.supervised,
  });
  factory SupervisionDataModel.fromJson(Map<String, dynamic> json) =>
      _$SupervisionDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupervisionDataModelToJson(this);
}



@JsonSerializable()
class SupervisionUserModel {
  final String? msg;
  @JsonKey(name: 'data')
  final List<UserLessResponseModel>? usersList;

  SupervisionUserModel({
    required this.msg,
    required this.usersList,
  });
  factory SupervisionUserModel.fromJson(Map<String, dynamic> json) =>
      _$SupervisionUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupervisionUserModelToJson(this);
}

@JsonSerializable()
class UserLessResponseModel {
  final int id;
  final String name;
  final String email;
  final String? profileImg;

  UserLessResponseModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImg,
  });

  factory UserLessResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserLessResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserLessResponseModelToJson(this);
}
