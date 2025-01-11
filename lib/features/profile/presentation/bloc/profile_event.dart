part of 'profile_bloc.dart';

// modified : sealed must be abstract
@immutable
sealed class ProfileEvent {}

class ProfileGetProfileInfoEvent extends ProfileEvent {
  final String token;
  final String userId;

  ProfileGetProfileInfoEvent({required this.token, required this.userId});
}
