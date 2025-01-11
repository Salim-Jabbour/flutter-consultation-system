import 'package:dartz/dartz.dart';

import '../../../core/errors/base_error.dart';
import '../models/medicine_model.dart';

abstract class MedicineCalendarRepository {
  Future<Either<Failure, MedicineModel>> getTodaysMedicines(
      String token, String supervisedId);
}
