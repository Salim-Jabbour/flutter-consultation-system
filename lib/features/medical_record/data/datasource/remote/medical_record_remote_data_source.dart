import 'package:akemha/core/utils/dbg_print.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/errors/base_error.dart';
import '../../../../../core/resource/string_manager.dart';
import '../../../model/medical_record_model.dart';

abstract class MedicalRecordRemoteDataSource {
  Future<Either<Failure, MedicalRecordModel>> getMedicalRecord(String token);
  Future<Either<Failure, MedicalRecordPostModel>> postMedicalRecord(
      MedicalRecordModelData data, String token);
}

class MedicalRecordRemoteDataSourceImpl extends MedicalRecordRemoteDataSource {
  final Dio dioClient;

  MedicalRecordRemoteDataSourceImpl(this.dioClient);

  @override
  Future<Either<Failure, MedicalRecordModel>> getMedicalRecord(
      String token) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response = await dioClient.get("/api/medical_record");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(
            MedicalRecordModel.fromJson(response.data as Map<String, dynamic>));
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
  Future<Either<Failure, MedicalRecordPostModel>> postMedicalRecord(
      MedicalRecordModelData data, String token) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      dbg(data.toJson());
      response =
          await dioClient.post("/api/medical_record", data: data.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(
            MedicalRecordPostModel.fromJson(response.data as Map<String, dynamic>));
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
