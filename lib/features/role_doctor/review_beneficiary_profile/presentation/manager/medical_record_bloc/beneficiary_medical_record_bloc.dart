import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/errors/base_error.dart';
import '../../../../../medical_record/model/medical_record_model.dart';
import '../../../repository/review_beneficiary_profile_repository.dart';

part 'beneficiary_medical_record_event.dart';
part 'beneficiary_medical_record_state.dart';

class BeneficiaryMedicalRecordBloc
    extends Bloc<BeneficiaryMedicalRecordEvent, BeneficiaryMedicalRecordState> {
  final ReviewBeneficiaryProfileRepository _repository;
  BeneficiaryMedicalRecordBloc(this._repository)
      : super(BeneficiaryMedicalRecordInitial()) {
    on<BeneficiaryGetMedicalRecordEvent>((event, emit) async {
      emit(BeneficiaryMedicalRecordLoading());
      final successOrFailure = await _repository.getBeneficaryMedicalRecord(
          event.token, event.userId);

      successOrFailure.fold(
        (l) => emit(BeneficiaryMedicalRecordFailure(l)),
        (r) {
          emit(BeneficiaryMedicalRecordSuccess(r));
        },
      );
    });
  }
}
