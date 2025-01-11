class Doctor {
  final int id;
  final String name;
  final String? email;
  final String? profileImg;
  final String? gender;

  const Doctor({
    required this.id,
    required this.name,
    required this.email,
    this.profileImg,
    this.gender,
  });

  Doctor copyWith({
    int? id,
    String? name,
    String? email,
    String? profileImg,
    String? gender,
  }) =>
      Doctor(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        profileImg: profileImg ?? this.profileImg,
        gender: gender ?? this.gender,
      );

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        profileImg: json["profileImg"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "profileImg": profileImg,
        "gender": gender,
      };
}
