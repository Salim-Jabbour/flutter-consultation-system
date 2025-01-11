part of 'alarm_ring_bloc.dart';

sealed class AlarmRingEvent extends Equatable {
  const AlarmRingEvent();

  @override
  List<Object> get props => [];
}

class AlarmRang extends AlarmRingEvent {
  // final AlarmSettings alarmSettings;
  final BuildContext context;

  const AlarmRang(this.context);
}
