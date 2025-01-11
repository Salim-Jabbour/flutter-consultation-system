import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/errors/base_error.dart';
import '../../../../../core/resource/string_manager.dart';
import '../../../../medicine_calendar/models/medicine_model.dart';
import '../../../model/notification_reminder_model.dart';
import '../../../model/supervision_model.dart';

abstract class SupervisionRemoteDataSource {
  // first tab
  Future<Either<Failure, SupervisionModel>>
      getApprovedSupervisionBySupervisorFirstTab(String token);
  // second tab
  Future<Either<Failure, SupervisionModel>>
      getApprovedSupervisionBySupervisedSecondTab(String token);
  // inside bell
  Future<Either<Failure, SupervisionModel>> viewSupervisionRequestInsideBell(
      String token);
  // delete supervision (can go three ways: 1. first tab 2. second tab 3. inside bell)
  Future<Either<Failure, String>> deleteSupervision(
      String supervisionId, String token);
  // inside bell by pressing check hence approve
  Future<Either<Failure, String>> approveSupervision(
      String supervisionId, String token);

  // sending request in first tab floating action button
  Future<Either<Failure, String>>
      sendSupervisionRequestInsideFloatingActionButton(
          String supervisedId, String token);
  // get random 10 users
  Future<Either<Failure, SupervisionUserModel>> getRandomTenUser(String token);
  // get 10 users after search
  Future<Either<Failure, SupervisionUserModel>> getTenUserSearchedByKeyword(
      String token, String keyword);

  // get todays medicine for the supervised
  Future<Either<Failure, MedicineModel>> getTodaysSupervisedMedicines(
      String token, String supervisedId);

  // send notification
  Future<Either<Failure, NotificationReminderModel>>
      sendNotificationToSupervised(
          String token, String supervisedId, String name, String time);
}

class SupervisionRemoteDataSourceImpl extends SupervisionRemoteDataSource {
  final Dio dioClient;

  final String subDomain = '/api/supervision';
  SupervisionRemoteDataSourceImpl(this.dioClient);

  @override
  Future<Either<Failure, SupervisionModel>>
      getApprovedSupervisionBySupervisorFirstTab(String token) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response = await dioClient.get('$subDomain/approved/supervisor');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(
            SupervisionModel.fromJson(response.data as Map<String, dynamic>));
      }
    } on DioException catch (e) {
      if (e.response == null) {
        return left(NoInternetFailure());
      }
      if (e.response!.data['msg'] != null) {
        return left(Failure(message: e.response!.data['msg'].toString()));
      } else {
        return Left(
          Failure(message: StringManager.sthWrong.tr()),
        );
      }
    }
    return Left(ServerFailure());
  }

  @override
  Future<Either<Failure, SupervisionModel>>
      getApprovedSupervisionBySupervisedSecondTab(String token) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response = await dioClient.get('$subDomain/approved/supervised');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(
            SupervisionModel.fromJson(response.data as Map<String, dynamic>));
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
  Future<Either<Failure, String>> approveSupervision(
      String supervisionId, String token) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response = await dioClient.post('$subDomain/reply/$supervisionId');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data['msg']);
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
  Future<Either<Failure, String>> deleteSupervision(
      String supervisionId, String token) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response = await dioClient.delete('$subDomain/$supervisionId');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data['msg']);
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
  Future<Either<Failure, SupervisionModel>> viewSupervisionRequestInsideBell(
      String token) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response = await dioClient.get('$subDomain/requests');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(
            SupervisionModel.fromJson(response.data as Map<String, dynamic>));
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
  Future<Either<Failure, String>>
      sendSupervisionRequestInsideFloatingActionButton(
          String supervisedId, String token) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response = await dioClient.post('$subDomain/request/$supervisedId');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data['msg']);
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
  Future<Either<Failure, SupervisionUserModel>> getRandomTenUser(
      String token) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response = await dioClient.get('$subDomain/possible_supervisor');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(SupervisionUserModel.fromJson(
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
  Future<Either<Failure, SupervisionUserModel>> getTenUserSearchedByKeyword(
      String token, String keyword) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response = await dioClient
          .get('$subDomain/possible_supervisor/keyword?keyword=$keyword');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(SupervisionUserModel.fromJson(
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

  // get todays medicine for the supervised
  @override
  Future<Either<Failure, MedicineModel>> getTodaysSupervisedMedicines(
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

// send notification
  @override
  Future<Either<Failure, NotificationReminderModel>>
      sendNotificationToSupervised(
          String token, String supervisedId, String name, String time) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response = await dioClient
          .post("/api/supervision/send_reminder/$supervisedId", data: {
        "name": name,
        "time": time,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(NotificationReminderModel.fromJson(
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
