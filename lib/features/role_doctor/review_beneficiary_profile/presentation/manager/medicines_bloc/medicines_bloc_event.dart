part of 'medicines_bloc_bloc.dart';

sealed class MedicinesBlocEvent extends Equatable {
  const MedicinesBlocEvent();

  @override
  List<Object> get props => [];
}

class GetMedicinesEvent extends MedicinesBlocEvent {
  final String token, beneficiaryId;

  const GetMedicinesEvent(this.token, this.beneficiaryId);
}
