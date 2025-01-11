import 'package:json_annotation/json_annotation.dart';

import '../../../consultation/models/specialization.dart';

part 'doctor_specialization_model.g.dart';

@JsonSerializable()
class DoctorSpecializationModel {
  final List<Specialization> data;
  final String msg;

  DoctorSpecializationModel({required this.data, required this.msg});

  factory DoctorSpecializationModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorSpecializationModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorSpecializationModelToJson(this);
}
