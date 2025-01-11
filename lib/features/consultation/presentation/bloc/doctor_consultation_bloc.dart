import 'dart:async';

import 'package:akemha/features/consultation/repository/consultation_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/Consultation.dart';


part 'doctor_consultation_event.dart';

part 'doctor_consultation_state.dart';

class DoctorConsultationBloc extends Bloc<DoctorConsultationEvent, DoctorConsultationState> {
  final ConsultationRepository _consultationRepository;

  List<Consultation> doctorConsultations = [];

  Completer<void> refreshCompleter = Completer<void>();
  DoctorConsultationBloc(this._consultationRepository) : super(DoctorConsultationInitial()) {
    on<GetDoctorConsultationsPage>((event, emit) async {
      refreshCompleter = Completer<void>();
      emit(DoctorConsultationsLoading());
      final result = await _consultationRepository.fetchDoctorConsultationsPage(
        pageNumber: event.page,
      );
      if (event.page == 0) {
        doctorConsultations = [];
      }
      if (!refreshCompleter.isCompleted) {
        refreshCompleter.complete();
      }
      result.fold((error) {
        emit(DoctorConsultationsFailure(error.message));
      }, (newDoctorConsultations) {
        doctorConsultations.addAll(newDoctorConsultations);
        emit(newDoctorConsultations.length < 10
            ? DoctorConsultationsReachMax()
            : DoctorConsultationsLoaded(event.page + 1));
      });
    });
    // on<ReserveDeviceEvent>((event, emit) async {
    //
    // });
  }
}
