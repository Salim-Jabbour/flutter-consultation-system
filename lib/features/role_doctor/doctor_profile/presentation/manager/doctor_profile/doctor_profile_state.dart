part of 'doctor_profile_bloc.dart';

@immutable
sealed class DoctorProfileState extends Equatable {
  const DoctorProfileState();

  @override
  List<Object> get props => [];
}

final class DoctorProfileInitial extends DoctorProfileState {}

final class DoctorProfileLoading extends DoctorProfileState {}

final class DoctorGetProfileSuccess extends DoctorProfileState {
  final DoctorProfileModel model;

  const DoctorGetProfileSuccess(this.model);
}

final class DoctorGetProfileFailure extends DoctorProfileState {
  final Failure failure;

  const DoctorGetProfileFailure(this.failure);
}

final class DoctorUpdateProfileSuccess extends DoctorProfileState {
  final String msg;

  const DoctorUpdateProfileSuccess(this.msg);
}

final class DoctorUpdateProfileFailure extends DoctorProfileState {
  final Failure failure;

  const DoctorUpdateProfileFailure(this.failure);
}

final class DoctorProfileSpecializationSuccess extends DoctorProfileState {
  final DoctorSpecializationModel model;

  const DoctorProfileSpecializationSuccess(this.model);
}

final class DoctorProfileSpecializationFailure extends DoctorProfileState {
  final Failure failure;

  const DoctorProfileSpecializationFailure(this.failure);
}
