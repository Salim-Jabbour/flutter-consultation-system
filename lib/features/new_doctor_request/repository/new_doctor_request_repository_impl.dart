import 'dart:io';

import 'package:akemha/core/errors/base_error.dart';

import 'package:akemha/features/role_doctor/doctor_profile/models/doctor_specialization_model.dart';

import 'package:dartz/dartz.dart';

import '../../../core/errors/execption.dart';
import '../../../core/network/network_info.dart';
import '../data/datasource/remote/new_doctor_request_remote_data_source.dart';
import 'new_doctor_request_repository.dart';

class NewDoctorRequestRepositoryImpl extends NewDoctorRequestRepository {
  final NewDoctorRequestRemoteDataSource _newDoctorRequestRemoteDataSource;
  final NetworkInfo _networkInfo;

  NewDoctorRequestRepositoryImpl(
    this._newDoctorRequestRemoteDataSource,
    this._networkInfo,
  );
  @override
  Future<Either<Failure, String>> addRequest(
    File? file,
    String aboutMe,
    String emailAddress,
    String name,
    String deviceToken,
    String gender,
    String specializationId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _newDoctorRequestRemoteDataSource.addRequest(
          file,
          aboutMe,
          emailAddress,
          name,
          deviceToken,
          gender,
          specializationId,
        );
        return addSuccess.fold(
          (failure) => Left(failure),
          (newRequest) {
            return right(newRequest);
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
  Future<Either<Failure, DoctorSpecializationModel>>
      getSpecializations() async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess =
            await _newDoctorRequestRemoteDataSource.getSpecializations();
        return addSuccess.fold(
          (failure) => Left(failure),
          (doctorSpecializations) {
            return right(doctorSpecializations);
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
