import 'dart:async';

import 'package:akemha/core/storage/alarm_preferences.dart';
import 'package:akemha/core/utils/dbg_print.dart';
import 'package:akemha/features/alarm/models/alarm_info.dart';
import 'package:akemha/features/alarm/presentation/enums/alarm_routine.dart';
import 'package:akemha/features/alarm/presentation/enums/alarm_routine_type.dart';
import 'package:akemha/features/alarm/repository/alarm_repository.dart';
import 'package:akemha/features/alarm/scheduler/alarm_helper.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/errors/base_error.dart';
import '../enums/days.dart';

part 'alarm_event.dart';
part 'alarm_state.dart';

var _tag = "AlarmBloc";

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  final AlarmRepository _alarmRepository;

  var alarmRepo = GetIt.I.get<AlarmPreferences>();

  AlarmBloc(this._alarmRepository) : super(AlarmInitial()) {
    dbgt(_tag, "Alarm bloc");

    on<AlarmScreenOpened>((event, emit) async {
      dbgt(_tag, "AlarmScreenOpened");
      dbgt(_tag, "SALIMOOO");
      dbgt(_tag, "SAMIIIIIIII");
      // emit(AlarmLoading());

      checkAndroidNotificationPermission();
      checkAndroidScheduleExactAlarmPermission();
    });

    on<AlarmScheduleSetEvent>((event, emit) async {
      dbgt(_tag,
          "AlarmScheduleSetEvent: selectedRoutine: ${event.selectedRoutine}");
      dbgt(_tag,
          "AlarmScheduleSetEvent: times: ${event.times.map((e) => e.toString())}");
      dbgt(_tag, "AlarmScheduleSetEvent: startDate: ${event.startDate}");
      dbgt(_tag, "AlarmScheduleSetEvent: startDate: ${event.endDate}");
      dbgt(_tag, "AlarmScheduleSetEvent: routineType: ${event.routineType}");
      dbgt(_tag, "AlarmScheduleSetEvent: weekDay: ${event.alarmWeekDay}");

      if (event.selectedRoutine == AlarmRoutine.daily) {
        final alarmsHolderId = await alarmRepo.getSequenceId();
        final dailyAlarm = MedicamentAlarmData(
          id: alarmsHolderId,
          medicamentName: event.medicineName,
          medicamentType: "شراب",
          alarmRoutine: AlarmRoutine.daily,
          //////////
          alarmRoutineType: event.routineType,
          alarmTimes: event.times,
          startDate: event.startDate,
          endDate: event.endDate,
          alarmWeekDay: null,
          selectedDayInMonth: null,
        );

        // Using "alarm" lib, schedule the wanted alarms
        if (await schedulerDailyAlarm(dailyAlarm)) {
          emit(AlarmLoading());
          final successOrFailure = await _alarmRepository.addMedicine(
            event.token,
            dailyAlarm,
          );
          successOrFailure.fold(
            (error) {
              emit(AddAlarmFailure(error));
            },
            (string) {
              emit(AddAlarmSuccess(string));
            },
          );
        }
      } else if (event.selectedRoutine == AlarmRoutine.weekly) {
        final alarmsHolderId = await alarmRepo.getSequenceId();
        final weeklyAlarm = MedicamentAlarmData(
          id: alarmsHolderId,
          medicamentName: event.medicineName,
          medicamentType: "حبوب",
          alarmRoutine: AlarmRoutine.weekly,
          //////////
          alarmRoutineType: event.routineType,
          alarmTimes: event.times,
          startDate: event.startDate,
          endDate: event.endDate,
          alarmWeekDay: event.alarmWeekDay,
          selectedDayInMonth: null,
        );

        // Using "alarm" lib, schedule the wanted alarms
        await schedulerWeeklyAlarm(weeklyAlarm);
        emit(AlarmLoading());
        final successOrFailure = await _alarmRepository.addMedicine(
            event.token,
            // tokenAlarm,
            weeklyAlarm);
        successOrFailure.fold(
          (error) {
            emit(AddAlarmFailure(error));
          },
          (string) {
            emit(AddAlarmSuccess(string));
          },
        );
      } else if (event.selectedRoutine == AlarmRoutine.monthly) {
        final alarmsHolderId = await alarmRepo.getSequenceId();
        final monthlyAlarm = MedicamentAlarmData(
          id: alarmsHolderId,
          medicamentName: event.medicineName,
          medicamentType: "ابرة",
          alarmRoutine: AlarmRoutine.monthly,
          //////////
          alarmRoutineType: event.routineType,
          alarmTimes: event.times,
          startDate: event.startDate,
          endDate: event.endDate,
          alarmWeekDay: event.alarmWeekDay,
          selectedDayInMonth: event.selectedDayInMonth,
        );

        // Using "alarm" lib, schedule the wanted alarms
        await schedulerMonthlyAlarm(monthlyAlarm);
        emit(AlarmLoading());
        final successOrFailure = await _alarmRepository.addMedicine(
            event.token,
            // tokenAlarm,
            monthlyAlarm);
        successOrFailure.fold(
          (error) {
            emit(AddAlarmFailure(error));
          },
          (string) {
            emit(AddAlarmSuccess(string));
          },
        );
      }
    });

    on<AlarmDeleteEvent>((event, emit) async {
      emit(AlarmDeleteLoading());

      final successOrFailure = await _alarmRepository.deleteMedicine(
        event.token,
        event.alarmLocalId,
      );
      successOrFailure.fold(
        (error) {
          emit(AlarmDeleteFailure(error));
        },
        (string) {
          emit(AlarmDeleteSuccess(string));
        },
      );
    });

    on<AlarmStopEvent>((event, emit) async {
      dbgt(_tag, "AlarmStopEvent");
      // emit(AlarmLoading());
      final successOrFailure = await _alarmRepository.takenMedicine(
        event.token,
        event.localId,
        event.ringingTime,
      );
      successOrFailure.fold(
        (error) {
          dbg("I am in Failure error");
          emit(AlarmTakenFailure(error));
        },
        (string) {
          dbg("*********************");
          dbg(string);
          emit(AlarmTakenSuccess(string));
        },
      );
    });
  }
}

Future<void> checkAndroidNotificationPermission() async {
  final status = await Permission.notification.status;
  alarmPrint('checkAndroidNotificationPermission: $status.');
  if (status.isDenied) {
    alarmPrint('Requesting notification permission...');
    final res = await Permission.notification.request();
    alarmPrint(
      'Notification permission ${res.isGranted ? '' : 'not '}granted',
    );
  }
}

Future<void> checkAndroidScheduleExactAlarmPermission() async {
  final status = await Permission.scheduleExactAlarm.status;
  alarmPrint('Schedule exact alarm permission: $status.');
  if (status.isDenied) {
    alarmPrint('Requesting schedule exact alarm permission...');
    final res = await Permission.scheduleExactAlarm.request();
    alarmPrint(
      'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted',
    );
  }
}
