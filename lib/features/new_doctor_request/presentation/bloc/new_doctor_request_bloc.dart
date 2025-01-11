// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/errors/base_error.dart';
import '../../../role_doctor/doctor_profile/models/doctor_specialization_model.dart';
import '../../repository/new_doctor_request_repository.dart';

part 'new_doctor_request_event.dart';
part 'new_doctor_request_state.dart';

class NewDoctorRequestBloc
    extends Bloc<NewDoctorRequestEvent, NewDoctorRequestState> {
  final NewDoctorRequestRepository _repository;
  NewDoctorRequestBloc(this._repository) : super(NewDoctorRequestInitial()) {
    on<DoctorProfileGetSpecializationsEvent>((event, emit) async {
      emit(NewDoctorRequestLoading());

      final successOrFailure = await _repository.getSpecializations();

      successOrFailure.fold(
        (l) => emit(DoctorProfileSpecializationFailure(l)),
        (r) {
          emit(DoctorProfileSpecializationSuccess(r));
          // emit(DoctorProfileInitial());
        },
      );
    });

    on<NewDoctorRequestAddEvent>((event, emit) async {
      emit(NewDoctorRequestLoading());

      final successOrFailure = await _repository.addRequest(
        event.file,
        event.aboutMe,
        event.emailAddress,
        event.name,
        event.deviceToken,
        event.gender,
        event.specializationId,
      );

      successOrFailure.fold(
        (l) => emit(NewDoctorRequestFailure(l)),
        (message) {
          emit(NewDoctorRequestSuccess(message));
        },
      );
    });
  }

  Future<File?> pickPdfFile() async {
    cvFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (cvFile != null) {
      fileName = cvFile!.paths.first!.split('/').last;
      pdfFile = File(cvFile!.files.single.path!);
      return File(cvFile!.files.single.path!);
    }

    return null;
  }

  FilePickerResult? cvFile;
  File? pdfFile;
  String? fileName;
}
