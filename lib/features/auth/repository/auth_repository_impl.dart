import 'package:akemha/core/utils/dbg_print.dart';
import 'package:akemha/core/utils/services/api_service.dart';

import 'package:dartz/dartz.dart';

import '../../../core/errors/base_error.dart';
import '../../../core/errors/execption.dart';
import '../../../core/network/network_info.dart';
import '../data/datasource/local/auth_local_data_source.dart';
import '../data/datasource/remote/auth_remote_data_source.dart';
import '../models/register_response.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthLocalDataSource _authLocalDataSource;
  final AuthRemoteDataSource _authRemoteDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl(
    this._authRemoteDataSource,
    this._authLocalDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, RegisterResponse>> postRegistration({
    required String name,
    required String phone,
    required String password,
    required String confirmPassword,
    required DateTime birthDate,
    required String gender,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _authRemoteDataSource.register(
          name: name,
          phone: phone,
          password: password,
          confirmPassword: confirmPassword,
          birthDate: birthDate,
          gender: gender,
        );

        return addSuccess.fold((failure) {
          return Left(failure);
        }, (registerResponse) async {
          await _authLocalDataSource.setUserId(registerResponse.id);
          ApiService.userId = registerResponse.id;
          // await _authLocalDataSource
          //     .setUserName(registerResponse.data.user.name);

          // await _authLocalDataSource
          //     .setUserRole(registerResponse.data.user.roles.first);
          // _authLocalDataSource.setInvestmentOptine(
          //     registerResponse.data.user.investment_option ?? 0);
          return right(registerResponse);
        });
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, UserModel>> postLogin(
      {required String email,
      required String password,
      required String deviceToken}) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _authRemoteDataSource.login(
            email: email, password: password, deviceToken: deviceToken);

        return addSuccess.fold((failure) {
          return Left(failure);
        }, (loginResponse) async {
          dbg(loginResponse.data.token);
          dbg(loginResponse.data.id);
          await _authLocalDataSource.setUserToken(loginResponse.data.token);
          await _authLocalDataSource.setUserName(loginResponse.data.userEmail);
          await _authLocalDataSource.setUserRole(loginResponse.data.role);
          await _authLocalDataSource.setUserId("${loginResponse.data.id}");
          ApiService.token = loginResponse.data.token;
          ApiService.userId = "${loginResponse.data.id}";
          ApiService.userRole = loginResponse.data.role;
          ApiService.userName = loginResponse.data.userEmail;
          // await _authLocalDataSource.setUserName(loginResponse.data.user.name);
          // await _authLocalDataSource
          //     .setUserRole(loginResponse.data.user.roles.first);
          // _authLocalDataSource.setInvestmentOptine(
          //     loginResponse.data.user.investment_option ?? 0);

          return right(loginResponse);
        });
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logout(String token) async {
    if (await _networkInfo.isConnected) {
      try {
        dbg(" /////////////////////////////////////////////////////// ");

        final addSuccess = await _authRemoteDataSource.logout(token: token);
        return addSuccess.fold((failure) {
          return Left(failure);
        }, (islogoutSuccess) {
          _authLocalDataSource.clearAllUserData();
          return right(islogoutSuccess);
        });
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return left(NoInternetFailure());
    }
  }

  @override
  Future<String?> getUserRole() {
    return _authLocalDataSource.getUserRole();
  }

  // @override
  // int? getInvestmentOption() {
  //   return _authLocalDataSource.getInvestmentOptine();
  // }

  @override
  Future<Either<Failure, UserModel>> verifyUser(
      String code, String deviceToken) async {
    if (await _networkInfo.isConnected) {
      try {
        String? id = await _authLocalDataSource.getUserId();
        if (id == null) {
          dbg("KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK");
          return Left(ServerFailure());
        }
        dbg("AuthVerify REpo");
        final addSuccess = await _authRemoteDataSource.verifyUser(
          code: code,
          userId: id,
          deviceToken: deviceToken,
        );
        dbg("AuthVerify REpo2");
        return addSuccess.fold((failure) {
          return Left(failure);
        }, (verifyResponse) async {
          await _authLocalDataSource.setUserToken(verifyResponse.data.token);
          await _authLocalDataSource.setUserName(verifyResponse.data.userEmail);
          await _authLocalDataSource.setUserRole(verifyResponse.data.role);
          await _authLocalDataSource.setUserId("${verifyResponse.data.id}");
          ApiService.token = verifyResponse.data.token;
          ApiService.userId = "${verifyResponse.data.id}";
          ApiService.userRole = verifyResponse.data.role;
          ApiService.userName = verifyResponse.data.userEmail;
          // await _authLocalDataSource.setUserName(loginResponse.data.user.name);
          // await _authLocalDataSource
          //     .setUserRole(loginResponse.data.user.roles.first);
          // _authLocalDataSource.setInvestmentOptine(
          //     loginResponse.data.user.investment_option ?? 0);
          return right(verifyResponse);
        });
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return left(NoInternetFailure());
    }
  }

  @override
  Future<String?> getToken() async {
    return await _authLocalDataSource.getUserToken();
  }

  @override
  Future<String?> getUserId() async {
    return await _authLocalDataSource.getUserId();
  }

  // @override
  // Future<String?> getUserName() async {
  //   return await _authLocalDataSource.getUserName();
  // }
  @override
  Future<String?> getUserName() async {
    return await _authLocalDataSource.getUserName();
  }

  @override
  Future<Either<Failure, String>> changePassword({required String oldPassword, required String newPassword}) async {

    return await _authRemoteDataSource.changePassword(oldPassword:oldPassword,newPassword:newPassword,);
  }
}
