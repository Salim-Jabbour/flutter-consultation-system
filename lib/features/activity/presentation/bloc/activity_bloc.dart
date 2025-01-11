import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/dbg_print.dart';
import '../../models/activity_model.dart';
import '../../repository/activity_repository.dart';

part 'activity_event.dart';

part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final ActivityRepository _activityRepository;

  ActivityBloc(this._activityRepository)
      : super(ActivityInitial()) {
    on<GetActivitiesPage>((event, emit) async {
      emit(ActivityLoading());
      final result = await _activityRepository.fetchActivitiesPage(
        pageNumber: event.page,
      );
      result.fold((error) {
        emit(ActivityFailure(error.message));
      }, (posts) {
        dbg(posts);
        emit(ActivityLoaded(posts));
      });
    });
  }
}
