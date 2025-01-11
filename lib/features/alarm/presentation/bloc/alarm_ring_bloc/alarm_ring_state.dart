part of 'alarm_ring_bloc.dart';

sealed class AlarmRingState extends Equatable {
  const AlarmRingState();
  
  @override
  List<Object> get props => [];
}

final class AlarmRingInitial extends AlarmRingState {}

class AlarmRingSubscribtionState extends AlarmRingState {
  // final AlarmSettings alarmSettings;

  const AlarmRingSubscribtionState();
}