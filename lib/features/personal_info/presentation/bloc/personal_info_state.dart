part of 'personal_info_bloc.dart';

// modified : sealed must be abstract
@immutable
sealed class PersonalInfoState {}

final class PersonalInfoInitial extends PersonalInfoState {}

final class PersonalInfoLoading extends PersonalInfoState {}

final class PersonalInfoSuccess extends PersonalInfoState {}

final class PersonalInfoFailure extends PersonalInfoState {
  final String errMessage;

  PersonalInfoFailure(this.errMessage);
}

final class UpdatePersonalInfoLoading extends PersonalInfoState {}

final class UpdatePersonalInfoSuccess extends PersonalInfoState {
  final String message;

  UpdatePersonalInfoSuccess({required this.message});
}

final class UpdatePersonalInfoFailure extends PersonalInfoState {
  final String errMessage;

  UpdatePersonalInfoFailure(this.errMessage);
}
