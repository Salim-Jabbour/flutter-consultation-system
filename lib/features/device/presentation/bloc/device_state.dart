part of 'device_bloc.dart';

// modified : sealed must be abstract
@immutable
sealed class DeviceState {}

final class DeviceInitial extends DeviceState {}

final class DevicesLoading extends DeviceState {}

final class DevicesLoaded extends DeviceState {
  final int nextPage;

  DevicesLoaded(this.nextPage);
}

final class DevicesFailure extends DeviceState {
  final String errMessage;

  DevicesFailure(this.errMessage);
}

final class DevicesReachMax extends DeviceState {}
