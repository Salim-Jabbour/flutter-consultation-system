import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/errors/base_error.dart';
import '../../../../../core/resource/string_manager.dart';
import '../../../model/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<Failure, ProfileModel>> getProfileInfo(String token,String userId);
}

class ProfileRemoteDataSourceImpl extends ProfileRemoteDataSource {
  final Dio dioClient;

  ProfileRemoteDataSourceImpl(this.dioClient);
  @override
  Future<Either<Failure, ProfileModel>> getProfileInfo(String token,String userId) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response = await dioClient.get("/api/user/information/$userId");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(
            ProfileModel.fromJson(response.data as Map<String, dynamic>));
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
