import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/errors/base_error.dart';
import '../../../models/doctor_post_model.dart';
import '../../../repository/doctor_profile_repository.dart';

part 'doctor_post_event.dart';
part 'doctor_post_state.dart';

class DoctorPostBloc extends Bloc<DoctorPostEvent, DoctorPostState> {
  final DoctorProfileRepository _repository;
  DoctorPostBloc(this._repository) : super(DoctorPostInitial()) {
    on<DoctorGetPostEvent>((event, emit) async {
      if (event.isInitial) {
        emit(DoctorPostLoading());
      }
      if (!event.isInitial) {
        emit(DoctorPostPageableLoading());
      }
      final successOrFailure = await _repository.getDoctorsPosts(
        event.token,
        event.doctorId,
        event.page,
      );

      successOrFailure.fold(
        (l) => emit(DoctorGetPostFailure(l)),
        (r) {
          emit(DoctorGetPostSuccess(r));
        },
      );
    });

    on<DeletePostEvent>((event, emit) async {
      emit(DeletePostLoading());

      final successOrFailure =
          await _repository.deletePost(event.token, event.postId);

      successOrFailure.fold(
        (l) => emit(DeletePostFailure(l)),
        (r) {
          emit(DeletePostSuccess(r));
        },
      );
    });
  }

  List<DoctorPostDetailsModel>? postsList = [];
}
