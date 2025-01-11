import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/base_error.dart';
import '../../review_beneficiary_profile/models/beneficiary_consultation_model.dart';
import '../models/doctor_post_model.dart';
import '../models/doctor_profile_model.dart';
import '../models/doctor_specialization_model.dart';

abstract class DoctorProfileRepository {
  Future<Either<Failure, DoctorProfileModel>> getProfile(
      String token, String doctorId);

  Future<Either<Failure, bool>> deletePost(String token, String postId);

  Future<Either<Failure, String>> updateDoctorProfile(
    String token,
    DoctorProfileDetailsModel data,
    File? profileImg,
  );

  Future<Either<Failure, BeneficiaryConsultationModel>> getConsultationsLog(
      String token, int pageNumber);

  Future<Either<Failure, DoctorPostModel>> getDoctorsPosts(
      String token, String doctorId, int pageNumber);

  Future<Either<Failure, DoctorSpecializationModel>> getSpecializations(
      String token);

  Future<Either<Failure, bool>> changeChatStatus(
      String token, String consultationId, bool status);
}
