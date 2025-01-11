import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failure.dart';
import '../../../repository/home_repository.dart';

part 'add_post_event.dart';
part 'add_post_state.dart';

class AddPostBloc extends Bloc<AddPostEvent, AddPostState> {
  final HomeRepository _homeRepository;
  AddPostBloc(this._homeRepository) : super(AddPostInitial()) {
    on<AddGetPostEvent>((event, emit) async {
      emit(AddPostLoading());

      final successOrFailure = await _homeRepository.addPost(
        event.token,
        event.image,
        event.description,
      );

      successOrFailure.fold(
        (l) => emit(AddPostFailure(l)),
        (r) {
          emit(AddPostSuccess(r));
          // emit(DoctorProfileInitial());
        },
      );
    });
  }
}
