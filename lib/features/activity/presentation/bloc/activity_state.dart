part of 'activity_bloc.dart';

// modified : sealed must be abstract
@immutable
sealed class ActivityState {}

final class ActivityInitial extends ActivityState {}

final class ActivityLoading extends ActivityState {}

final class ActivityLoaded extends ActivityState {
  final List<ActivityModel> activities;
  ActivityLoaded(this.activities);
}

final class ActivityFailure extends ActivityState {
  final String errMessage;

  ActivityFailure(this.errMessage);
}