import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';
import '../models/device_log_model.dart';
import '../models/device_model.dart';

abstract class DeviceRepository {
  Future<Either<Failure, List<DeviceModel>>> fetchDevicesPage(
      {int pageNumber = 0});

  Future<Either<Failure, List<DeviceLogModel>>> fetchReservedDevices();

  Future<Either<Failure, String>> reserveDevice(
      {required int count, required int id});
}
