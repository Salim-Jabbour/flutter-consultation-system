import 'dart:convert';

ActivitiesModel activitiesModelFromJson(String str) => ActivitiesModel.fromJson(json.decode(str));

String activitiesModelToJson(ActivitiesModel data) => json.encode(data.toJson());

class ActivitiesModel {
  final int statusCode;
  final String msg;
  final List<ActivityModel> activities;

  ActivitiesModel({
    required this.statusCode,
    required this.msg,
    required this.activities,
  });

  ActivitiesModel copyWith({
    int? statusCode,
    String? msg,
    List<ActivityModel>? activities,
  }) =>
      ActivitiesModel(
        statusCode: statusCode ?? this.statusCode,
        msg: msg ?? this.msg,
        activities: activities ?? this.activities,
      );

  factory ActivitiesModel.fromJson(Map<String, dynamic> json) => ActivitiesModel(
    statusCode: json["statusCode"],
    msg: json["msg"],
    activities: List<ActivityModel>.from((json["data"]["content"]??[]).map((x) => ActivityModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "msg": msg,
    "data": List<dynamic>.from(activities.map((x) => x.toJson())),
  };
}

class ActivityModel {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;

  ActivityModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  ActivityModel copyWith({
    int? id,
    String? title,
    String? description,
    String? imageUrl,
  }) =>
      ActivityModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    imageUrl: json["imageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "imageUrl": imageUrl,
  };
}
