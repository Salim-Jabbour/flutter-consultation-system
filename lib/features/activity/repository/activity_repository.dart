import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';
import '../models/activity_model.dart';

abstract class ActivityRepository {

  Future<Either<Failure, List<ActivityModel>>> fetchActivitiesPage({int pageNumber = 0});
}
