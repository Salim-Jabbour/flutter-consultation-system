part of 'review_beneficiary_profile_bloc.dart';

sealed class ReviewBeneficiaryProfileEvent extends Equatable {
  const ReviewBeneficiaryProfileEvent();

  @override
  List<Object> get props => [];
}

class ReviewBeneficiaryGetProfileEvent extends ReviewBeneficiaryProfileEvent {
  final String token;
  final String userId;

  const ReviewBeneficiaryGetProfileEvent(
      {required this.token, required this.userId});
}
