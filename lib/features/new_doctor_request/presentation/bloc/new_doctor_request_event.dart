part of 'new_doctor_request_bloc.dart';

sealed class NewDoctorRequestEvent extends Equatable {
  const NewDoctorRequestEvent();

  @override
  List<Object> get props => [];
}

class NewDoctorRequestAddEvent extends NewDoctorRequestEvent {
  final File? file;
  final String aboutMe;
  final String emailAddress;
  final String name;
  final String deviceToken;
  final String gender;
  final String specializationId;

  const NewDoctorRequestAddEvent({
    required this.file,
    required this.aboutMe,
    required this.emailAddress,
    required this.name,
    required this.deviceToken,
    required this.gender,
    required this.specializationId,
  });
}

class DoctorProfileGetSpecializationsEvent extends NewDoctorRequestEvent {
  const DoctorProfileGetSpecializationsEvent();
}
