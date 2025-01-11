import 'dart:async';

import 'package:akemha/features/device/models/device_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/device_repository.dart';

part 'device_event.dart';

part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final DeviceRepository _deviceRepository;

  List<DeviceModel> devices = [];
  Completer<void> refreshCompleter = Completer<void>();

  DeviceBloc(this._deviceRepository) : super(DeviceInitial()) {
    on<GetDevicesPage>((event, emit) async {
      refreshCompleter = Completer<void>();
      emit(DevicesLoading());
      final result = await _deviceRepository.fetchDevicesPage(
        pageNumber: event.page,
      );

      if (!refreshCompleter.isCompleted) {
        refreshCompleter.complete();
      }
      result.fold((error) {
        emit(DevicesFailure(error.message));
      }, (newDevices) {
        if (event.page == 0) {
          devices = [];
        }
        devices.addAll(newDevices);
        emit(newDevices.length < 10
            ? DevicesReachMax()
            : DevicesLoaded(event.page + 1));
      });
    });
    // on<ReserveDeviceEvent>((event, emit) async {
    //
    // });
  }
}
