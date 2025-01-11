part of 'doctor_consultation_bloc.dart';

// modified : sealed must be abstract
@immutable
sealed class DoctorConsultationState {}

final class DoctorConsultationInitial extends DoctorConsultationState {}

final class DoctorConsultationsLoading extends DoctorConsultationState {}

final class DoctorConsultationsLoaded extends DoctorConsultationState {
  final int nextPage;

  DoctorConsultationsLoaded(this.nextPage);
}

final class DoctorConsultationsFailure extends DoctorConsultationState {
  final String errMessage;

  DoctorConsultationsFailure(this.errMessage);
}

final class DoctorConsultationsReachMax extends DoctorConsultationState {}
