part of 'first_page_bloc.dart';

@immutable
sealed class FirstPageBlocEvent {}

// first tab
class FirstTabEvent extends FirstPageBlocEvent {
  final String token;

  FirstTabEvent(this.token);
}

// delete supervision (can go three ways: 1. first tab 2. second tab 3. inside bell)
class DeleteSupervisionEvent extends FirstPageBlocEvent {
  final String supervisionId;
  final String token;

  DeleteSupervisionEvent({
    required this.supervisionId,
    required this.token,
  });
}

// get todays medicine event
class TodaysMedicineEvent extends FirstPageBlocEvent {
  final String token;
  final String supervisedId;

  TodaysMedicineEvent(this.token, this.supervisedId);
}

// send notification to supervised event
class SendNotificationToSupervisedEvent extends FirstPageBlocEvent {
  final String token, supervisedId, name, time;

  SendNotificationToSupervisedEvent(
    this.token,
    this.supervisedId,
    this.name,
    this.time,
  );
}
