// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/base_error.dart';
import '../../model/doctor_model.dart';
import '../../repository/doctor_repository.dart';

part 'doctor_event.dart';
part 'doctor_state.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  final DoctorRepository _doctorRepository;
  DoctorBloc(this._doctorRepository) : super(DoctorInitial()) {
    on<DoctorGetDoctorsEvent>((event, emit) async {
      emit(DoctorLoading());
      final successOrFailure = await _doctorRepository.getDoctors(event.token);
      successOrFailure.fold(
        (error) {
          emit(DoctorGetDoctorsFailed(failure: error));
        },
        (doctorModel) {
          emit(DoctorGetDoctorsSuccess(doctorModel: doctorModel));
        },
      );
    });

    // search doctors
    on<DoctorSearchDoctorsEvent>((event, emit) async {
      emit(DoctorLoading());
      final successOrFailure = await _doctorRepository
          .getDoctorsSearchedByKeyword(event.token, event.keyword);
      successOrFailure.fold(
        (error) => emit(DoctorSearchDoctorsFailure(error)),
        (doctorsList) {
          emit(DoctorSearchDoctorsSuccess(doctorsList));
        },
      );
    });
  }
}
