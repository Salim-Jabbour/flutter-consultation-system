part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String phone;
  final String password;
  final String confirmPassword;
  final DateTime birthDate;
  final String gender;

  AuthRegisterRequested({
    required this.name,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    required this.birthDate,
    required this.gender,
  });
}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;
  final String deviceToken;

  AuthLoginEvent({
    required this.email,
    required this.password,
    required this.deviceToken,
  });
}

class AuthLogoutRequested extends AuthEvent {
  final String token;

  AuthLogoutRequested(this.token);
}

class AuthChangePasswordRequested extends AuthEvent {
  final String oldPassword;
  final String newPassword;

  AuthChangePasswordRequested({required this.oldPassword, required this.newPassword});
}

class AuthGetUserLocalInfo extends AuthEvent {}

class AuthVerify extends AuthEvent {
  final String code;
  final String deviceToken;

  AuthVerify({required this.code, required this.deviceToken});
}
