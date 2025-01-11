part of 'device_bloc.dart';

// modified : sealed must be abstract
@immutable
sealed class DeviceEvent {}

class GetDevicesPage extends DeviceEvent {
  final int page;

  GetDevicesPage({this.page = 0});
}

class ReserveDeviceEvent extends DeviceEvent {
  final int id;
  final int count;

  ReserveDeviceEvent({required this.id, required this.count});
}
