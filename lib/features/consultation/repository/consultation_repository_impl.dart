// ignore_for_file: unused_field

import 'package:akemha/core/errors/failure.dart';
import 'package:akemha/core/utils/dbg_print.dart';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/network/network_info.dart';
import '../data/datasource/local/consultation_local_data_source.dart';
import '../data/datasource/remote/consultation_remote_data_source.dart';
import '../models/Consultation.dart';
import '../models/specialization.dart';

abstract class ConsultationRepository {
  Future<Either<Failure, List<Consultation>>> fetchConsultationsPage(
      {int pageNumber = 0, required int id});

  Future<Either<Failure, List<Specialization>>> fetchSpecializations();

  Future<Either<Failure, List<Consultation>>> fetchDoctorConsultationsPage(
      {int pageNumber = 0});

  Future<Either<Failure, bool>> answerConsultation(
      {required int consultationId, required String answer});

  Future<Either<Failure, void>> rateConsultation(
      {required num rate, required int id});

  Future<Either<Failure, List<Consultation>>> searchConsultations(
      {required String searchText,int page=0});

  Future<Either<Failure, void>> requestConsultation({
    required List<String> images,
    required String specializationId,
    required String title,
    required String description,
    required String consultationType,
  });
}

class ConsultationRepositoryImpl extends ConsultationRepository {
  final ConsultationLocalDataSource _consultationLocalDataSource;
  final ConsultationRemoteDataSource _consultationRemoteDataSource;
  final NetworkInfo _networkInfo;

  ConsultationRepositoryImpl(
    this._consultationRemoteDataSource,
    this._consultationLocalDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, List<Consultation>>> fetchConsultationsPage(
      {int pageNumber = 0, required int id}) async {
    dbg('iddd $id');
    dbg('pageNumber $pageNumber');
    List<Consultation> consultationsList;
    try {
      consultationsList = await _consultationRemoteDataSource
          .fetchConsultationsPage(pageNumber: pageNumber, id: id);
      return right(consultationsList);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Specialization>>> fetchSpecializations() async {
    List<Specialization> specializationsList;
    try {
      specializationsList =
          await _consultationRemoteDataSource.fetchSpecializations();
      return right(specializationsList);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> requestConsultation({
    required List<String> images,
    required String specializationId,
    required String title,
    required String description,
    required String consultationType,
  }) async {
    try {
      await _consultationRemoteDataSource.requestConsultation(
        images: images,
        specializationId: specializationId,
        title: title,
        description: description,
        consultationType: consultationType,
      );
      return right(null);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Consultation>>> fetchDoctorConsultationsPage(
      {int pageNumber = 0}) async {
    List<Consultation> doctorConsultationsList;
    try {
      doctorConsultationsList = await _consultationRemoteDataSource
          .fetchDoctorConsultationsPage(pageNumber: pageNumber);
      return right(doctorConsultationsList);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> answerConsultation(
      {required int consultationId, required String answer}) async {
    try {
      await _consultationRemoteDataSource.answerConsultation(
          consultationId: consultationId, answer: answer);
      return right(true);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> rateConsultation(
      {required num rate, required int id}) async {
    try {
      await _consultationRemoteDataSource.rateConsultation(
        rate: rate,
        id: id,
      );
      return right("");
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Consultation>>> searchConsultations(
      {required String searchText,int page=0}) async {
    List<Consultation> consultationsList;
    try {
      consultationsList = await _consultationRemoteDataSource
          .searchConsultations(searchText: searchText,page: page);
      return right(consultationsList);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
