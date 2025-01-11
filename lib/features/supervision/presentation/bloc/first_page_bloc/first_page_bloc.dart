// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/errors/base_error.dart';
import '../../../../medicine_calendar/models/medicine_model.dart';
import '../../../model/notification_reminder_model.dart';
import '../../../model/supervision_model.dart';
import '../../../repository/supervision_repository.dart';

part 'first_page_event.dart';
part 'first_page_state.dart';

class FirstPageBlocBloc extends Bloc<FirstPageBlocEvent, FirstPageBlocState> {
  final SupervisionRepository _supervisionRepository;
  FirstPageBlocBloc(this._supervisionRepository)
      : super(FirstPageBlocInitial()) {
    // first tab
    on<FirstTabEvent>((event, emit) async {
      emit(FirstPageLoading());
      final successOrFailure = await _supervisionRepository
          .getApprovedSupervisionBySupervisorFirstTab(event.token);
      successOrFailure.fold(
        (error) => emit(FirstPageFailure(error)),
        (supervisionModel) {
          emit(FirstPageSuccess(supervisionModel));
        },
      );
    });

// delete supervision (can go three ways: 1. first tab 2. second tab 3. inside bell)
    on<DeleteSupervisionEvent>((event, emit) async {
      emit(FirstPageLoading());
      final successOrFailure = await _supervisionRepository.deleteSupervision(
          event.supervisionId, event.token);
      successOrFailure.fold(
        (error) => emit(SupervisionDeleteFailure(error)),
        (supervisionMsg) {
          emit(SupervisionDeleteSuccess(supervisionMsg));
          emit(FirstPageBlocInitial());
        },
      );
    });

    // todays medicine
    on<TodaysMedicineEvent>((event, emit) async {
      emit(FirstPageLoading());
      final successOrFailure = await _supervisionRepository
          .getTodaysSupervisedMedicines(event.token, event.supervisedId);
      successOrFailure.fold(
        (error) => emit(TodaysMedicineSupervisedFailure(error)),
        (todaysMedicines) {
          emit(TodaysMedicineSupervisedSuccess(todaysMedicines));
        },
      );
    });

    // send notification
    on<SendNotificationToSupervisedEvent>((event, emit) async {
      emit(SendNotificationLoading());
      final successOrFailure =
          await _supervisionRepository.sendNotificationToSupervised(
              event.token, event.supervisedId, event.name, event.time);
      successOrFailure.fold(
        (error) => emit(SendNotificationToSupervisedFailure(error)),
        (sent) {
          emit(SendNotificationToSupervisedSuccess(sent));
        },
      );
    });
  }
}
