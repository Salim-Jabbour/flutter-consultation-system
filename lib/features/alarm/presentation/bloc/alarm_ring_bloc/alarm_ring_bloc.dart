import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/router/app_route_config.dart';
import '../../../../../core/utils/dbg_print.dart';
import '../../page/alarm_ring.dart';
import '../alarm_bloc.dart';

part 'alarm_ring_event.dart';
part 'alarm_ring_state.dart';

class AlarmRingBloc extends Bloc<AlarmRingEvent, AlarmRingState> {
  static StreamSubscription<AlarmSettings>? _subscription;
  // make all the alarm pages take from this variable
  List<AlarmSettings>? alarms;

  AlarmRingBloc() : super(AlarmRingInitial()) {
    // on<AlarmStarted>(_onAlarmStarted);
    on<AlarmRang>((event, emit) {
      if (Alarm.android) {
        checkAndroidNotificationPermission();
        checkAndroidScheduleExactAlarmPermission();
      }
      _onAlarmRang(event, emit);
    });
  }

  void _onAlarmRang(AlarmRang event, Emitter<AlarmRingState> emit) {
    loadAlarms();
    _startListening(event.context);
    loadAlarms();
  }

  void loadAlarms() {
    alarms = Alarm.getAlarms();
    alarms!.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
  }

  void _startListening(BuildContext context) {
    _subscription = Alarm.ringStream.stream.listen(
      (alarmSettings) {
        rootNavigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => AlarmRingPage(alarmSettings: alarmSettings),
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    dbg("the subscription is being canceled and disposed");
    _subscription?.cancel();
    return super.close();
  }
}
