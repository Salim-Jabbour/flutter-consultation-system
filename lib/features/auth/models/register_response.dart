import 'dart:convert';

RegisterResponse registerResponseFromJson(String str) => RegisterResponse.fromJson(json.decode(str));

String registerResponseToJson(RegisterResponse data) => json.encode(data.toJson());

class RegisterResponse {
  final int statusCode;
  final String msg;
  final String id;

 const RegisterResponse({
    required this.statusCode,
    required this.msg,
    required this.id,
  });

  RegisterResponse copyWith({
    int? statusCode,
    String? msg,
    String? id,
  }) =>
      RegisterResponse(
        statusCode: statusCode ?? this.statusCode,
        msg: msg ?? this.msg,
        id: id ?? this.id,
      );

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(
    statusCode: json["statusCode"],
    msg: json["msg"],
    id: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "msg": msg,
    "data": id,
  };
}
