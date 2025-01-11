part of 'doctor_profile_bloc.dart';

sealed class DoctorProfileEvent extends Equatable {
  const DoctorProfileEvent();

  @override
  List<Object> get props => [];
}

class DoctorGetProfileEvent extends DoctorProfileEvent {
  final String token;
  final String doctorId;

  const DoctorGetProfileEvent(this.token, this.doctorId);
}

class DoctorUpdateProfileEvent extends DoctorProfileEvent {
  final String token;
  final DoctorProfileDetailsModel data;
  final File? profileImg;

  const DoctorUpdateProfileEvent(
      {required this.token, required this.data, required this.profileImg});
}

class DoctorProfileChangeProfileImage extends DoctorProfileEvent {
  final File? profileImg;

  const DoctorProfileChangeProfileImage(this.profileImg);
}

class DoctorProfileGetSpecializationsEvent extends DoctorProfileEvent {
  final String token;

  const DoctorProfileGetSpecializationsEvent(this.token);
}

class DoctorProfileChangeDetailsModel extends DoctorProfileEvent {
  final DoctorProfileDetailsModel? model;

  const DoctorProfileChangeDetailsModel(this.model);
}
