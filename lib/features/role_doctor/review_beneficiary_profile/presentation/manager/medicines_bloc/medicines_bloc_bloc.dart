import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/errors/base_error.dart';
import '../../../../../medicine_calendar/models/medicine_model.dart';
import '../../../repository/review_beneficiary_profile_repository.dart';

part 'medicines_bloc_event.dart';
part 'medicines_bloc_state.dart';

class MedicinesBlocBloc extends Bloc<MedicinesBlocEvent, MedicinesBlocState> {
  final ReviewBeneficiaryProfileRepository _beneficiaryProfileRepository;

  MedicinesBlocBloc(this._beneficiaryProfileRepository)
      : super(MedicinesBlocInitial()) {
    on<GetMedicinesEvent>((event, emit) async {
      emit(MedicinesBlocLoading());

      final successOrFailure = await _beneficiaryProfileRepository
          .getBeneficiaryMedicines(event.token, event.beneficiaryId);
      successOrFailure.fold(
        (error) {
          emit(MedicinesFailure(error));
        },
        (medicineModel) {
          emit(MedicinesSuccess(medicineModel));
        },
      );
    });
  }
}
