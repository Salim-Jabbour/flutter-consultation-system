class Beneficiary {
  final int id;
  final String name;
  final String? profileImg;
  final String? gender;

  const Beneficiary({
    required this.id,
    required this.name,
    required this.profileImg,
    required this.gender,
  });

  Beneficiary copyWith({
    int? id,
    String? name,
    String? profileImg,
    String? gender,
  }) =>
      Beneficiary(
        id: id ?? this.id,
        name: name ?? this.name,
        profileImg: profileImg ?? this.profileImg,
        gender: gender ?? this.gender,
      );

  factory Beneficiary.fromJson(Map<String, dynamic> json) => Beneficiary(
        id: json["id"],
        name: json["name"],
        profileImg: json["profileImg"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "profileImg": profileImg,
        "gender": gender,
      };
}
