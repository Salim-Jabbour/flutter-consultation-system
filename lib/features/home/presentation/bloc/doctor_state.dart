part of 'doctor_cubit.dart';

@immutable
sealed class DoctorState {}

final class DoctorInitial extends DoctorState {}

final class DoctorsLoading extends DoctorState {}

final class DoctorsLoaded extends DoctorState {
  final int nextPage;

  DoctorsLoaded(this.nextPage);
}

final class DoctorsFailure extends DoctorState {
  final String errMessage;

  DoctorsFailure(this.errMessage);
}

final class DoctorsReachMax extends DoctorState {}