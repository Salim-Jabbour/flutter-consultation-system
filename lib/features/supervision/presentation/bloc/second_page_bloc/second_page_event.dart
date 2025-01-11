part of 'second_page_bloc.dart';

@immutable
sealed class SecondPageEvent {}

// second tab
class SecondTabEvent extends SecondPageEvent {
  final String token;

  SecondTabEvent(this.token);
}

// delete supervision (can go three ways: 1. first tab 2. second tab 3. inside bell)
class DeleteSupervisionEvent extends SecondPageEvent {
  final String supervisionId;
  final String token;

  DeleteSupervisionEvent({
    required this.supervisionId,
    required this.token,
  });
}
