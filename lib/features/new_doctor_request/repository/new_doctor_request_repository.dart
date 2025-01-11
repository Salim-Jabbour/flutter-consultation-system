import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../core/errors/base_error.dart';
import '../../role_doctor/doctor_profile/models/doctor_specialization_model.dart';

abstract class NewDoctorRequestRepository {
  Future<Either<Failure, String>> addRequest(
    File? file,
    String aboutMe,
    String emailAddress,
    String name,
    String deviceToken,
    String gender,
    String specializationId,
  );

  Future<Either<Failure, DoctorSpecializationModel>> getSpecializations();
}
