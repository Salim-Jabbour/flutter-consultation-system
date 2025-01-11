import 'package:dartz/dartz.dart';

import '../../../../../../core/errors/base_error.dart';
import '../../../medical_record/model/medical_record_model.dart';
import '../../../medicine_calendar/models/medicine_model.dart';
import '../models/beneficiary_consultation_model.dart';
import '../models/beneficiary_profile_model.dart';

abstract class ReviewBeneficiaryProfileRepository {
  Future<Either<Failure, BeneficiaryProfileModel>> getProfile(
      String token, String userId);

  Future<Either<Failure, MedicalRecordModel>> getBeneficaryMedicalRecord(
      String token, String userId);

  Future<Either<Failure, BeneficiaryConsultationModel>>
      getBeneficaryConsultation(
          {required String token,
          required String userId,
          required int pageNumber});

  Future<Either<Failure, MedicineModel>> getBeneficiaryMedicines(
      String token, String beneficiaryId);
}
