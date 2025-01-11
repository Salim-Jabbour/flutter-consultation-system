import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/errors/base_error.dart';
import '../../../../../core/resource/string_manager.dart';
import '../../../../role_doctor/doctor_profile/models/doctor_specialization_model.dart';

abstract class NewDoctorRequestRemoteDataSource {
  Future<Either<Failure, String>> addRequest(
    File? file,
    String aboutMe,
    String emailAddress,
    String name,
    String deviceToken,
    String gender,
    String specializationId,
  );

  Future<Either<Failure, DoctorSpecializationModel>> getSpecializations();
}

class NewDoctorRequestRemoteDataSourceImpl
    extends NewDoctorRequestRemoteDataSource {
  final Dio dioClient;

  NewDoctorRequestRemoteDataSourceImpl(this.dioClient);

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
    final Response response;
    try {
      final formData = FormData();

      if (file != null) {
        formData.files.add(MapEntry(
          'file',
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ));
      }

      if (file == null) {
        return Left(Failure(message: StringManager.missingData.tr()));
      }

      formData.fields.add(MapEntry('aboutMe', aboutMe));

      formData.fields.add(MapEntry('name', name));

      formData.fields.add(MapEntry('email', emailAddress));

      formData.fields.add(MapEntry('deviceToken', deviceToken));

      formData.fields.add(MapEntry('specializationId', specializationId));

      if (specializationId == "0") {
        return Left(Failure(message: StringManager.missingData.tr()));
      }

      formData.fields.add(MapEntry('gender', gender));

      response =
          await dioClient.post("/api/user/doctor_request", data: formData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(StringManager.requestSendSuccessfully.tr());
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
  Future<Either<Failure, DoctorSpecializationModel>>
      getSpecializations() async {
    final Response response;
    try {
      response =
          await dioClient.get('/api/specialization/new_doctor_specializations');
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
}
