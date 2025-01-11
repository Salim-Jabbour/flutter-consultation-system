part of 'consultation_log_bloc.dart';

// modified : sealed must be abstract
@immutable
sealed class ConsultationLogState {}

final class ConsultationLogInitial extends ConsultationLogState {}

final class ConsultationsLogLoading extends ConsultationLogState {}

final class ConsultationsLogLoaded extends ConsultationLogState {
  final ConsultationListModel consultationsLog;
  final ConsultationListModel myAnsweredConsultations;


  ConsultationsLogLoaded({
    required this.consultationsLog,
    required this.myAnsweredConsultations,
  });
}

final class ConsultationsLogFailure extends ConsultationLogState {
  final String errMessage;

  ConsultationsLogFailure(this.errMessage);
}
