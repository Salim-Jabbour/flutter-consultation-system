part of 'medicine_calendar_bloc.dart';

// modified : sealed must be abstract
@immutable
sealed class MedicineCalendarState {}

final class MedicineCalendarInitial extends MedicineCalendarState {}

final class MedicineTodayCalendarLoading extends MedicineCalendarState {}

final class MedicineTodayCalendarSuccess extends MedicineCalendarState {
  final MedicineModel model;

  MedicineTodayCalendarSuccess(this.model);
}

final class MedicineTodayCalendarFailure extends MedicineCalendarState {
  final Failure failure;

  MedicineTodayCalendarFailure(this.failure);
}
