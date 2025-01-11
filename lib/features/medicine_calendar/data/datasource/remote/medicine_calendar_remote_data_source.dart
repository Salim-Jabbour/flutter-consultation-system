import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/errors/base_error.dart';
import '../../../../../core/resource/string_manager.dart';
import '../../../models/medicine_model.dart';

abstract class MedicineCalendarRemoteDataSource {
  Future<Either<Failure, MedicineModel>> getTodaysMedicines(
      String token, String supervisedId);
}

class MedicineCalendarRemoteDataSourceImpl
    extends MedicineCalendarRemoteDataSource {
  final Dio dioClient;

  MedicineCalendarRemoteDataSourceImpl(this.dioClient);

  @override
  Future<Either<Failure, MedicineModel>> getTodaysMedicines(
      String token, String supervisedId) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response =
          await dioClient.get("/api/medicine/beneficiary/today/$supervisedId");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(
            MedicineModel.fromJson(response.data as Map<String, dynamic>));
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
