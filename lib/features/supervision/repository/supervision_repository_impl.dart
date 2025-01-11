import 'package:akemha/core/errors/base_error.dart';

import 'package:akemha/features/supervision/model/supervision_model.dart';

import 'package:dartz/dartz.dart';

import '../../../core/errors/execption.dart';
import '../../../core/network/network_info.dart';
import '../../medicine_calendar/models/medicine_model.dart';
import '../data/datasource/remote/supervision_remote_data_source.dart';
import '../model/notification_reminder_model.dart';
import 'supervision_repository.dart';

class SupervisionRepositoryImpl extends SupervisionRepository {
  // final SupervisionLocalDataSource _supervisionLocalDataSource;
  final SupervisionRemoteDataSource _supervisionRemoteDataSource;
  final NetworkInfo _networkInfo;

  SupervisionRepositoryImpl(
    this._supervisionRemoteDataSource,
    // this._supervisionLocalDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, SupervisionModel>>
      getApprovedSupervisionBySupervisorFirstTab(String token) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _supervisionRemoteDataSource
            .getApprovedSupervisionBySupervisorFirstTab(token);
        return addSuccess.fold(
          (failure) => Left(failure),
          (supervisionModel) {
            return right(supervisionModel);
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
  Future<Either<Failure, SupervisionModel>>
      getApprovedSupervisionBySupervisedSecondTab(String token) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _supervisionRemoteDataSource
            .getApprovedSupervisionBySupervisedSecondTab(token);
        return addSuccess.fold(
          (failure) => Left(failure),
          (supervisionModel) {
            return right(supervisionModel);
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
  Future<Either<Failure, String>> approveSupervision(
      String supervisionId, String token) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _supervisionRemoteDataSource
            .approveSupervision(supervisionId, token);
        return addSuccess.fold(
          (failure) => Left(failure),
          (supervisionApproveResponse) {
            return right(supervisionApproveResponse);
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
  Future<Either<Failure, String>> deleteSupervision(
      String supervisionId, String token) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _supervisionRemoteDataSource.deleteSupervision(
            supervisionId, token);
        return addSuccess.fold(
          (failure) => Left(failure),
          (supervisionDeleteResponse) {
            return right(supervisionDeleteResponse);
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
  Future<Either<Failure, SupervisionModel>> viewSupervisionRequestInsideBell(
      String token) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _supervisionRemoteDataSource
            .viewSupervisionRequestInsideBell(token);
        return addSuccess.fold(
          (failure) => Left(failure),
          (supervisionModel) {
            return right(supervisionModel);
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
  Future<Either<Failure, String>>
      sendSupervisionRequestInsideFloatingActionButton(
          String supervisedId, String token) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _supervisionRemoteDataSource
            .sendSupervisionRequestInsideFloatingActionButton(
                supervisedId, token);
        return addSuccess.fold(
          (failure) => Left(failure),
          (supervisionResponse) {
            return right(supervisionResponse);
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
  Future<Either<Failure, SupervisionUserModel>> getRandomTenUser(
      String token) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess =
            await _supervisionRemoteDataSource.getRandomTenUser(token);
        return addSuccess.fold(
          (failure) => Left(failure),
          (userModelList) {
            return right(userModelList);
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
  Future<Either<Failure, SupervisionUserModel>> getTenUserSearchedByKeyword(
      String token, String keyword) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _supervisionRemoteDataSource
            .getTenUserSearchedByKeyword(token, keyword);
        return addSuccess.fold(
          (failure) => Left(failure),
          (userModelList) {
            return right(userModelList);
          },
        );
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return left(NoInternetFailure());
    }
  }

  // get todays medicine for the supervised
  @override
  Future<Either<Failure, MedicineModel>> getTodaysSupervisedMedicines(
      String token, String supervisedId) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _supervisionRemoteDataSource
            .getTodaysSupervisedMedicines(token, supervisedId);
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

// send notififcation to supervised
  @override
  Future<Either<Failure, NotificationReminderModel>>
      sendNotificationToSupervised(
    String token,
    String supervisedId,
    String name,
    String time,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _supervisionRemoteDataSource
            .sendNotificationToSupervised(token, supervisedId, name, time);
        return addSuccess.fold(
          (failure) => Left(failure),
          (sendNotification) {
            return right(sendNotification);
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
