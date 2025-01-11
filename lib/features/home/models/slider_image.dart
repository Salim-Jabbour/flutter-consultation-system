import 'dart:convert';

import '../../../core/resource/asset_manager.dart';

SliderImage sliderImageFromJson(String str) =>
    SliderImage.fromJson(json.decode(str));

String sliderImageToJson(SliderImage data) => json.encode(data.toJson());

class SliderImage {
  final int id;
  final String pageLink;
  final String imageUrl;

  const SliderImage({
    required this.id,
    required this.pageLink,
    required this.imageUrl,
  });

  SliderImage copyWith({
    int? id,
    String? pageLink,
    String? imageUrl,
  }) =>
      SliderImage(
        id: id ?? this.id,
        pageLink: pageLink ?? this.pageLink,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  factory SliderImage.fromJson(Map<String, dynamic> json) => SliderImage(
        id: json["id"],
        pageLink: json["pageLink"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pageLink": pageLink,
        "imageUrl": imageUrl,
      };
}

const SliderImage loadingSliderImage =  SliderImage(
  id: 0,
  pageLink: "pageLink",
  imageUrl: AssetImageManager.activity1,
);
