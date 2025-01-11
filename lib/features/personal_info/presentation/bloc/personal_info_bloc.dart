import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/personal_info_model.dart';
import '../../repository/personal_info_repository.dart';

part 'personal_info_event.dart';

part 'personal_info_state.dart';

class PersonalInfoBloc extends Bloc<PersonalInfoEvent, PersonalInfoState> {
  final PersonalInfoRepository _personalInfoRepository;
  PersonalInfoModel? info;
  PersonalInfoBloc(this._personalInfoRepository)
      : super(PersonalInfoInitial()) {
    on<GetPersonalInfo>((event, emit) async {
      emit(PersonalInfoLoading());
      final result = await _personalInfoRepository.getPersonalInfo(
        id: event.id,
      );
      result.fold((error) {
        emit(PersonalInfoFailure(error.message));
      }, (personalInfo) {
        info=personalInfo;
        emit(PersonalInfoSuccess());
      });
    });
    on<UpdatePersonalInfo>((event, emit) async {
      emit(UpdatePersonalInfoLoading());
      final result = await _personalInfoRepository.updatePersonalInfo(
        name: event.name,
        email: event.email,
        gender: event.gender,
        dob: event.dob,
        image: event.image,
      );
      result.fold((error) {
        emit(UpdatePersonalInfoFailure(error.message));
      }, (personalInfo) {
        info=personalInfo;
        emit(UpdatePersonalInfoSuccess(message:"INFO UPDATED SUCCESSFULLY",));
      });
    });
  }
}
