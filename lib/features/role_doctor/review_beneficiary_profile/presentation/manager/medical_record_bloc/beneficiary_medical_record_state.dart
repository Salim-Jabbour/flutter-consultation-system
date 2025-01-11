part of 'beneficiary_medical_record_bloc.dart';

@immutable
sealed class BeneficiaryMedicalRecordState extends Equatable {
  const BeneficiaryMedicalRecordState();

  @override
  List<Object> get props => [];
}

final class BeneficiaryMedicalRecordInitial
    extends BeneficiaryMedicalRecordState {}

final class BeneficiaryMedicalRecordLoading
    extends BeneficiaryMedicalRecordState {}

final class BeneficiaryMedicalRecordSuccess
    extends BeneficiaryMedicalRecordState {
  final MedicalRecordModel medicalRecordModel;

  const BeneficiaryMedicalRecordSuccess(this.medicalRecordModel);
}

final class BeneficiaryMedicalRecordFailure
    extends BeneficiaryMedicalRecordState {
  final Failure failure;

  const BeneficiaryMedicalRecordFailure(this.failure);
}
