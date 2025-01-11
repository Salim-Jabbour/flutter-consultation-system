part of 'medical_record_bloc.dart';

// modified : sealed must be abstract
@immutable
sealed class MedicalRecordState {}

final class MedicalRecordInitial extends MedicalRecordState {}

final class MedicalRecordLoading extends MedicalRecordState {}

final class MedicalRecordGetSuccess extends MedicalRecordState {
  final MedicalRecordModel medicalRecordModel;

  MedicalRecordGetSuccess(this.medicalRecordModel);
}

final class MedicalRecordGetFailed extends MedicalRecordState {
  final Failure failure;

  MedicalRecordGetFailed(this.failure);
}

final class MedicalRecordPostSuccess extends MedicalRecordState {
  final MedicalRecordPostModel medicalRecordPostModel;

  MedicalRecordPostSuccess(this.medicalRecordPostModel);
}

final class MedicalRecordPostFailed extends MedicalRecordState {
  final Failure failure;

  MedicalRecordPostFailed(this.failure);
}
