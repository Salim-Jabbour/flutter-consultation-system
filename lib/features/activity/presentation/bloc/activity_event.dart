part of 'activity_bloc.dart';

// modified : sealed must be abstract
@immutable
sealed class ActivityEvent {}

class GetActivitiesPage extends ActivityEvent {
  final int page;

  GetActivitiesPage({this.page = 0});
}
