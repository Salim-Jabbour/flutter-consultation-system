part of 'reserved_device_cubit.dart';

@immutable
sealed class ReservedDeviceState {}

final class ReservedDeviceInitial extends ReservedDeviceState {}

final class ReservedDevicesLoading extends ReservedDeviceState {}

final class ReservedDevicesLoaded extends ReservedDeviceState {}

final class ReservedDevicesFailure extends ReservedDeviceState {
  final String errMessage;

  ReservedDevicesFailure(this.errMessage);
}
