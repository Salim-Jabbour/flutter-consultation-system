import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../../core/errors/base_error.dart';
import '../../../../../../core/resource/string_manager.dart';
import '../../../../../medical_record/model/medical_record_model.dart';
import '../../../../../medicine_calendar/models/medicine_model.dart';
import '../../../models/beneficiary_consultation_model.dart';
import '../../../models/beneficiary_profile_model.dart';

abstract class ReviewBeneficiaryProfileRemoteDataSource {
  // main
  Future<Either<Failure, BeneficiaryProfileModel>> getProfile(
      String token, String userId);

// beneficiary medical record
  Future<Either<Failure, MedicalRecordModel>> getBeneficaryMedicalRecord(
      String token, String userId);

  // beneficiary consultation page
  Future<Either<Failure, BeneficiaryConsultationModel>>
      getBeneficaryConsultation(
          {required String token,
          required String userId,
          required int pageNumber});

  Future<Either<Failure, MedicineModel>> getBeneficiaryMedicines(
      String token, String beneficiaryId);
}

class ReviewBeneficiaryProfileRemoteDataSourceImpl
    extends ReviewBeneficiaryProfileRemoteDataSource {
  final Dio dioClient;

  ReviewBeneficiaryProfileRemoteDataSourceImpl(this.dioClient);
  @override
  Future<Either<Failure, BeneficiaryProfileModel>> getProfile(
      String token, String userId) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response = await dioClient.get("/api/user/information/$userId");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(BeneficiaryProfileModel.fromJson(
            response.data as Map<String, dynamic>));
      }
    } on DioException catch (e) {
      if (e.response == null) {
        return left(NoInternetFailure());
      }
      if (e.response!.data['message'] != null) {
        return left(Failure(message: e.response!.data['message'].toString()));
      } else {
        return Left(
          Failure(message: StringManager.sthWrong.tr()),
        );
      }
    }
    return Left(ServerFailure());
  }

  @override
  Future<Either<Failure, MedicalRecordModel>> getBeneficaryMedicalRecord(
      String token, String userId) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response = await dioClient.get("/api/medical_record/$userId");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(
            MedicalRecordModel.fromJson(response.data as Map<String, dynamic>));
      }
    } on DioException catch (e) {
      if (e.response == null) {
        return left(NoInternetFailure());
      }
      if (e.response!.data['message'] != null) {
        return left(Failure(message: e.response!.data['message'].toString()));
      } else {
        return Left(
          Failure(message: StringManager.sthWrong.tr()),
        );
      }
    }
    return Left(ServerFailure());
  }

  @override
  Future<Either<Failure, BeneficiaryConsultationModel>>
      getBeneficaryConsultation(
          {required String token,
          required String userId,
          required int pageNumber}) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response = await dioClient.get(
          '/api/consultation/getBeneficiaryAnsweredConsultations/$userId',
          queryParameters: {
            "page": "$pageNumber",
          });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(BeneficiaryConsultationModel.fromJson(
            response.data as Map<String, dynamic>));
      }
    } on DioException catch (e) {
      if (e.response == null) {
        return left(NoInternetFailure());
      }
      if (e.response!.data['message'] != null) {
        return left(Failure(message: e.response!.data['message'].toString()));
      } else {
        return Left(
          Failure(message: StringManager.sthWrong.tr()),
        );
      }
    }
    return Left(ServerFailure());
  }

  @override
  Future<Either<Failure, MedicineModel>> getBeneficiaryMedicines(
      String token, String beneficiaryId) async {
    print(token);
    print("******************");
    print(beneficiaryId);

    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response =
          await dioClient.get('/api/medicine/beneficiary/$beneficiaryId');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(
            MedicineModel.fromJson(response.data as Map<String, dynamic>));
      }
    } on DioException catch (e) {
      if (e.response == null) {
        return left(NoInternetFailure());
      }
      if (e.response!.data['message'] != null) {
        return left(Failure(message: e.response!.data['message'].toString()));
      } else {
        return Left(
          Failure(message: StringManager.sthWrong.tr()),
        );
      }
    }
    return Left(ServerFailure());
  }
}
