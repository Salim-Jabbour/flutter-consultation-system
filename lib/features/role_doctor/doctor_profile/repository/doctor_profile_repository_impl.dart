import 'dart:io';

import 'package:akemha/features/role_doctor/doctor_profile/models/doctor_post_model.dart';
import 'package:akemha/features/role_doctor/review_beneficiary_profile/models/beneficiary_consultation_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/base_error.dart';
import '../../../../core/errors/execption.dart';
import '../../../../core/network/network_info.dart';
import '../data/datasource/remote/doctor_profile_remote_data_source.dart';
import '../models/doctor_profile_model.dart';
import '../models/doctor_specialization_model.dart';
import 'doctor_profile_repository.dart';

class DoctorProfileRepositoryImpl extends DoctorProfileRepository {
  final DoctorProfileRemoteDataSource _doctorProfileRemoteDataSource;
  final NetworkInfo _networkInfo;

  DoctorProfileRepositoryImpl(
      this._doctorProfileRemoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, DoctorProfileModel>> getProfile(
      String token, String doctorId) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess =
            await _doctorProfileRemoteDataSource.getProfile(token, doctorId);
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
  Future<Either<Failure, BeneficiaryConsultationModel>> getConsultationsLog(
      String token, int pageNumber) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _doctorProfileRemoteDataSource
            .getConsultationsLog(token, pageNumber);
        return addSuccess.fold(
          (failure) => Left(failure),
          (doctorConsultations) {
            return right(doctorConsultations);
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
  Future<Either<Failure, DoctorPostModel>> getDoctorsPosts(
      String token, String doctorId, int pageNumber) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _doctorProfileRemoteDataSource.getDoctorsPosts(
            token, doctorId, pageNumber);
        return addSuccess.fold(
          (failure) => Left(failure),
          (doctorPosts) {
            return right(doctorPosts);
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
  Future<Either<Failure, bool>> deletePost(String token, String postId) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess =
            await _doctorProfileRemoteDataSource.deletePost(token, postId);
        return addSuccess.fold(
          (failure) => Left(failure),
          (doctorPosts) {
            return right(doctorPosts);
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
  Future<Either<Failure, String>> updateDoctorProfile(
      String token, DoctorProfileDetailsModel data, File? profileImg) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _doctorProfileRemoteDataSource
            .updateDoctorProfile(token, data, profileImg);
        return addSuccess.fold(
          (failure) => Left(failure),
          (doctorProfile) {
            return right(doctorProfile);
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
  Future<Either<Failure, DoctorSpecializationModel>> getSpecializations(
      String token) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess =
            await _doctorProfileRemoteDataSource.getSpecializations(token);
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

  @override
  Future<Either<Failure, bool>> changeChatStatus(
      String token, String consultationId, bool status) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _doctorProfileRemoteDataSource
            .changeChatStatus(token, consultationId, status);
        return addSuccess.fold(
          (failure) => Left(failure),
          (chatStatus) {
            return right(chatStatus);
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
