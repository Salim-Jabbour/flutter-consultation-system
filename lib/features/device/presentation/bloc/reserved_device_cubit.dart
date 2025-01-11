import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/device_log_model.dart';
import '../../repository/device_repository.dart';

part 'reserved_device_state.dart';

class ReservedDeviceCubit extends Cubit<ReservedDeviceState> {
  ReservedDeviceCubit(this._deviceRepository) : super(ReservedDeviceInitial());
  List<DeviceLogModel> devices = [];

  final DeviceRepository _deviceRepository;

  Future<void> getReservedDevices() async {
    emit(ReservedDevicesLoading());
    devices=[];
    final result = await _deviceRepository.fetchReservedDevices();
    result.fold((error) {
      emit(ReservedDevicesFailure(error.message));
    }, (newDevices) {
      devices.addAll(newDevices);
      emit(ReservedDevicesLoaded());
    });
  }
}
