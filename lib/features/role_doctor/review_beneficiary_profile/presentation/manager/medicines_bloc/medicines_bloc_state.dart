part of 'medicines_bloc_bloc.dart';

sealed class MedicinesBlocState extends Equatable {
  const MedicinesBlocState();
  
  @override
  List<Object> get props => [];
}

final class MedicinesBlocInitial extends MedicinesBlocState {}

final class MedicinesBlocLoading extends MedicinesBlocState {}



final class MedicinesSuccess extends MedicinesBlocState {
  final MedicineModel model;

  const MedicinesSuccess(this.model);
}

final class MedicinesFailure extends MedicinesBlocState {
  final Failure failure;

  const MedicinesFailure(this.failure);
}