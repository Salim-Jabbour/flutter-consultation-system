part of 'alarm_bloc.dart';

@immutable
abstract class AlarmState {}

class AlarmInitial extends AlarmState {}

class AlarmLoading extends AlarmState {}

class AddAlarmSuccess extends AlarmState {
  final String message;

  AddAlarmSuccess(this.message);
}

class AddAlarmFailure extends AlarmState {
  final Failure failure;

  AddAlarmFailure(this.failure);
}

class AlarmTakenSuccess extends AlarmState {
  final String takenMessage;

  AlarmTakenSuccess(this.takenMessage);
}

class AlarmTakenFailure extends AlarmState {
  final Failure failure;

  AlarmTakenFailure(this.failure);
}

class AlarmDeleteLoading extends AlarmState {}

class AlarmDeleteSuccess extends AlarmState {
  final String deleteMessage;

  AlarmDeleteSuccess(this.deleteMessage);
}

class AlarmDeleteFailure extends AlarmState {
  final Failure failure;

  AlarmDeleteFailure(this.failure);
}
