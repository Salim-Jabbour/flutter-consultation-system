import 'package:json_annotation/json_annotation.dart';

part 'message_consultation_model.g.dart';

@JsonSerializable()
class MessageConsultationModel {
  final int statusCode;
  final String msg;
  final List<DataItem> data;

  MessageConsultationModel({
    required this.statusCode,
    required this.msg,
    required this.data,
  });

  factory MessageConsultationModel.fromJson(Map<String, dynamic> json) {
    return _$MessageConsultationModelFromJson(json);
  }
  Map<String, dynamic> toJson() => _$MessageConsultationModelToJson(this);
}

@JsonSerializable()
class DataItem {
  final int id;
  final String textMessage;
  final UserLessResponse userLessResponse;

  DataItem({
    required this.id,
    required this.textMessage,
    required this.userLessResponse,
  });

  factory DataItem.fromJson(Map<String, dynamic> json) {
    return _$DataItemFromJson(json);
  }
  Map<String, dynamic> toJson() => _$DataItemToJson(this);
}

@JsonSerializable()
class UserLessResponse {
  final int id;
  final String name;
  final String email;
  final String? profileImg;

  UserLessResponse({
    required this.id,
    required this.name,
    required this.email,
    this.profileImg,
  });

  factory UserLessResponse.fromJson(Map<String, dynamic> json) {
    return _$UserLessResponseFromJson(json);
  }
  Map<String, dynamic> toJson() => _$UserLessResponseToJson(this);
}



// class MessageConsultationModel {
//   final int statusCode;
//   final String msg;
//   final List<DataItem> data;

//   MessageConsultationModel({
//     required this.statusCode,
//     required this.msg,
//     required this.data,
//   });

//   factory MessageConsultationModel.fromJson(Map<String, dynamic> json) {
//     List<dynamic> jsonData = json['data'];
//     List<DataItem> data =
//         jsonData.map((item) => DataItem.fromJson(item)).toList();

//     return MessageConsultationModel(
//       statusCode: json['statusCode'],
//       msg: json['msg'],
//       data: data,
//     );
//   }
// }

// class DataItem {
//   final int id;
//   final String textMessage;
//   final UserLessResponse userLessResponse;

//   DataItem({
//     required this.id,
//     required this.textMessage,
//     required this.userLessResponse,
//   });

//   factory DataItem.fromJson(Map<String, dynamic> json) {
//     return DataItem(
//       id: json['id'],
//       textMessage: json['textMessage'],
//       userLessResponse: UserLessResponse.fromJson(json['userLessResponse']),
//     );
//   }
// }

// class UserLessResponse {
//   final int id;
//   final String name;
//   final String email;
//   final String? profileImg;

//   UserLessResponse({
//     required this.id,
//     required this.name,
//     required this.email,
//     this.profileImg,
//   });

//   factory UserLessResponse.fromJson(Map<String, dynamic> json) {
//     return UserLessResponse(
//       id: json['id'],
//       name: json['name'],
//       email: json['email'],
//       profileImg: json['profileImg'],
//     );
//   }
// }
