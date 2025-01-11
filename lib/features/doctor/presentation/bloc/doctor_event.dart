part of 'doctor_bloc.dart';

// modified : sealed must be abstract
@immutable
sealed class DoctorEvent {}

class DoctorGetDoctorsEvent extends DoctorEvent {
  final String token;

  DoctorGetDoctorsEvent({required this.token});
}

class DoctorSearchDoctorsEvent extends DoctorEvent {
  final String token;
  final String keyword;

  DoctorSearchDoctorsEvent({required this.token, required this.keyword});
}
