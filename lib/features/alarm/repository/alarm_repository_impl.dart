import 'package:akemha/core/errors/base_error.dart';
import 'package:akemha/features/alarm/models/alarm_info.dart';
import 'package:akemha/features/alarm/repository/alarm_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/errors/execption.dart';
import '../../../core/network/network_info.dart';
import '../data/datasource/remote/alarm_remote_datasource.dart';

class AlarmRepositoryImpl extends AlarmRepository {
  final AlarmRemoteDataSource _alarmRemoteDataSource;
  final NetworkInfo _networkInfo;

  AlarmRepositoryImpl(this._networkInfo, this._alarmRemoteDataSource);

  // @override
  // Future<Either<Failure, MedicamentAlarmData>> getInitialAlarms(
  //     String token) async {
  //   if (await _networkInfo.isConnected) {
  //     try {
  //       final addSuccess = await _alarmRemoteDataSource.getInitialAlarms(token);
  //       return addSuccess.fold(
  //         (failure) => Left(failure),
  //         (getMessages) {
  //           return right(getMessages);
  //         },
  //       );
  //     } on ServerException {
  //       return Left(ServerFailure());
  //     }
  //   } else {
  //     return left(NoInternetFailure());
  //   }
  // }

  @override
  Future<Either<Failure, String>> addMedicine(
      String token, MedicamentAlarmData medicamentAlarmData) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _alarmRemoteDataSource.addMedicine(
            token, medicamentAlarmData);
        return addSuccess.fold(
          (failure) => Left(failure),
          (string) {
            return right(string);
          },
        );
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, String>> deleteMedicine(String token, int id) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess =
            await _alarmRemoteDataSource.deleteMedicine(token, id);
        return addSuccess.fold(
          (failure) => Left(failure),
          (string) {
            return right(string);
          },
        );
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, String>> takenMedicine(
      String token, int localMedicineId, String ringingTime) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess =
            await _alarmRemoteDataSource.takenMedicine(token, localMedicineId,ringingTime);
        return addSuccess.fold(
          (failure) => Left(failure),
          (string) {
            return right(string);
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
