import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/errors/failure.dart';
import '../../../core/network/network_info.dart';
import '../data/datasource/local/device_local_data_source.dart';
import '../data/datasource/remote/device_remote_data_source.dart';
import '../models/device_log_model.dart';
import '../models/device_model.dart';
import 'device_repository.dart';

class DeviceRepositoryImpl extends DeviceRepository {
  final DeviceLocalDataSource _deviceLocalDataSource;
  final DeviceRemoteDataSource _deviceRemoteDataSource;
  final NetworkInfo _networkInfo;

  DeviceRepositoryImpl(
    this._deviceRemoteDataSource,
    this._deviceLocalDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, List<DeviceModel>>> fetchDevicesPage(
      {int pageNumber = 0}) async {
    List<DeviceModel> devicesList;
    try {
      devicesList = await _deviceRemoteDataSource.fetchDevicesPage(
          pageNumber: pageNumber);
      return right(devicesList);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DeviceLogModel>>> fetchReservedDevices() async {
    List<DeviceLogModel> devicesList;
    try {
      devicesList = await _deviceRemoteDataSource.fetchReservedDevicesPage();
      return right(devicesList);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> reserveDevice(
      {required int id, required int count}) async {
    try {
      return right(
          await _deviceRemoteDataSource.reserveDevice(id: id, count: count));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
