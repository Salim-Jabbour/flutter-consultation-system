part of 'personal_info_bloc.dart';

// modified : sealed must be abstract
@immutable
sealed class PersonalInfoEvent {}

class GetPersonalInfo extends PersonalInfoEvent {
  final int id;

  GetPersonalInfo({required this.id});
}

class UpdatePersonalInfo extends PersonalInfoEvent {
  final String name;
  final String email;
  final DateTime dob;
  final String gender;
  final String? image;

  UpdatePersonalInfo({
    required this.name,
    required this.email,
    required this.dob,
    required this.gender,
    this.image,
  });
}
