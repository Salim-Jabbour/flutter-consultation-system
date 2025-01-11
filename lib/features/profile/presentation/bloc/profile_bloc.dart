import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/base_error.dart';
import '../../model/profile_model.dart';
import '../../repository/profile_repository.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _profileRepository;
  Completer<void> profileRefresh = Completer<void>();

  ProfileBloc(this._profileRepository) : super(ProfileInitial()) {
    on<ProfileGetProfileInfoEvent>((event, emit) async {
      profileRefresh = Completer<void>();
      emit(ProfileLoading());
      final successOrFailure =
          await _profileRepository.getProfileInfo(event.token, event.userId);
      if (!profileRefresh.isCompleted) {
        profileRefresh.complete();
      }
      successOrFailure.fold(
        (error) {
          emit(ProfileGetInfoFailed(failure: error));
        },
        (profileModel) {
          emit(ProfileGetInfoSuccess(profileModel: profileModel));
        },
      );
    });
  }
}
