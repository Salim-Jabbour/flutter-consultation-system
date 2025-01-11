import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/device_repository.dart';

part 'device_reservation_state.dart';

class DeviceReservationCubit extends Cubit<DeviceReservationState> {
  DeviceReservationCubit(this._deviceRepository) : super(DeviceReservationInitial());
  final DeviceRepository _deviceRepository;

  Future<void> reserveDevice({required int id, required int count}) async {
    emit(DeviceReservationLoading());
    final result = await _deviceRepository.reserveDevice(
      id: id,
      count: count,
    );
    result.fold((error) {
      emit(DeviceReservationFailure(error.message));
    }, (newDevices) {
      emit(DeviceReserved(newDevices));
    });
  }
}
