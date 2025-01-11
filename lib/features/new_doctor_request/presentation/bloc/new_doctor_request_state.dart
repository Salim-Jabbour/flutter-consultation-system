part of 'new_doctor_request_bloc.dart';

sealed class NewDoctorRequestState extends Equatable {
  const NewDoctorRequestState();

  @override
  List<Object> get props => [];
}

final class NewDoctorRequestInitial extends NewDoctorRequestState {}

final class NewDoctorRequestLoading extends NewDoctorRequestState {}

final class NewDoctorRequestSuccess extends NewDoctorRequestState {
  final String message;

  const NewDoctorRequestSuccess(this.message);
}

final class NewDoctorRequestFailure extends NewDoctorRequestState {
  final Failure failure;

  const NewDoctorRequestFailure(this.failure);
}

final class DoctorProfileSpecializationSuccess extends NewDoctorRequestState {
  final DoctorSpecializationModel model;

  const DoctorProfileSpecializationSuccess(this.model);
}

final class DoctorProfileSpecializationFailure extends NewDoctorRequestState {
  final Failure failure;

  const DoctorProfileSpecializationFailure(this.failure);
}
