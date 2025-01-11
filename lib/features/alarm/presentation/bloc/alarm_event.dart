part of 'alarm_bloc.dart';

@immutable
abstract class AlarmEvent {}

class AlarmScreenOpened extends AlarmEvent {}

class AlarmScheduleEvent extends AlarmEvent {
  final String selectedRoutine;

  AlarmScheduleEvent({required this.selectedRoutine});
}

class AlarmStopEvent extends AlarmEvent {
  final int localId;
  final String ringingTime;
  final String token;
  AlarmStopEvent(this.token,this.localId, this.ringingTime);
}

class AlarmScheduleSetEvent extends AlarmEvent {
  final String token;
  final AlarmRoutine selectedRoutine;
  final List<DateTime> times; // list for "daily" case. One item for others
  final DateTime startDate;
  final DateTime? endDate;
  final AlarmRoutineType routineType;
  final AlarmWeekDay? alarmWeekDay; // Weekly case, null in others
  final int? selectedDayInMonth; // monthly case, null in others
  final String medicineName;
  final String? medicineDescription;

  AlarmScheduleSetEvent({
    required this.token,
    required this.selectedRoutine,
    required this.times,
    required this.startDate,
    required this.endDate,
    required this.routineType,
    required this.alarmWeekDay,
    required this.selectedDayInMonth,
    required this.medicineName,
    required this.medicineDescription,
  });
}

class AlarmDeleteEvent extends AlarmEvent {
  final int alarmLocalId;
  final String token;
  AlarmDeleteEvent({required this.alarmLocalId, required this.token});
}
