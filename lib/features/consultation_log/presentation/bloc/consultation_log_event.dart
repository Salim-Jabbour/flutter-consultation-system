part of 'consultation_log_bloc.dart';

// modified : sealed must be abstract
@immutable
sealed class ConsultationLogEvent {}

class GetConsultationsLogPage extends ConsultationLogEvent {
  final int page;
  GetConsultationsLogPage({this.page = 0,});
}
class GetMyAnsweredConsultationsLogPage extends ConsultationLogEvent {
  final int page;
  GetMyAnsweredConsultationsLogPage({this.page = 0,});
}
