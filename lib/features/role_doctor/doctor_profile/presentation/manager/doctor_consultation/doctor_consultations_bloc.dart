import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/errors/base_error.dart';
import '../../../../review_beneficiary_profile/models/beneficiary_consultation_model.dart';
import '../../../repository/doctor_profile_repository.dart';

part 'doctor_consultations_event.dart';
part 'doctor_consultations_state.dart';

class DoctorConsultationsBloc
    extends Bloc<DoctorConsultationsEvent, DoctorConsultationsState> {
  final DoctorProfileRepository _repository;
  DoctorConsultationsBloc(this._repository)
      : super(DoctorConsultationsInitial()) {
    on<DoctorGetConsultationsEvent>((event, emit) async {
      if (event.isInitial) {
        emit(DoctorConsultationsLoading());
      }
      if (!event.isInitial) {
        emit(DoctorConsultationsPageableLoading());
      }
      final successOrFailure = await _repository.getConsultationsLog(
        event.token,
        event.page,
      );

      successOrFailure.fold(
        (l) => emit(DoctorGetConsultationsFailure(l)),
        (r) {
          emit(DoctorGetConsultationsSuccess(r));
        },
      );
    });

    on<DoctorChangeStatusEvent>((event, emit) async {
      emit(DoctorConsultationsLoading());

      final successOrFailure = await _repository.changeChatStatus(
        event.token,
        event.consultationId,
        event.status,
      );

      successOrFailure.fold(
        (l) => emit(DoctorChangeStatusFailure(l)),
        (r) {
          emit(DoctorChangeStatusSuccess(r));
        },
      );
    });
  }
}
