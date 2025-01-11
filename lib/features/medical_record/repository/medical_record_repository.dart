import 'package:dartz/dartz.dart';

import '../../../core/errors/base_error.dart';
import '../model/medical_record_model.dart';

abstract class MedicalRecordRepository {
  Future<Either<Failure, MedicalRecordModel>> getMedicalRecord(String token);
  Future<Either<Failure, MedicalRecordPostModel>> postMedicalRecord(
      MedicalRecordModelData data, String token);
}
