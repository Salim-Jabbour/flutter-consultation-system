import 'package:akemha/core/utils/dbg_print.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/errors/base_error.dart';
import '../../../../../core/resource/string_manager.dart';
import '../../../models/alarm_info.dart';

abstract class AlarmRemoteDataSource {
  // TODO: when user logs out then he logs in he restores all of the alarms
  
  // Future<Either<Failure, MedicamentAlarmData>> getInitialAlarms(String token);
  Future<Either<Failure, String>> addMedicine(
      String token, MedicamentAlarmData medicamentAlarmData);
  Future<Either<Failure, String>> deleteMedicine(String token, int localId);
  Future<Either<Failure, String>> takenMedicine(
      String token, int localMedicineId, String ringingTime);
}

class AlarmRemoteDataSourceImpl extends AlarmRemoteDataSource {
  final Dio dioClient;

  AlarmRemoteDataSourceImpl(this.dioClient);

  // @override
  // Future<Either<Failure, MedicamentAlarmData>> getInitialAlarms(
  //     String token) async {
  //   final Response response;
  //   try {
  //     dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
  //     response = await dioClient.get("alarm");
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return Right(MedicamentAlarmData.fromJson(
  //           response.data as Map<String, dynamic>));
  //     }
  //   } on DioException catch (e) {
  //     if (e.response == null) {
  //       return left(NoInternetFailure());
  //     }
  //     if (e.response!.data['message'] != null) {
  //       return left(Failure(message: e.response!.data['message'].toString()));
  //     } else {
  //       return Left(
  //         Failure(message: StringManager.sthWrong.tr()),
  //       );
  //     }
  //   }
  //   return Left(ServerFailure());
  // }

  @override
  Future<Either<Failure, String>> addMedicine(
      String token, MedicamentAlarmData medicamentAlarmData) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      dbg(medicamentAlarmData.toJson());
      response = await dioClient.post("/api/medicine",
          data: medicamentAlarmData.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right("Medicine added success");
      }
    } on DioException catch (e) {
      if (e.response == null) {
        return Left(NoInternetFailure());
      }

      if (e.response!.data is Map<String, dynamic> &&
          e.response!.data['message'] != null) {
        return Left(Failure(message: e.response!.data['message'].toString()));
      } else {
        return Left(Failure(message: StringManager.sthWrong.tr()));
      }
    }
    return Left(ServerFailure());
  }

  @override
  Future<Either<Failure, String>> deleteMedicine(
      String token, int localId) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response = await dioClient.delete("/api/medicine/$localId");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right("Medicine deleted successfully");
      }
    } on DioException catch (e) {
      if (e.response == null) {
        return left(NoInternetFailure());
      }
      if (e.response!.data['message'] != null) {
        return left(Failure(message: e.response!.data['message'].toString()));
      } else {
        return Left(Failure(message: StringManager.sthWrong.tr()));
      }
    }
    return Left(ServerFailure());
  }

  @override
  Future<Either<Failure, String>> takenMedicine(
      String token, int localMedicineId, String ringingTime) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response =
          await dioClient.post("/api/medicine/take/$localMedicineId", data: {
        "ringingTime": ringingTime,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right("Medicine taken successfully");
      }
    } on DioException catch (e) {
      if (e.response == null) {
        return left(NoInternetFailure());
      }
      if (e.response!.data['message'] != null) {
        return left(Failure(message: e.response!.data['message'].toString()));
      } else {
        return Left(Failure(message: StringManager.sthWrong.tr()));
      }
    }
    return Left(ServerFailure());
  }
}
