part of 'doctor_consultation_bloc.dart';

// modified : sealed must be abstract
@immutable
sealed class DoctorConsultationEvent {}

class GetDoctorConsultationsPage extends DoctorConsultationEvent {
  final int page;

  GetDoctorConsultationsPage({this.page = 0});
}
