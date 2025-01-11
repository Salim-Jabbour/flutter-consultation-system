// ignore_for_file: unused_field

import 'package:akemha/core/errors/base_error.dart';

import 'package:akemha/features/medicine_calendar/models/medicine_model.dart';

import 'package:dartz/dartz.dart';

import '../../../core/errors/execption.dart';
import '../../../core/network/network_info.dart';
import '../data/datasource/local/medicine_calendar_local_data_source.dart';
import '../data/datasource/remote/medicine_calendar_remote_data_source.dart';
import 'medicine_calendar_repository.dart';

class MedicineCalendarRepositoryImpl extends MedicineCalendarRepository {
  final MedicineCalendarLocalDataSource _medicineCalendarLocalDataSource;
  final MedicineCalendarRemoteDataSource _medicineCalendarRemoteDataSource;
  final NetworkInfo _networkInfo;

  MedicineCalendarRepositoryImpl(
    this._medicineCalendarRemoteDataSource,
    this._medicineCalendarLocalDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, MedicineModel>> getTodaysMedicines(
      String token, String supervisedId) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _medicineCalendarRemoteDataSource
            .getTodaysMedicines(token, supervisedId);
        return addSuccess.fold(
          (failure) => Left(failure),
          (getMedicines) {
            return right(getMedicines);
          },
        );
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return left(NoInternetFailure());
    }
  }
}
