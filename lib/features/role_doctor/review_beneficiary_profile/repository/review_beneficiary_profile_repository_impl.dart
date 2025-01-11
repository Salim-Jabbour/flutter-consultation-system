import 'package:akemha/features/medical_record/model/medical_record_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../core/errors/base_error.dart';
import '../../../../core/errors/execption.dart';
import '../../../../core/network/network_info.dart';
import '../../../medicine_calendar/models/medicine_model.dart';
import '../data/datasource/remote/review_beneficiary_profile_remote_datasource.dart';
import '../models/beneficiary_consultation_model.dart';
import '../models/beneficiary_profile_model.dart';
import 'review_beneficiary_profile_repository.dart';

class ReviewBeneficiaryProfileRepositoryImpl
    extends ReviewBeneficiaryProfileRepository {
  final ReviewBeneficiaryProfileRemoteDataSource
      _reviewBeneficiaryProfileRemoteDataSource;

  final NetworkInfo _networkInfo;

  ReviewBeneficiaryProfileRepositoryImpl(
      this._reviewBeneficiaryProfileRemoteDataSource, this._networkInfo);
  @override
  Future<Either<Failure, BeneficiaryProfileModel>> getProfile(
      String token, String userId) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _reviewBeneficiaryProfileRemoteDataSource
            .getProfile(token, userId);
        return addSuccess.fold(
          (failure) => Left(failure),
          (beneficaryProfile) {
            return right(beneficaryProfile);
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
  Future<Either<Failure, MedicalRecordModel>> getBeneficaryMedicalRecord(
      String token, String userId) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _reviewBeneficiaryProfileRemoteDataSource
            .getBeneficaryMedicalRecord(token, userId);
        return addSuccess.fold(
          (failure) => Left(failure),
          (beneficaryMedicalRecord) {
            return right(beneficaryMedicalRecord);
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
  Future<Either<Failure, BeneficiaryConsultationModel>>
      getBeneficaryConsultation({
    required String token,
    required String userId,
    required int pageNumber,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _reviewBeneficiaryProfileRemoteDataSource
            .getBeneficaryConsultation(
                token: token, userId: userId, pageNumber: pageNumber);
        return addSuccess.fold(
          (failure) => Left(failure),
          (beneficaryConsultations) {
            return right(beneficaryConsultations);
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
  Future<Either<Failure, MedicineModel>> getBeneficiaryMedicines(
      String token, String beneficiaryId) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _reviewBeneficiaryProfileRemoteDataSource
            .getBeneficiaryMedicines(token, beneficiaryId);
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
