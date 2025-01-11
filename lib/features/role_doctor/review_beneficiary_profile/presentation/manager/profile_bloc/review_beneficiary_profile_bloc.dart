import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/errors/base_error.dart';
import '../../../models/beneficiary_profile_model.dart';
import '../../../repository/review_beneficiary_profile_repository.dart';

part 'review_beneficiary_profile_event.dart';
part 'review_beneficiary_profile_state.dart';

class ReviewBeneficiaryProfileBloc
    extends Bloc<ReviewBeneficiaryProfileEvent, ReviewBeneficiaryProfileState> {
  final ReviewBeneficiaryProfileRepository _repository;
  ReviewBeneficiaryProfileBloc(this._repository)
      : super(ReviewBeneficiaryProfileInitial()) {
        
    on<ReviewBeneficiaryGetProfileEvent>((event, emit) async {
      emit(ReviewBeneficiaryProfileLoading());
      final successOrFailure =
          await _repository.getProfile(event.token, event.userId);

      successOrFailure.fold(
        (l) => emit(ReviewBeneficiaryProfileFailure(l)),
        (r) {
          emit(ReviewBeneficiaryProfileSuccess(r));
        },
      );
    });
  }
}
