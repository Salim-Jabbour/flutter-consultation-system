import 'dart:convert';

import 'specialization.dart';
import 'beneficiary.dart';
import 'doctor.dart';

Consultation consultationFromJson(String str) =>
    Consultation.fromJson(json.decode(str));

String consultationToJson(Consultation data) => json.encode(data.toJson());

 Consultation loadingConsultation = Consultation(
  id: 0,
  title: "title here",
  consultationText:
      'consultationTextconsultationTextconsultationTextconsultationText',
  consultationAnswer: 'consultationAnswer',
  images: [],
  consultationStatus: 'consultationStatus',
  specialization: loadingSpecialization,
  beneficiary: const Beneficiary(
    id: 0,
    name: 'name nam',
    profileImg:
        'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200',
    gender: 'gender',
  ),
  consultationType: 'consultationType',
);
const Specialization loadingSpecialization = Specialization(
  id: 0,
  name: 'namenamename',
  image:
      'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200',
);

class ConsultationsMapModel {
  final List<Specialization> specializations;
  final Map<int, ConsultationListModel> consultationsMap;

  const ConsultationsMapModel({
    required this.specializations,
    required this.consultationsMap,
  });

  ConsultationsMapModel copyWith({
    List<Specialization>? specializations,
    Map<int, ConsultationListModel>? consultationsMap,
    bool? isLoading,
    bool? isInitLoading,
  }) =>
      ConsultationsMapModel(
        consultationsMap: consultationsMap ?? this.consultationsMap,
        specializations: specializations ?? this.specializations,
      );
}

class ConsultationListModel {
  final List<Consultation> consultations;
  final bool reachMax;
  final bool isEmpty;
  final bool isError;
  final bool isLoading;
  final bool isInitialLoading;
  final int currentPage;

  const ConsultationListModel({
    required this.consultations,
    this.currentPage = 0,
    this.reachMax = false,
    this.isEmpty = false,
    this.isError = false,
    this.isLoading = false,
    this.isInitialLoading = false,
  });

  ConsultationListModel copyWith({
    List<Consultation>? consultations,
    bool? reachMax,
    bool? isEmpty,
    bool? isLoading,
    bool? isInitialLoading,
    bool? isError,
    int? currentPage,
  }) =>
      ConsultationListModel(
        consultations: consultations ?? this.consultations,
        currentPage: currentPage ?? this.currentPage,
        reachMax: reachMax ?? this.reachMax,
        isEmpty: isEmpty ?? this.isEmpty,
        isLoading: isLoading ?? this.isLoading,
        isInitialLoading: isInitialLoading ?? this.isInitialLoading,
        isError: isError ?? this.isError,
      );
}

class Consultation {
  final int id;
  final String consultationText;
  final String? consultationAnswer;
  final List<String> images;
  final String consultationStatus;
  final Specialization specialization;
  final Beneficiary? beneficiary;
  final Doctor? doctor;
  final String? consultationType;
  final String? title;
   num? rating;

   Consultation({
    required this.title,
    required this.id,
    required this.consultationText,
    required this.consultationAnswer,
    required this.images,
    required this.consultationStatus,
    required this.specialization,
    this.beneficiary,
    this.doctor,
    required this.consultationType,
    this.rating,
  });

  Consultation copyWith({
    int? id,
    String? consultationText,
    String? consultationAnswer,
    List<String>? images,
    String? consultationStatus,
    Specialization? specialization,
    Beneficiary? beneficiary,
    Doctor? doctor,
    String? consultationType,
    String? title,
    num? rating,
  }) =>
      Consultation(
        id: id ?? this.id,
        consultationText: consultationText ?? this.consultationText,
        consultationAnswer: consultationAnswer ?? this.consultationAnswer,
        images: images ?? this.images,
        consultationStatus: consultationStatus ?? this.consultationStatus,
        specialization: specialization ?? this.specialization,
        beneficiary: beneficiary ?? this.beneficiary,
        doctor: doctor ?? this.doctor,
        consultationType: consultationType ?? this.consultationType,
        title: title ?? this.title,
        rating: rating ?? this.rating,
      );

  factory Consultation.fromJson(Map<String, dynamic> json) => Consultation(
        id: json["id"],
        consultationText: json["consultationText"],
        consultationAnswer: json["consultationAnswer"],
        images: List<String>.from(json["images"].map((x) => x)),
        consultationStatus: json["consultationStatus"],
        specialization: Specialization.fromJson(json["specialization"]),
        //TODO: need modification
        // beneficiary: Beneficiary.fromJson(json["beneficiary"]),
        beneficiary: json["beneficiary"] != null
            ? Beneficiary.fromJson(json["beneficiary"])
            : null,
        //TODO: need modification
        doctor: json["doctor"] != null ? Doctor.fromJson(json["doctor"]) : null,
        consultationType: json["consultationType"],
        title: json["title"],
        rating: json["rating"]??0.0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "consultationText": consultationText,
        "consultationAnswer": consultationAnswer,
        "images": List<dynamic>.from(images.map((x) => x)),
        "consultationStatus": consultationStatus,
        "specialization": specialization.toJson(),
        "beneficiary": beneficiary?.toJson(),
        "doctor": doctor?.toJson(),
        "consultationType": consultationType,
        "title": title,
        "rating": rating,
      };
}
