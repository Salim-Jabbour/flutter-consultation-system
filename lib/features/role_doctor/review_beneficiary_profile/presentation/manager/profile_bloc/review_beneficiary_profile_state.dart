part of 'review_beneficiary_profile_bloc.dart';

@immutable
sealed class ReviewBeneficiaryProfileState extends Equatable {
  const ReviewBeneficiaryProfileState();

  @override
  List<Object> get props => [];
}

final class ReviewBeneficiaryProfileInitial
    extends ReviewBeneficiaryProfileState {}

final class ReviewBeneficiaryProfileLoading
    extends ReviewBeneficiaryProfileState {}

final class ReviewBeneficiaryProfileSuccess
    extends ReviewBeneficiaryProfileState {
  final BeneficiaryProfileModel beneficiaryProfileModel;

  const ReviewBeneficiaryProfileSuccess(this.beneficiaryProfileModel);
}

final class ReviewBeneficiaryProfileFailure
    extends ReviewBeneficiaryProfileState {
  final Failure failure;

  const ReviewBeneficiaryProfileFailure(this.failure);
}
