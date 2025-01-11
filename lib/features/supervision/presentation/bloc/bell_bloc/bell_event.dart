part of 'bell_bloc.dart';

sealed class BellEvent {}

// inside bell
class InsideBellEvent extends BellEvent {
  final String token;

  InsideBellEvent(this.token);
}

// delete supervision (can go three ways: 1. first tab 2. second tab 3. inside bell)
class DeleteSupervisionEvent extends BellEvent {
  final String supervisionId;
  final String token;

  DeleteSupervisionEvent({
    required this.supervisionId,
    required this.token,
  });
}

// inside bell by pressing check hence approve
class ApproveSupervisionEvent extends BellEvent {
  final String supervisionId;
  final String token;

  ApproveSupervisionEvent({
    required this.supervisionId,
    required this.token,
  });
}
