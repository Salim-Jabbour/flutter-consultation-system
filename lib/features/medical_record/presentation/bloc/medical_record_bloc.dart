import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/base_error.dart';
import '../../model/medical_record_model.dart';
import '../../repository/medical_record_repository.dart';

part 'medical_record_event.dart';

part 'medical_record_state.dart';

class MedicalRecordBloc extends Bloc<MedicalRecordEvent, MedicalRecordState> {
  final MedicalRecordRepository _medicalRecordRepository;

  MedicalRecordBloc(this._medicalRecordRepository)
      : super(MedicalRecordInitial()) {
    on<MedicalRecordGetEvent>((event, emit) async {
      emit(MedicalRecordLoading());

      final successOrFailure =
          await _medicalRecordRepository.getMedicalRecord(event.token);
      successOrFailure.fold(
        (error) {
          emit(MedicalRecordGetFailed(error));
        },
        (medicalRecordModel) {
          emit(MedicalRecordGetSuccess(medicalRecordModel));
        },
      );
    });

    on<MedicalRecordPostEvent>((event, emit) async {
      emit(MedicalRecordLoading());

      final successOrFailure = await _medicalRecordRepository.postMedicalRecord(
          event.data, event.token);
      successOrFailure.fold(
        (error) {
          emit(MedicalRecordPostFailed(error));
        },
        (medicalRecordModel) {
          emit(MedicalRecordPostSuccess(medicalRecordModel));
          emit(MedicalRecordInitial());
        },
      );
    });

    on<MedicalRecordChangeCoffee>((event, emit) {
      coffee = event.coffee;
    });

    on<MedicalRecordChangeAlcohol>((event, emit) {
      alcohol = event.alcohol;
    });

    on<MedicalRecordChangeSmoker>((event, emit) {
      smoker = event.smoker;
    });

    on<MedicalRecordChangeMarried>((event, emit) {
      married = event.married;
    });

    on<MedicalRecordChangeCovidVaccine>((event, emit) {
      covidVaccine = event.covidVaccine;
    });

    on<MedicalRecordPatientHeight>((event, emit) {
      patientHeight = event.patientHeight;
    });

    on<MedicalRecordPatientWeight>((event, emit) {
      patientWeight = event.patientWeight;
    });

    on<MedicalRecordChangeBloodType>((event, emit) {
      bloodType = event.bloodType;
    });

    on<MedicalRecordAddPreviousSurgieries>((event, emit) {
      previousSurgeries = event.newList;
    });

    on<MedicalRecordAddPreviousIllnesses>((event, emit) {
      previousIllnesses = event.newList;
    });

    on<MedicalRecordAddAllergies>((event, emit) {
      allergies = event.newList;
    });

    on<MedicalRecordAddFamilyHistoryofIllnesses>((event, emit) {
      familyHistoryOfIllnesses = event.newList;
    });
  }

  // bools
  bool? coffee;
  bool? alcohol;
  bool? smoker;
  bool? married;
  bool? covidVaccine;

  // doubles
  double? patientHeight;
  double? patientWeight;

  // enum
  BloodType? bloodType;

  // additional infos
  List<AdditionalRecordInfoResponse>? previousSurgeries;
  List<AdditionalRecordInfoResponse>? previousIllnesses;
  List<AdditionalRecordInfoResponse>? allergies;
  List<AdditionalRecordInfoResponse>? familyHistoryOfIllnesses;

  // suggestion lists
  List<String> suggestPreviousSurgeries = [
    "قلب مفتوح",
    "استئصال زائدة دودية",
    "استئصال مرارة",
    "تبديل مفصل ركبة",
  ];
  List<String> suggestPreviousIllnesses = [
    "سكري",
    "ارتفاع ضغط الدم",
    "الربو",
  ];
  List<String> suggestAllergies = [
    "حساسية الغبار",
    "حساسية الشمس",
    "حساسية الطعام",
  ];
  List<String> suggestFamilyHistoryOfIllnesses = [
    "الضغط",
    "السكري",
    "مشاكل الغدة الدرقية",
  ];
}
