import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/errors/base_error.dart';
import '../../../models/beneficiary_consultation_model.dart';
import '../../../repository/review_beneficiary_profile_repository.dart';

part 'beneficiary_consultation_event.dart';
part 'beneficiary_consultation_state.dart';

class BeneficiaryConsultationBloc
    extends Bloc<BeneficiaryConsultationEvent, BeneficiaryConsultationState> {
  final ReviewBeneficiaryProfileRepository _repository;

  BeneficiaryConsultationBloc(this._repository)
      : super(BeneficiaryConsultationInitial()) {
    on<BeneficiaryGetConsultationEvent>((event, emit) async {
      if (event.isInitial) {
        emit(BeneficiaryConsultationLoading());
      }
      if (!event.isInitial) {
        emit(BeneficiaryConsultationPageableLoading());
      }
      final successOrFailure = await _repository.getBeneficaryConsultation(
        token: event.token,
        userId: event.userId,
        pageNumber: event.page,
      );

      successOrFailure.fold(
        (l) => emit(BeneficiaryConsultationFailure(l)),
        (r) {
          emit(BeneficiaryConsultationSuccess(r));
        },
      );
    });
  }
}
