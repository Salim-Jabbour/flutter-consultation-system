import 'package:akemha/core/errors/failure.dart';

import 'package:akemha/features/consultation/models/ConsultationModel.dart';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../core/network/network_info.dart';
import '../../consultation/models/Consultation.dart';
import '../data/datasource/local/consultation_local_data_source.dart';
import '../data/datasource/remote/consultation_remote_data_source.dart';
import 'consultation_repository.dart';

class ConsultationLogRepositoryImpl extends ConsultationLogRepository {
  final ConsultationLogLocalDataSource _consultationLogLocalDataSource;
  final ConsultationLogRemoteDataSource _consultationLogRemoteDataSource;
  final NetworkInfo _networkInfo;

  ConsultationLogRepositoryImpl(
    this._consultationLogRemoteDataSource,
    this._consultationLogLocalDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, List<Consultation>>> fetchConsultationsLogPage(
      {int pageNumber = 0}) async {
    List<Consultation>consultationsList;
    try {
      consultationsList =
          await _consultationLogRemoteDataSource.fetchConsultationsLogPage(pageNumber: pageNumber);
      return right(consultationsList);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }  @override
  Future<Either<Failure, List<Consultation>>> fetchMyAnsweredConsultationsPage(
      {int pageNumber = 0}) async {
    List<Consultation>consultationsList;
    try {
      consultationsList =
          await _consultationLogRemoteDataSource.fetchMyAnsweredConsultationsPage(pageNumber: pageNumber);
      return right(consultationsList);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
