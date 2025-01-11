part of 'beneficiary_consultation_bloc.dart';

@immutable
sealed class BeneficiaryConsultationState extends Equatable {
  const BeneficiaryConsultationState();

  @override
  List<Object> get props => [];
}

final class BeneficiaryConsultationInitial
    extends BeneficiaryConsultationState {}

final class BeneficiaryConsultationLoading
    extends BeneficiaryConsultationState {}

final class BeneficiaryConsultationPageableLoading
    extends BeneficiaryConsultationState {}

final class BeneficiaryConsultationSuccess
    extends BeneficiaryConsultationState {
  final BeneficiaryConsultationModel model;

  const BeneficiaryConsultationSuccess(this.model);
}

final class BeneficiaryConsultationFailure
    extends BeneficiaryConsultationState {
  final Failure failure;

  const BeneficiaryConsultationFailure(this.failure);
}
