import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/errors/base_error.dart';
import '../../../../../../core/resource/string_manager.dart';
import '../../../../review_beneficiary_profile/models/beneficiary_consultation_model.dart';
import '../../../models/doctor_post_model.dart';
import '../../../models/doctor_profile_model.dart';
import '../../../models/doctor_specialization_model.dart';

abstract class DoctorProfileRemoteDataSource {
  Future<Either<Failure, DoctorProfileModel>> getProfile(
      String token, String doctorId);

  Future<Either<Failure, BeneficiaryConsultationModel>> getConsultationsLog(
      String token, int pageNumber);

  Future<Either<Failure, DoctorPostModel>> getDoctorsPosts(
      String token, String doctorId, int pageNumber);

  Future<Either<Failure, bool>> deletePost(String token, String postId);

  Future<Either<Failure, String>> updateDoctorProfile(
    String token,
    DoctorProfileDetailsModel data,
    File? profileImg,
  );

  Future<Either<Failure, DoctorSpecializationModel>> getSpecializations(
      String token);

  Future<Either<Failure, bool>> changeChatStatus(
      String token, String consultationId, bool status);
}

class DoctorProfileRemoteDataSourceImpl extends DoctorProfileRemoteDataSource {
  final Dio dioClient;

  DoctorProfileRemoteDataSourceImpl(this.dioClient);
  @override
  Future<Either<Failure, DoctorProfileModel>> getProfile(
      String token, String doctorId) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response = await dioClient.get("/api/user/information/$doctorId");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(
            DoctorProfileModel.fromJson(response.data as Map<String, dynamic>));
      }
    } on DioException catch (e) {
      if (e.response == null) {
        return left(NoInternetFailure());
      }
      if (e.response!.data['message'] != null) {
        return left(Failure(message: e.response!.data['message'].toString()));
      } else {
        return Left(
          Failure(message: StringManager.sthWrong.tr()),
        );
      }
    }
    return Left(ServerFailure());
  }

  @override
  Future<Either<Failure, BeneficiaryConsultationModel>> getConsultationsLog(
      String token, int pageNumber) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response = await dioClient.get(
          '/api/consultation/getDoctorAnsweredConsultations',
          queryParameters: {
            "page": "$pageNumber",
          });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(BeneficiaryConsultationModel.fromJson(
            response.data as Map<String, dynamic>));
      }
    } on DioException catch (e) {
      if (e.response == null) {
        return left(NoInternetFailure());
      }
      if (e.response!.data['message'] != null) {
        return left(Failure(message: e.response!.data['message'].toString()));
      } else {
        return Left(
          Failure(message: StringManager.sthWrong.tr()),
        );
      }
    }
    return Left(ServerFailure());
  }

  @override
  Future<Either<Failure, DoctorPostModel>> getDoctorsPosts(
      String token, String doctorId, int pageNumber) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response =
          await dioClient.get('/api/post/doctor/$doctorId', queryParameters: {
        "page": "$pageNumber",
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(
            DoctorPostModel.fromJson(response.data as Map<String, dynamic>));
      }
    } on DioException catch (e) {
      if (e.response == null) {
        return left(NoInternetFailure());
      }
      if (e.response!.data['message'] != null) {
        return left(Failure(message: e.response!.data['message'].toString()));
      } else {
        return Left(
          Failure(message: StringManager.sthWrong.tr()),
        );
      }
    }
    return Left(ServerFailure());
  }

  @override
  Future<Either<Failure, bool>> deletePost(String token, String postId) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});

      response = await dioClient.delete('/api/post/$postId');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(true);
      }
    } on DioException catch (e) {
      if (e.response == null) {
        return left(NoInternetFailure());
      }
      if (e.response!.data['message'] != null) {
        return left(Failure(message: e.response!.data['message'].toString()));
      } else {
        return Left(
          Failure(message: StringManager.sthWrong.tr()),
        );
      }
    }
    return Left(ServerFailure());
  }

  @override
  Future<Either<Failure, String>> updateDoctorProfile(
    String token,
    DoctorProfileDetailsModel data,
    File? profileImg,
  ) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});

      final formData = FormData();

      if (profileImg != null) {
        formData.files.add(MapEntry(
          'profileImg',
          await MultipartFile.fromFile(
            profileImg.path,
            filename: profileImg.path.split('/').last,
          ),
        ));
      }

      if (data.name != null) formData.fields.add(MapEntry('name', data.name!));

      if (data.id > 0) {
        formData.fields.add(MapEntry('specializationId', data.id.toString()));
      }

      if (data.description != null) {
        formData.fields.add(MapEntry('description', data.description!));
      }
      if (data.location != null) {
        formData.fields.add(MapEntry('location', data.location!));
      }
      if (data.openingTimes != null) {
        formData.fields.add(MapEntry('openingTimes', data.openingTimes!));
      }

      response = await dioClient.patch('/api/user/information/doctor/edit',
          data: formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(StringManager.updatedSuccessfully.tr());
      }
    } on DioException catch (e) {
      if (e.response == null) {
        return left(NoInternetFailure());
      }
      if (e.response!.data['message'] != null) {
        return left(Failure(message: e.response!.data['message'].toString()));
      } else {
        return Left(
          Failure(message: StringManager.sthWrong.tr()),
        );
      }
    }
    return Left(ServerFailure());
  }

  @override
  Future<Either<Failure, DoctorSpecializationModel>> getSpecializations(
      String token) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response =
          await dioClient.get('/api/specialization/doctor_specializations');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(DoctorSpecializationModel.fromJson(
            response.data as Map<String, dynamic>));
      }
    } on DioException catch (e) {
      if (e.response == null) {
        return left(NoInternetFailure());
      }
      if (e.response!.data['message'] != null) {
        return left(Failure(message: e.response!.data['message'].toString()));
      } else {
        return Left(
          Failure(message: StringManager.sthWrong.tr()),
        );
      }
    }
    return Left(ServerFailure());
  }

  @override
  Future<Either<Failure, bool>> changeChatStatus(
      String token, String consultationId, bool status) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response = await dioClient.post(
          '/api/consultation/consultation/chatStatus/$consultationId/$status');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(true);
      }
    } on DioException catch (e) {
      if (e.response == null) {
        return left(NoInternetFailure());
      }
      if (e.response!.data['message'] != null) {
        return left(Failure(message: e.response!.data['message'].toString()));
      } else {
        return Left(
          Failure(message: StringManager.sthWrong.tr()),
        );
      }
    }
    return Left(ServerFailure());
  }
}
