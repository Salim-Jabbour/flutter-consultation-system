import 'package:json_annotation/json_annotation.dart';

part 'device_model.g.dart';

const DeviceModel loadingDevice = DeviceModel(
  id: 0,
  reservedCount: 0,
  imagePublicId: "",
  imageUrl: "https://medlineplus.gov/images/MedicalDeviceSafety_share.jpg",
  name: "device 3",
  count: 7,
);

@JsonSerializable()
class DeviceModel {
  final int id;
  final int count;
  final int reservedCount;
  final String name;
  final String imageUrl;
  final String imagePublicId;

  const DeviceModel({
    required this.id,
    required this.count,
    required this.reservedCount,
    required this.name,
    required this.imageUrl,
    required this.imagePublicId,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceModelToJson(this);
}
