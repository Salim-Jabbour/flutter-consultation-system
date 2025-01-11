part of 'consultation_bloc.dart';

// modified : sealed must be abstract
@immutable
sealed class ConsultationEvent {}

class GetConsultationsPage extends ConsultationEvent {
  final int page;
  final int id;

  GetConsultationsPage({
    this.page = 0,
    required this.id,
  });
}

class GetSpecializations extends ConsultationEvent {}

class ChangeSpecialization extends ConsultationEvent {
  final int id;

  ChangeSpecialization({required this.id});
}

class RateConsultation extends ConsultationEvent {
  final num rate;
  final int id;

  RateConsultation({required this.rate, required this.id});
}

class RequestConsultation extends ConsultationEvent {
  final List<String> images;
  final String specializationId, title, description, consultationType;

  RequestConsultation(
      {required this.images,
      required this.specializationId,
      required this.title,
      required this.description,
      required this.consultationType}) {
    dbg("request id$specializationId");
  }
}
