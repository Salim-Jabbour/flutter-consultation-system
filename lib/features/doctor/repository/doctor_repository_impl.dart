import 'package:akemha/core/errors/base_error.dart';

import 'package:akemha/features/doctor/model/doctor_model.dart';

import 'package:dartz/dartz.dart';

import '../../../core/errors/execption.dart';
import '../../../core/network/network_info.dart';
import '../data/datasource/remote/doctor_remote_data_source.dart';
import 'doctor_repository.dart';

class DoctorRepositoryImpl extends DoctorRepository {
  final DoctorRemoteDataSource _doctorRemoteDataSource;
  final NetworkInfo _networkInfo;

  DoctorRepositoryImpl(
    this._doctorRemoteDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, DoctorModel>> getDoctors(String token) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _doctorRemoteDataSource.getDoctors(token);
        return addSuccess.fold(
          (failure) => Left(failure),
          (getDoctors) {
            return right(getDoctors);
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
  Future<Either<Failure, DoctorModel>> getDoctorsSearchedByKeyword(
      String token, String keyword) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _doctorRemoteDataSource
            .getDoctorsSearchedByKeyword(token, keyword);
        return addSuccess.fold(
          (failure) => Left(failure),
          (doctorModelList) {
            return right(doctorModelList);
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
