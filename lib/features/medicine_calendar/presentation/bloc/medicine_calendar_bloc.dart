import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/base_error.dart';
import '../../models/medicine_model.dart';
import '../../repository/medicine_calendar_repository.dart';

part 'medicine_calendar_event.dart';

part 'medicine_calendar_state.dart';

class MedicineCalendarBloc
    extends Bloc<MedicineCalendarEvent, MedicineCalendarState> {
  final MedicineCalendarRepository _medicineCalendarRepository;

  MedicineCalendarBloc(this._medicineCalendarRepository)
      : super(MedicineCalendarInitial()) {
    on<GetTodaysMedicinesEvent>((event, emit) async {
      emit(MedicineTodayCalendarLoading());

      final successOrFailure = await _medicineCalendarRepository
          .getTodaysMedicines(event.token, event.supervisedId);
      successOrFailure.fold(
        (error) {
          emit(MedicineTodayCalendarFailure(error));
        },
        (medicineModel) {
          emit(MedicineTodayCalendarSuccess(medicineModel));
        },
      );
    });
  }
}
