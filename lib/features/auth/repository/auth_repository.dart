import 'package:dartz/dartz.dart';
import '../../../core/errors/base_error.dart';
import '../models/register_response.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, RegisterResponse>> postRegistration({
    required String name,
    required String phone,
    required String password,
    required String confirmPassword,
    required DateTime birthDate,
    required String gender,
  });

  Future<Either<Failure, UserModel>> postLogin({
    required String email,
    required String password,
    required String deviceToken,
  });

  Future<Either<Failure, String>> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<Either<Failure, bool>> logout(String token);

  Future<String?> getToken();

  Future<String?> getUserId();

  Future<Either<Failure, UserModel>> verifyUser(
      String code, String deviceToken);

// Future<String?> getUserRole();
  // Future<String?> getUserName();
// int? getInvestmentOption();
  Future<String?> getUserRole();

  Future<String?> getUserName();
}
