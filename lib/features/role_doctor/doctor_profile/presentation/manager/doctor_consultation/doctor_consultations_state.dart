part of 'doctor_consultations_bloc.dart';

@immutable
sealed class DoctorConsultationsState extends Equatable {
  const DoctorConsultationsState();

  @override
  List<Object> get props => [];
}

final class DoctorConsultationsInitial extends DoctorConsultationsState {}

final class DoctorConsultationsLoading extends DoctorConsultationsState {}

final class DoctorConsultationsPageableLoading
    extends DoctorConsultationsState {}

final class DoctorGetConsultationsSuccess extends DoctorConsultationsState {
  final BeneficiaryConsultationModel model;

  const DoctorGetConsultationsSuccess(this.model);
}

final class DoctorGetConsultationsFailure extends DoctorConsultationsState {
  final Failure failure;

  const DoctorGetConsultationsFailure(this.failure);
}

final class DoctorChangeStatusSuccess extends DoctorConsultationsState {
  final bool status;

  const DoctorChangeStatusSuccess(this.status);
}

final class DoctorChangeStatusFailure extends DoctorConsultationsState {
  final Failure failure;

  const DoctorChangeStatusFailure(this.failure);
}
