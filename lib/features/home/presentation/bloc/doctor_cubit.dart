import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../doctor/model/doctor_model.dart';
import '../../repository/home_repository.dart';

part 'doctor_state.dart';

class DoctorCubit extends Cubit<DoctorState> {
  final HomeRepository _homeRepository;

  DoctorCubit(this._homeRepository) : super(DoctorInitial());
  List<DoctorDataModel> doctors = [];

  Future<void> getDoctorsPage([int page = 0]) async {
    if (page == 0) {
      doctors = [];
    }
    emit(DoctorsLoading());
    final result = await _homeRepository.fetchDoctorsPage(
      pageNumber: page,
    );
    result.fold((error) {
      emit(DoctorsFailure(error.message));
    }, (newDoctors) {
      doctors.addAll(newDoctors);
      emit(
          newDoctors.length < 10 ? DoctorsReachMax() : DoctorsLoaded(page + 1));
    });
  }
}
