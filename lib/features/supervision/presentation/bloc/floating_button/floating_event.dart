part of 'floating_bloc.dart';

@immutable
sealed class FloatingEvent {}

// sending request in first tab floating action button
class SendSupervisionRequestEvent extends FloatingEvent {
  final String supervisedId;
  final String token;

  SendSupervisionRequestEvent({
    required this.supervisedId,
    required this.token,
  });
}

// get random 10 users
class RandomTenEvent extends FloatingEvent {
  final String token;

  RandomTenEvent(this.token);
}

// get 10 users after search
class SearchedUsersEvent extends FloatingEvent {
  final String token;
  final String keyword;

  SearchedUsersEvent({required this.token, required this.keyword});
}
