import 'package:json_annotation/json_annotation.dart';
part 'medicine_model.g.dart';

@JsonSerializable()
class MedicineModel {
  final String? msg;
  final List<MedicineModelData> data;
  MedicineModel({required this.data, required this.msg});

  factory MedicineModel.fromJson(Map<String, dynamic> json) =>
      _$MedicineModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicineModelToJson(this);
}

@JsonSerializable()
class MedicineModelData {
  final int id;
  final int localId;
  final String name;
  final String startDate;
  final String endDate;
  final List<AlarmTimes> alarmTimes;

  MedicineModelData({
    required this.id,
    required this.localId,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.alarmTimes,
  });
  factory MedicineModelData.fromJson(Map<String, dynamic> json) =>
      _$MedicineModelDataFromJson(json);

  Map<String, dynamic> toJson() => _$MedicineModelDataToJson(this);
}

@JsonSerializable()
class AlarmTimes {
  final String time;
  final bool taken;

  AlarmTimes({
    required this.time,
    required this.taken,
  });
  factory AlarmTimes.fromJson(Map<String, dynamic> json) =>
      _$AlarmTimesFromJson(json);

  Map<String, dynamic> toJson() => _$AlarmTimesToJson(this);
}
