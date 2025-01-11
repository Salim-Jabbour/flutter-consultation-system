import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/errors/base_error.dart';
import '../../../models/doctor_profile_model.dart';
import '../../../models/doctor_specialization_model.dart';
import '../../../repository/doctor_profile_repository.dart';

part 'doctor_profile_event.dart';
part 'doctor_profile_state.dart';

class DoctorProfileBloc extends Bloc<DoctorProfileEvent, DoctorProfileState> {
  final DoctorProfileRepository _repository;
  DoctorProfileBloc(this._repository) : super(DoctorProfileInitial()) {
    on<DoctorGetProfileEvent>((event, emit) async {
      emit(DoctorProfileLoading());
      final successOrFailure =
          await _repository.getProfile(event.token, event.doctorId);

      successOrFailure.fold(
        (l) => emit(DoctorGetProfileFailure(l)),
        (r) {
          emit(DoctorGetProfileSuccess(r));
        },
      );
    });

    on<DoctorUpdateProfileEvent>((event, emit) async {
      emit(DoctorProfileLoading());

      final successOrFailure = await _repository.updateDoctorProfile(
        event.token,
        event.data,
        event.profileImg,
      );

      successOrFailure.fold(
        (l) => emit(DoctorUpdateProfileFailure(l)),
        (r) {
          emit(DoctorUpdateProfileSuccess(r));
          // emit(DoctorProfileInitial());
        },
      );
    });

    on<DoctorProfileChangeProfileImage>((event, emit) {
      profileImage = event.profileImg;
    });

    on<DoctorProfileGetSpecializationsEvent>((event, emit) async {
      emit(DoctorProfileLoading());

      final successOrFailure = await _repository.getSpecializations(
        event.token,
      );

      successOrFailure.fold(
        (l) => emit(DoctorProfileSpecializationFailure(l)),
        (r) {
          emit(DoctorProfileSpecializationSuccess(r));
          // emit(DoctorProfileInitial());
        },
      );
    });

    on<DoctorProfileChangeDetailsModel>((event, emit) {
      model = event.model;
    });
  }

  File? profileImage;

  DoctorProfileDetailsModel? model;
}
