part of 'beneficiary_consultation_bloc.dart';

sealed class BeneficiaryConsultationEvent extends Equatable {
  const BeneficiaryConsultationEvent();

  @override
  List<Object> get props => [];
}

class BeneficiaryGetConsultationEvent extends BeneficiaryConsultationEvent {
  final String token;
  final String userId;
  final int page;
  final bool isInitial;

  const BeneficiaryGetConsultationEvent({
    required this.token,
    required this.userId,
    required this.page,
    required this.isInitial,
  });
}
