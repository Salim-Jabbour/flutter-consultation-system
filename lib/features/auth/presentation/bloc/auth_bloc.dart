import 'package:akemha/core/utils/dbg_print.dart';
import 'package:akemha/core/utils/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/base_error.dart';
import '../../models/register_response.dart';
import '../../models/user_model.dart';
import '../../repository/auth_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  
  AuthBloc(this._authRepository) : super(AuthInitial()) {
    dbg("Auth bloc");
    on<AuthRegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final successOrFailure = await _authRepository.postRegistration(
          name: event.name,
          phone: event.phone,
          password: event.password,
          confirmPassword: event.confirmPassword,
          birthDate: event.birthDate,
          gender: event.gender,
        );
        successOrFailure.fold((error) {
          dbg(error);
          emit(AuthSignUpFailed(faliuer: error));
        }, (registerModel) async {
          emit(AuthSignUpSuccess(user: registerModel));
          // TODO: no token only user Id
          userId = await _authRepository.getUserId();
          // role = await _authRepository.getUserRole();
          // userName = await _authRepository.getUserName();
          // investmentOption = _authRepository.getInvestmentOption();
        });
      } catch (e) {
        rethrow;
      }
    });

    on<AuthLoginEvent>((event, emit) async {
      emit(AuthLoading());

      final successOrFailure = await _authRepository.postLogin(
        email: event.email,
        password: event.password,
        deviceToken: event.deviceToken,
      );

      successOrFailure.fold((error) {
        emit(AuthLoginFailed(faliuer: error));
      }, (loginModel) async {
        emit(AuthLoginSuccess(user: loginModel));
        token = await _authRepository.getToken();
        role = await _authRepository.getUserRole();
        userEmail = await _authRepository.getUserName();
        userId = await _authRepository.getUserId();
      });
    });

    on<AuthLogoutRequested>((event, emit) async {
      emit(AuthLoading());

      final successOrFailure = await _authRepository.logout(event.token);
      successOrFailure.fold((error) {
        emit(AuthLogoutFailed(failure: error));
      }, (isLoggedOut) {
        ApiService.token = null;
        ApiService.userName = null;
        ApiService.userId = null;
        ApiService.userRole = null;
        token = null;
        userEmail = null;
        userId = null;
        role = null;
        emit(AuthLogoutSuccess());
      });
    });
    on<AuthChangePasswordRequested>((event, emit) async {
      emit(AuthLoading());

      final successOrFailure = await _authRepository.changePassword(
        oldPassword: event.oldPassword,
        newPassword: event.newPassword,
      );
      successOrFailure.fold((error) {
        emit(AuthChangePasswordFailed(failure: error));
      }, (isLoggedOut) {
        ApiService.token = null;
        ApiService.userName = null;
        ApiService.userId = null;
        ApiService.userRole = null;
        token = null;
        userEmail = null;
        userId = null;
        role = null;
        emit(AuthChangePasswordSuccess());
      });
    });

    // on<AuthGetUserLocalInfo>((event, emit) async {
    //   token = await _authRepository.getToken();
    //   // role = await _authRepository.getUserRole();
    //   // userName = await _authRepository.getUserName();
    //   // investmentOption = _authRepository.getInvestmentOption();
    // });

    on<AuthVerify>((event, emit) async {
      dbg("AuthVerify bloc");
      emit(AuthLoading());
      final successOrFailure =
          await _authRepository.verifyUser(event.code, event.deviceToken);
      successOrFailure.fold((error) {
        dbg(error);
        emit(AuthLoginFailed(faliuer: error));
      }, (user) async {
        emit(AuthLoginSuccess(user: user));
        token = await _authRepository.getToken();
        role = await _authRepository.getUserRole();
        userEmail = await _authRepository.getUserName();
        userId = await _authRepository.getUserId();

        // investmentOption = _authRepository.getInvestmentOption();
      });
    });
  }

  String? token;
  String? role;
  String? userEmail;
  String? userId;
}
