// import 'dart:convert';
//
// import 'package:akemha/features/consultation/models/specialization.dart';
//
// NewDoctorModel newDoctorModelFromJson(String str) =>
//     NewDoctorModel.fromJson(json.decode(str));
//
// String newDoctorModelToJson(NewDoctorModel data) => json.encode(data.toJson());
//
// class NewDoctorModel {
//   final int id;
//   final String name;
//   final String email;
//   final String? profileImage;
//   final String phoneNumber;
//   final String? description;
//   final String? location;
//   final String? openingTimes;
//   final Specialization? specialization;
//   final String password;
//   final DateTime? creationDate;
//   final DateTime? dob;
//   final bool isActive;
//   final String gender;
//   final bool isVerified;
//   final String deviceToken;
//   final String role;
//   final bool enabled;
//   final String username;
//   final List<Authority> authorities;
//   final bool accountNonExpired;
//   final bool credentialsNonExpired;
//   final bool accountNonLocked;
//
//   const NewDoctorModel({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.phoneNumber,
//     required this.password,
//     this.creationDate,
//     this.dob,
//     this.profileImage,
//     required this.isActive,
//     this.description,
//     required this.gender,
//     this.location,
//     this.openingTimes,
//     required this.isVerified,
//     required this.deviceToken,
//     this.specialization,
//     required this.role,
//     required this.enabled,
//     required this.username,
//     required this.authorities,
//     required this.accountNonExpired,
//     required this.credentialsNonExpired,
//     required this.accountNonLocked,
//   });
//
//   NewDoctorModel copyWith({
//     int? id,
//     String? name,
//     String? email,
//     String? phoneNumber,
//     String? password,
//     DateTime? creationDate,
//     DateTime? dob,
//     String? profileImage,
//     bool? isActive,
//     String? description,
//     String? gender,
//     String? location,
//     String? openingTimes,
//     bool? isVerified,
//     String? deviceToken,
//     Specialization? specialization,
//     String? role,
//     bool? enabled,
//     String? username,
//     List<Authority>? authorities,
//     bool? accountNonExpired,
//     bool? credentialsNonExpired,
//     bool? accountNonLocked,
//   }) =>
//       NewDoctorModel(
//         id: id ?? this.id,
//         name: name ?? this.name,
//         email: email ?? this.email,
//         phoneNumber: phoneNumber ?? this.phoneNumber,
//         password: password ?? this.password,
//         creationDate: creationDate ?? this.creationDate,
//         dob: dob ?? this.dob,
//         profileImage: profileImage ?? this.profileImage,
//         isActive: isActive ?? this.isActive,
//         description: description ?? this.description,
//         gender: gender ?? this.gender,
//         location: location ?? this.location,
//         openingTimes: openingTimes ?? this.openingTimes,
//         isVerified: isVerified ?? this.isVerified,
//         deviceToken: deviceToken ?? this.deviceToken,
//         specialization: specialization ?? this.specialization,
//         role: role ?? this.role,
//         enabled: enabled ?? this.enabled,
//         username: username ?? this.username,
//         authorities: authorities ?? this.authorities,
//         accountNonExpired: accountNonExpired ?? this.accountNonExpired,
//         credentialsNonExpired:
//             credentialsNonExpired ?? this.credentialsNonExpired,
//         accountNonLocked: accountNonLocked ?? this.accountNonLocked,
//       );
//
//   factory NewDoctorModel.fromJson(Map<String, dynamic> json) => NewDoctorModel(
//         id: json["id"],
//         name: json["name"],
//         email: json["email"],
//         phoneNumber: json["phoneNumber"],
//         password: json["password"],
//         creationDate: DateTime.tryParse(json["creationDate"] ?? ""),
//         dob: DateTime.parse(json["dob"]),
//         profileImage: json["profileImage"],
//         isActive: json["isActive"],
//         description: json["description"],
//         gender: json["gender"],
//         location: json["location"],
//         openingTimes: json["openingTimes"],
//         isVerified: json["isVerified"],
//         deviceToken: json["deviceToken"],
//         specialization: Specialization.fromJson(json["specialization"]),
//         role: json["role"],
//         enabled: json["enabled"],
//         username: json["username"],
//         authorities: List<Authority>.from(
//             json["authorities"].map((x) => Authority.fromJson(x))),
//         accountNonExpired: json["accountNonExpired"],
//         credentialsNonExpired: json["credentialsNonExpired"],
//         accountNonLocked: json["accountNonLocked"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "email": email,
//         "phoneNumber": phoneNumber,
//         "password": password,
//         "creationDate":
//             "${creationDate?.year.toString().padLeft(4, '0')}-${creationDate?.month.toString().padLeft(2, '0')}-${creationDate?.day.toString().padLeft(2, '0')}",
//         "dob":
//             "${dob?.year.toString().padLeft(4, '0')}-${dob?.month.toString().padLeft(2, '0')}-${dob?.day.toString().padLeft(2, '0')}",
//         "profileImage": profileImage,
//         "isActive": isActive,
//         "description": description,
//         "gender": gender,
//         "location": location,
//         "openingTimes": openingTimes,
//         "isVerified": isVerified,
//         "deviceToken": deviceToken,
//         "specialization": specialization,
//         "role": role,
//         "enabled": enabled,
//         "username": username,
//         "authorities": List<dynamic>.from(authorities.map((x) => x.toJson())),
//         "accountNonExpired": accountNonExpired,
//         "credentialsNonExpired": credentialsNonExpired,
//         "accountNonLocked": accountNonLocked,
//       };
// }
//
// class Authority {
//   final String authority;
//
//   Authority({
//     required this.authority,
//   });
//
//   Authority copyWith({
//     String? authority,
//   }) =>
//       Authority(
//         authority: authority ?? this.authority,
//       );
//
//   factory Authority.fromJson(Map<String, dynamic> json) => Authority(
//         authority: json["authority"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "authority": authority,
//       };
// }
