part of 'device_reservation_cubit.dart';

@immutable
sealed class DeviceReservationState {}

final class DeviceReservationInitial extends DeviceReservationState {}

final class DeviceReservationLoading extends DeviceReservationState {}

final class DeviceReservationFailure extends DeviceReservationState {
  final String errMessage;

  DeviceReservationFailure(this.errMessage);
}

final class DeviceReserved extends DeviceReservationState {
  final String message;

  DeviceReserved(this.message);
}