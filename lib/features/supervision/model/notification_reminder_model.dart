import 'package:json_annotation/json_annotation.dart';

part 'notification_reminder_model.g.dart';

@JsonSerializable()
class NotificationReminderModel {
  final String? msg;
  final String data;

  NotificationReminderModel({
    required this.msg,
    required this.data,
  });
  factory NotificationReminderModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationReminderModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationReminderModelToJson(this);
}