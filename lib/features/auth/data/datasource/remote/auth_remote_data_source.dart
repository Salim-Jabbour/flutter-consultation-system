import 'dart:convert';

import 'package:akemha/core/utils/dbg_print.dart';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/errors/base_error.dart';
import '../../../../../core/resource/string_manager.dart';
import '../../../models/register_response.dart';
import '../../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, RegisterResponse>> register({
    required String name,
    required String phone,
    required String password,
    required String confirmPassword,
    required DateTime birthDate,
    required String gender,
  });

  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
    required String deviceToken,
  });
  Future<Either<Failure, String>> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<Either<Failure, bool>> logout({required String token});

  Future<Either<Failure, UserModel>> verifyUser({
    required String code,
    required String userId,
    required String deviceToken,
  });
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final Dio dioClient;

  AuthRemoteDataSourceImpl(this.dioClient);

  @override
  Future<Either<Failure, RegisterResponse>> register({
    required String name,
    required String phone,
    required String password,
    required String confirmPassword,
    required DateTime birthDate,
    required String gender,
  }) async {
    final Response response;
    try {
      // TODO: MODIFY!!
      final formData = jsonEncode({
        'name': name,
        'email': name,
        'phoneNumber': phone,
        'password': password,
        "dob": DateFormat('yyyy-MM-dd').format(birthDate),
        "gender": gender.toUpperCase()
      });
      response = await dioClient.post(
        'api/auth/register',
        //don't forget to replace the end point here
        data: formData,
      );
      dbg(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(RegisterResponse.fromJson(response.data));
      }
    } // modified
    on DioException catch (e) {
      if (e.response == null) {
        dbg("no response");
        return left(NoInternetFailure());
      }
      dbg(e.response?.statusCode);
      dbg(e.response?.data);
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
  Future<Either<Failure, UserModel>> login(
      {required String email,
      required String password,
      required deviceToken}) async {
    final Response response;
    try {
      response = await dioClient.post(
        'api/auth/login',
        data: {
          'email': email,
          'password': password,
          'deviceToken': deviceToken
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(UserModel.fromJson(response.data as Map<String, dynamic>));
      }
    } // modified
    on DioException catch (e) {
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
  Future<Either<Failure, String>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final Response response;
    try {
      response = await dioClient.post(
        'api/user/change-password',
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(response.data['msg']);
      }
    } // modified
    on DioException catch (e) {
      if (e.response == null) {
        return left(NoInternetFailure());
      }
      // dbg("here${e.response!.data}");
      // if ((e.response!.data??{"message":"error has happened"})['message'] != null) {
      //   return left(Failure(message: "error has happened"));
      // } else {
      return Left(
        Failure(message: StringManager.sthWrong.tr()),
      );
      // }
    }
    return Left(ServerFailure());
  }

  @override
  Future<Either<Failure, bool>> logout({required String token}) async {
    final Response response;
    try {
      dbg(' dadsd $token');
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      response = await dioClient.delete('api/auth/logout');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(true);
      }
    } // modified
    on DioException catch (e) {
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
  Future<Either<Failure, UserModel>> verifyUser({
    required String code,
    required String userId,
    required String deviceToken,
  }) async {
    final Response response;
    try {
      response = await dioClient.post('/api/auth/verify_account', data: {
        'userId': userId,
        'code': code,
        'deviceToken': deviceToken,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(UserModel.fromJson(response.data));
      }
    } // modified
    on DioException catch (e) {
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
