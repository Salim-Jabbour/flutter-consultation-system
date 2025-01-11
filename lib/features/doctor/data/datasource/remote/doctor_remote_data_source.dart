import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/errors/base_error.dart';
import '../../../../../core/resource/string_manager.dart';
import '../../../model/doctor_model.dart';

abstract class DoctorRemoteDataSource {
  Future<Either<Failure, DoctorModel>> getDoctors(String token);
  // Future<Either<Failure, DoctorModel>> getDoctorDetails(String token,int id);
  Future<Either<Failure, DoctorModel>> getDoctorsSearchedByKeyword(
      String token, String keyword);
}

class DoctorRemoteDataSourceImpl extends DoctorRemoteDataSource {
  final Dio dioClient;

  DoctorRemoteDataSourceImpl(this.dioClient);
  @override
  Future<Either<Failure, DoctorModel>> getDoctors(String token) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response = await dioClient.get("/api/user/doctors");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(
            DoctorModel.fromJson(response.data as Map<String, dynamic>));
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
  Future<Either<Failure, DoctorModel>> getDoctorsSearchedByKeyword(String token, String keyword) async{
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response = await dioClient
          .get('/api/user/doctors/keyword?keyword=$keyword');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(DoctorModel.fromJson(
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
