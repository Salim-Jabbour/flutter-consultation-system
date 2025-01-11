// ignore_for_file: unused_field

import 'package:akemha/core/errors/failure.dart';
import 'package:akemha/core/utils/dbg_print.dart';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/network/network_info.dart';
import '../data/datasource/local/activity_local_data_source.dart';
import '../data/datasource/remote/activity_remote_data_source.dart';
import '../models/activity_model.dart';
import 'activity_repository.dart';

class ActivityRepositoryImpl extends ActivityRepository {
  final ActivityLocalDataSource _activityLocalDataSource;
  final ActivityRemoteDataSource _activityRemoteDataSource;
  final NetworkInfo _networkInfo;

  ActivityRepositoryImpl(
    this._activityRemoteDataSource,
    this._activityLocalDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, List<ActivityModel>>> fetchActivitiesPage(
      {int pageNumber = 0}) async {
    List<ActivityModel> activitiesList;
    try {
      activitiesList = [];
      //FixMe: Un comment
      activitiesList = await _activityRemoteDataSource.fetchActivitiesPage(
          pageNumber: pageNumber);
      dbg("in repo before right");
      dbg(activitiesList);
      return right(activitiesList);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
