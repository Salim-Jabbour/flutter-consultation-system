class Specialization {
  final int id;
  final String image;
  final String name;

 const Specialization({
    required this.id,
    required this.name,
    required this.image,
  });

  Specialization copyWith({
    int? id,
    String? name,
    String? image,
    bool? isPublic,
  }) =>
      Specialization(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
      );

  factory Specialization.fromJson(Map<String, dynamic>? json) => Specialization(
        id: json?["id"] ?? 0,
        name: json?["specializationType"] ?? "no type",
        image: json?["imageUrl"] ??
            'https://static.vecteezy.com/system/resources/thumbnails/027/855/841/small_2x/human-heart-ai-generative-png.png',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "specializationType": name,
      };
}
