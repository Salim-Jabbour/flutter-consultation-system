import 'package:akemha/core/errors/base_error.dart';

import 'package:akemha/features/medical_record/model/medical_record_model.dart';

import 'package:dartz/dartz.dart';

import '../../../core/errors/execption.dart';
import '../../../core/network/network_info.dart';
import '../data/datasource/remote/medical_record_remote_data_source.dart';
import 'medical_record_repository.dart';

class MedicalRecordRepositoryImpl extends MedicalRecordRepository {
  final MedicalRecordRemoteDataSource _medicalRecordRemoteDataSource;
  final NetworkInfo _networkInfo;

  MedicalRecordRepositoryImpl(
    this._medicalRecordRemoteDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, MedicalRecordModel>> getMedicalRecord(
      String token) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess =
            await _medicalRecordRemoteDataSource.getMedicalRecord(token);
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
  Future<Either<Failure, MedicalRecordPostModel>> postMedicalRecord(
      MedicalRecordModelData data, String token) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess =
            await _medicalRecordRemoteDataSource.postMedicalRecord(data, token);
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
}
