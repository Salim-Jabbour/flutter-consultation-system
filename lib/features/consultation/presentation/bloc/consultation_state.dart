part of 'consultation_bloc.dart';

// modified : sealed must be abstract
@immutable
sealed class ConsultationState {}

final class ConsultationInitial extends ConsultationState {}

final class ConsultationRateSuccess extends ConsultationState {}

final class ConsultationRateFailure extends ConsultationState {
  final String errMessage;

  ConsultationRateFailure({required this.errMessage});
}

final class ConsultationRateLoading extends ConsultationState {}

final class ConsultationsInitialLoading extends ConsultationState {}

final class ConsultationsLoaded extends ConsultationState {
  final ConsultationsMapModel consultations;
  final int currentSpecialization;
  final bool isLoading;
  final bool isInitialLoading;
  final bool firstGet;

  ConsultationsLoaded({
    required this.consultations,
    this.currentSpecialization = 0,
    this.isLoading = false,
    this.isInitialLoading = false,
    this.firstGet = false,
  });
}

// final class SpecializationsLoaded extends ConsultationState {
//   final List<Specialization> specializations;
//
//   SpecializationsLoaded(this.specializations);
// }

final class ConsultationRequested extends ConsultationState {}

final class ConsultationsFailure extends ConsultationState {
  final String errMessage;

  ConsultationsFailure(this.errMessage);
}
