import 'package:akemha/core/errors/base_error.dart';
import 'package:dartz/dartz.dart';

import '../models/alarm_info.dart';

abstract class AlarmRepository {
  // Future<Either<Failure, MedicamentAlarmData>> getInitialAlarms(String token);
  Future<Either<Failure, String>> addMedicine(
      String token, MedicamentAlarmData medicamentAlarmData);
  Future<Either<Failure, String>> deleteMedicine(String token, int id);
  Future<Either<Failure, String>> takenMedicine(
      String token, int localMedicineId,String ringingTime);
}
