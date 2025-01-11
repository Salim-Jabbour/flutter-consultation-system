part of 'beneficiary_medical_record_bloc.dart';

sealed class BeneficiaryMedicalRecordEvent extends Equatable {
  const BeneficiaryMedicalRecordEvent();

  @override
  List<Object> get props => [];
}

class BeneficiaryGetMedicalRecordEvent extends BeneficiaryMedicalRecordEvent {
  final String token;
  final String userId;

  const BeneficiaryGetMedicalRecordEvent(
      {required this.token, required this.userId});
}
