// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/errors/base_error.dart';
import '../../../model/supervision_model.dart';
import '../../../repository/supervision_repository.dart';

part 'second_page_event.dart';
part 'second_page_state.dart';

class SecondPageBloc extends Bloc<SecondPageEvent, SecondPageState> {
  final SupervisionRepository _supervisionRepository;

  SecondPageBloc(this._supervisionRepository) : super(SecondPageInitial()) {
    // second tab
    on<SecondTabEvent>((event, emit) async {
      emit(SecondPageLoading());
      final successOrFailure = await _supervisionRepository
          .getApprovedSupervisionBySupervisedSecondTab(event.token);
      successOrFailure.fold(
        (error) => emit(SupervisionSecondTabFailure(error)),
        (supervisionModel) {
          emit(SupervisionSecondTabSuccess(supervisionModel));
        },
      );
    });
    // delete supervision (can go three ways: 1. first tab 2. second tab 3. inside bell)
    on<DeleteSupervisionEvent>((event, emit) async {
      emit(SecondPageLoading());
      final successOrFailure = await _supervisionRepository.deleteSupervision(
          event.supervisionId, event.token);
      successOrFailure.fold(
        (error) => emit(SupervisionDeleteFailure(error)),
        (supervisionMsg) {
          emit(SupervisionDeleteSuccess(supervisionMsg));
          emit(SecondPageInitial());
        },
      );
    });
  }
}
