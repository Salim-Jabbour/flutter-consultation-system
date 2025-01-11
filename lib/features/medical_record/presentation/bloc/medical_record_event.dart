part of 'medical_record_bloc.dart';

@immutable
sealed class MedicalRecordEvent {}

class MedicalRecordGetEvent extends MedicalRecordEvent {
  final String token;

  MedicalRecordGetEvent({required this.token});
}

class MedicalRecordPostEvent extends MedicalRecordEvent {
  final String token;
  final MedicalRecordModelData data;

  MedicalRecordPostEvent({required this.token, required this.data});
}

class MedicalRecordChangeCoffee extends MedicalRecordEvent {
  final bool coffee;

  MedicalRecordChangeCoffee(this.coffee);
}

class MedicalRecordChangeAlcohol extends MedicalRecordEvent {
  final bool alcohol;

  MedicalRecordChangeAlcohol(this.alcohol);
}

class MedicalRecordChangeSmoker extends MedicalRecordEvent {
  final bool smoker;

  MedicalRecordChangeSmoker(this.smoker);
}

class MedicalRecordChangeMarried extends MedicalRecordEvent {
  final bool married;

  MedicalRecordChangeMarried(this.married);
}

class MedicalRecordChangeCovidVaccine extends MedicalRecordEvent {
  final bool covidVaccine;

  MedicalRecordChangeCovidVaccine(this.covidVaccine);
}

class MedicalRecordPatientHeight extends MedicalRecordEvent {
  final double patientHeight;

  MedicalRecordPatientHeight(this.patientHeight);
}

class MedicalRecordPatientWeight extends MedicalRecordEvent {
  final double patientWeight;

  MedicalRecordPatientWeight(this.patientWeight);
}

class MedicalRecordChangeBloodType extends MedicalRecordEvent {
  final BloodType bloodType;

  MedicalRecordChangeBloodType(this.bloodType);
}

class MedicalRecordAddPreviousSurgieries extends MedicalRecordEvent {
  final List<AdditionalRecordInfoResponse> newList;

  MedicalRecordAddPreviousSurgieries(this.newList);
}

class MedicalRecordAddPreviousIllnesses extends MedicalRecordEvent {
  final List<AdditionalRecordInfoResponse> newList;

  MedicalRecordAddPreviousIllnesses(this.newList);
}

class MedicalRecordAddAllergies extends MedicalRecordEvent {
  final List<AdditionalRecordInfoResponse> newList;

  MedicalRecordAddAllergies(this.newList);
}

class MedicalRecordAddFamilyHistoryofIllnesses extends MedicalRecordEvent {
  final List<AdditionalRecordInfoResponse> newList;

  MedicalRecordAddFamilyHistoryofIllnesses(this.newList);
}
