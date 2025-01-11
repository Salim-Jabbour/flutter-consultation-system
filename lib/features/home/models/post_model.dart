import 'dart:convert';

import 'package:akemha/features/consultation/models/doctor.dart';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostsListModel {
  final List<PostModel> posts;
  final bool reachMax;
  final int currentPage;

  const PostsListModel({
    required this.posts,
    required this.currentPage,
    required this.reachMax,
  });
}

class CommentsListModel {
  final List<CommentModel> comments;
  final bool reachMax;
  final int currentPage;

  const CommentsListModel({
    required this.comments,
    required this.currentPage,
    required this.reachMax,
  });
}

const PostModel loadingPost = PostModel(
  description:
  "lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet",
  doctor: Doctor(
    id: 0,
    name: "name",
    email: 'email',
    profileImg:
    "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200",
  ),
  imageUrl:
  "https://media.istockphoto.com/id/1346124900/photo/confident-successful-mature-doctor-at-hospital.jpg?s=612x612&w=0&k=20&c=S93n5iTDVG3_kJ9euNNUKVl9pgXTOdVQcI_oDGG-QlE=",
);
class PostModel {
  const PostModel({
    this.id = 0,
    this.imageUrl = '',
    required this.doctor,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.description = "No Description",
    this.isLiked = false,
  });

  final String imageUrl, description;
  final Doctor doctor;
  final int id, likesCount, commentsCount;
  final bool isLiked;

  PostModel copyWith({
    int? id,
    Doctor? doctor,
    String? imageUrl,
    String? description,
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
  }) =>
      PostModel(
        id: id ?? this.id,
        doctor: doctor ?? this.doctor,
        imageUrl: imageUrl ?? this.imageUrl,
        description: description ?? this.description,
        likesCount: likesCount ?? this.likesCount,
        commentsCount: commentsCount ?? this.commentsCount,
        isLiked: isLiked ?? this.isLiked,
      );

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json["id"],
        doctor: Doctor.fromJson(json["doctor"]),
        imageUrl: json["imageUrl"],
        description: json["description"],
        likesCount: json["likesCount"],
        commentsCount: json["commentsCount"],
        isLiked: json['isLiked'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "doctor": doctor.toJson(),
        "imageUrl": imageUrl,
        "description": description,
        "likesCount": likesCount,
        "commentsCount": commentsCount,
        "isLiked": isLiked,
      };
}

CommentModel commentModelFromJson(String str) =>
    CommentModel.fromJson(json.decode(str));

String commentModelToJson(CommentModel data) => json.encode(data.toJson());
const CommentModel loadingComment = CommentModel(
  id: 0,
  description: "tevkmdsndnnadsfndfonfdond",
  doctor: Doctor(
    id: 0,
    name: "name",
    email: 'email',
    profileImg:
    "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200",
  ),
);
class CommentModel {
  final int id;
  final Doctor doctor;
  final String description;

  const CommentModel({
    required this.id,
    required this.doctor,
    required this.description,
  });

  CommentModel copyWith({
    int? id,
    Doctor? doctor,
    String? description,
  }) =>
      CommentModel(
        id: id ?? this.id,
        doctor: doctor ?? this.doctor,
        description: description ?? this.description,
      );

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json["id"],
        doctor: Doctor.fromJson(json["doctor"]),
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "doctor": doctor.toJson(),
        "description": description,
      };
}
