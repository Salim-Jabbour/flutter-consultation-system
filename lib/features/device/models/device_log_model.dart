import 'package:akemha/features/consultation/models/beneficiary.dart';
import 'package:akemha/features/device/models/device_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_log_model.g.dart';

@JsonSerializable()
class DeviceLogModel {
  final int id;

  // final Beneficiary? user;
  final String? status;
  final DateTime? timestamp;
  final DateTime? expirationTime;
  final DateTime? takeTime;
  final DateTime? rewindTime;
  final DeviceModel medicalDevice;

  const DeviceLogModel({
    required this.id,
    this.status,
    this.timestamp,
    this.expirationTime,
    this.takeTime,
    this.rewindTime,
    required this.medicalDevice,
  });

  factory DeviceLogModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceLogModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceLogModelToJson(this);
}
