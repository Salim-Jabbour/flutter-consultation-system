import 'package:dartz/dartz.dart';

import '../../../core/errors/base_error.dart';
import '../model/doctor_model.dart';

abstract class DoctorRepository {
  Future<Either<Failure, DoctorModel>> getDoctors(String token);
  // Future<Either<Failure, DoctorModel>> getDoctorDetails(String token,int id);

  Future<Either<Failure, DoctorModel>> getDoctorsSearchedByKeyword(
      String token, String keyword);
}
