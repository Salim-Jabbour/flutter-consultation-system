import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/errors/base_error.dart';
import '../../../model/supervision_model.dart';
import '../../../repository/supervision_repository.dart';

part 'bell_event.dart';
part 'bell_state.dart';

class BellBloc extends Bloc<BellEvent, BellState> {
  final SupervisionRepository _supervisionRepository;

  BellBloc(this._supervisionRepository) : super(BellInitial()) {
    // inside bell
    on<InsideBellEvent>((event, emit) async {
      emit(BellLoading());
      final successOrFailure = await _supervisionRepository
          .viewSupervisionRequestInsideBell(event.token);
      successOrFailure.fold(
        (error) => emit(SupervisionInsideBellFailure(error)),
        (supervisionModel) {
          emit(SupervisionInsideBellSuccess(supervisionModel));
        },
      );
    });

// delete supervision (can go three ways: 1. first tab 2. second tab 3. inside bell)
    on<DeleteSupervisionEvent>((event, emit) async {
      emit(BellLoading());
      final successOrFailure = await _supervisionRepository.deleteSupervision(
          event.supervisionId, event.token);
      successOrFailure.fold(
        (error) => emit(SupervisionDeleteFailure(error)),
        (supervisionMsg) {
          emit(SupervisionDeleteSuccess(supervisionMsg));
          emit(BellInitial());
        },
      );
    });
// inside bell by pressing check hence approve
    on<ApproveSupervisionEvent>((event, emit) async {
      emit(BellLoading());
      final successOrFailure = await _supervisionRepository.approveSupervision(
          event.supervisionId, event.token);
      successOrFailure.fold(
        (error) => emit(SupervisionApproveFailure(error)),
        (supervisionMsg) {
          emit(SupervisionApproveSuccess(supervisionMsg));
          emit(BellInitial());
        },
      );
    });
  }
}
