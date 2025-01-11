// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/errors/base_error.dart';
import '../../../model/supervision_model.dart';
import '../../../repository/supervision_repository.dart';

part 'floating_event.dart';
part 'floating_state.dart';

class FloatingBloc extends Bloc<FloatingEvent, FloatingState> {
  final SupervisionRepository _supervisionRepository;

  FloatingBloc(this._supervisionRepository) : super(FloatingInitial()) {
    // sending request in first tab floating action button
    on<SendSupervisionRequestEvent>((event, emit) async {
      emit(FloatingLoading());
      final successOrFailure = await _supervisionRepository
          .sendSupervisionRequestInsideFloatingActionButton(
              event.supervisedId, event.token);
      successOrFailure.fold(
        (error) => emit(SupervisionRequestFailure(error)),
        (supervisionMsg) {
          emit(SupervisionRequestSuccess(supervisionMsg));
          emit(FloatingInitial());
        },
      );
    });
// get random 10 users
    on<RandomTenEvent>((event, emit) async {
      emit(FloatingLoading());
      final successOrFailure =
          await _supervisionRepository.getRandomTenUser(event.token);
      successOrFailure.fold(
        (error) => emit(SupervisionRandomTenFailure(error)),
        (usersList) {
          emit(SupervisionRandomTenSuccess(usersList));
        },
      );
    });
// get 10 users after search
    on<SearchedUsersEvent>((event, emit) async {
      emit(FloatingLoading());
      final successOrFailure = await _supervisionRepository
          .getTenUserSearchedByKeyword(event.token, event.keyword);
      successOrFailure.fold(
        (error) => emit(SupervisionSearchedTenFailure(error)),
        (usersList) {
          emit(SupervisionSearchedTenSuccess(usersList));
        },
      );
    });
  }
}
