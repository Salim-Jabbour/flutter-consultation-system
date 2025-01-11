import 'package:akemha/core/utils/dbg_print.dart';
import 'package:akemha/core/utils/services/api_service.dart';
import 'package:dio/dio.dart';

import '../../../models/activity_model.dart';

abstract class ActivityRemoteDataSource {
  Future<List<ActivityModel>> fetchActivitiesPage({int pageNumber = 0});
}

class ActivityRemoteDataSourceImpl extends ActivityRemoteDataSource {
  final Dio dioClient;

  ActivityRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<ActivityModel>> fetchActivitiesPage({int pageNumber = 0}) async {
    dioClient.options.headers.addAll({
      'authorization': 'Bearer ${ApiService.token}',
    });
    final Response response =
        await dioClient.get('/api/activity', queryParameters: {
      "page": "$pageNumber",
    });
    List<ActivityModel> activities = getActivityList(response.data);
    dbg(activities);
    return activities;
  }
}

List<ActivityModel> getActivityList(Map<String, dynamic> data) {
  return ActivitiesModel.fromJson(data).activities;
}
