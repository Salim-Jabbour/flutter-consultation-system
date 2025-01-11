part of 'profile_bloc.dart';

// modified : sealed must be abstract
@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

class ProfileGetInfoFailed extends ProfileState {
  final Failure failure;
  
  ProfileGetInfoFailed({required this.failure});
}

class ProfileGetInfoSuccess extends ProfileState {
  final ProfileModel profileModel;

  ProfileGetInfoSuccess({required this.profileModel});
}
