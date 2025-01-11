part of 'medicine_calendar_bloc.dart';

// modified : sealed must be abstract
@immutable
sealed class MedicineCalendarEvent {}

class GetTodaysMedicinesEvent extends MedicineCalendarEvent {
  final String token, supervisedId;

  GetTodaysMedicinesEvent(this.token, this.supervisedId);
}
