// ignore_for_file: unused_field

import 'package:akemha/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/network/network_info.dart';
import '../data/datasource/local/personal_info_local_data_source.dart';
import '../data/datasource/remote/personal_info_remote_data_source.dart';
import '../models/personal_info_model.dart';
import 'personal_info_repository.dart';

class PersonalInfoRepositoryImpl extends PersonalInfoRepository {
  final PersonalInfoLocalDataSource _personalInfoLocalDataSource;
  final PersonalInfoRemoteDataSource _personalInfoRemoteDataSource;
  final NetworkInfo _networkInfo;

  PersonalInfoRepositoryImpl(
    this._personalInfoRemoteDataSource,
    this._personalInfoLocalDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, PersonalInfoModel>> getPersonalInfo(
      {required int id}) async {
    PersonalInfoModel personalInfo;
    try {
      personalInfo = await _personalInfoRemoteDataSource.fetchPersonalInfo(
        id: id,
      );
      return right(personalInfo);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PersonalInfoModel>> updatePersonalInfo(
      {String? name,
      String? email,
      String? gender,
      DateTime? dob,
      String? image}) async {
    PersonalInfoModel personalInfo;
    try {
      personalInfo = await _personalInfoRemoteDataSource.updatePersonalInfo(
        name: name,
        email: email,
        gender: gender,
        dob: dob,
        image: image,
      );
      return right(personalInfo);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
