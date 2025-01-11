part of 'doctor_consultations_bloc.dart';

sealed class DoctorConsultationsEvent extends Equatable {
  const DoctorConsultationsEvent();

  @override
  List<Object> get props => [];
}

class DoctorGetConsultationsEvent extends DoctorConsultationsEvent {
  final String token;
  final int page;
  final bool isInitial;

  const DoctorGetConsultationsEvent(this.token, this.page, this.isInitial);
}

class DoctorChangeStatusEvent extends DoctorConsultationsEvent {
  final String token, consultationId;
  final bool status;

  const DoctorChangeStatusEvent(this.token, this.consultationId, this.status);
}
