part of 'doctor_bloc.dart';

@immutable
sealed class DoctorState {}

final class DoctorInitial extends DoctorState {}

final class DoctorLoading extends DoctorState {}

final class DoctorGetDoctorsFailed extends DoctorState {
  final Failure failure;

  DoctorGetDoctorsFailed({required this.failure});
}

final class DoctorGetDoctorsSuccess extends DoctorState {
  final DoctorModel doctorModel;

  DoctorGetDoctorsSuccess({required this.doctorModel});
}

final class DoctorSearchDoctorsSuccess extends DoctorState {
  final DoctorModel doctorModel;

  DoctorSearchDoctorsSuccess(this.doctorModel);
}

final class DoctorSearchDoctorsFailure extends DoctorState {
  final Failure failure;

  DoctorSearchDoctorsFailure(this.failure);
}
