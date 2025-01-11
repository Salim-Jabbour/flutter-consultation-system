import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';
import '../models/personal_info_model.dart';

abstract class PersonalInfoRepository {
  Future<Either<Failure, PersonalInfoModel>> getPersonalInfo({required int id});

  Future<Either<Failure, PersonalInfoModel>> updatePersonalInfo(
      {String? name, String? email, String? gender, DateTime? dob,String? image});
}
