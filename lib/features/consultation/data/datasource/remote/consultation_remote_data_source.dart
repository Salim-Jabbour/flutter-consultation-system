import 'package:akemha/core/utils/dbg_print.dart';
import 'package:akemha/features/consultation/models/specialization.dart';
import 'package:dio/dio.dart';

import '../../../../../core/utils/services/api_service.dart';
import '../../../models/Consultation.dart';

abstract class ConsultationRemoteDataSource {
  Future<List<Consultation>> fetchConsultationsPage(
      {int pageNumber = 0, required int id});

  Future<List<Specialization>> fetchSpecializations();

  Future<List<Consultation>> fetchDoctorConsultationsPage({int pageNumber = 0});

  Future<List<Consultation>> searchConsultations(
      {required String searchText, int page = 0});

  Future<void> answerConsultation(
      {required int consultationId, required String answer});

  Future<void> rateConsultation({required num rate, required int id});

  Future<void> requestConsultation({
    required List<String> images,
    required String specializationId,
    required String title,
    required String description,
    required String consultationType,
  });
}

class ConsultationRemoteDataSourceImpl extends ConsultationRemoteDataSource {
  final Dio dioClient;

  ConsultationRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<Consultation>> fetchConsultationsPage(
      {int pageNumber = 0, required int id}) async {
    dioClient.options.headers.addAll({
      'authorization': 'Bearer ${ApiService.token}',
    });
    Response response;
    if (id == 0) {
      response = await dioClient
          .get('/api/consultation/answered/beneficiary', queryParameters: {
        "page": "$pageNumber",
      });
    } else {
      response = await dioClient
          .get('/api/consultation/answered/$id', queryParameters: {
        "page": "$pageNumber",
      });
    }
    // dbg(response.data);
    List<Consultation> consultations = getConsultationsList(response.data);
    // dbg(consultations);
    return consultations;
  }

  @override
  Future<List<Consultation>> fetchDoctorConsultationsPage(
      {int pageNumber = 0}) async {
    dioClient.options.headers
        .addAll({'authorization': 'Bearer ${ApiService.token}'});
    final Response response = await dioClient.get(
        '/api/consultation/PendingConsultationsForDoctor',
        queryParameters: {"page": "$pageNumber"});
    List<Consultation> doctorConsultations =
        getConsultationsList(response.data);
    return doctorConsultations;
  }

  @override
  Future<List<Consultation>> searchConsultations(
      {required String searchText, int page = 0}) async {
    dioClient.options.headers
        .addAll({'authorization': 'Bearer ${ApiService.token}'});
    final Response response =
        await dioClient.get('/api/consultation/search', queryParameters: {
      "page": "$page",
      "keyword": searchText,
    });
    List<Consultation> consultations = getConsultationsList(response.data);
    return consultations;
  }

  @override
  Future<List<Specialization>> fetchSpecializations() async {
    dioClient.options.headers.addAll({
      'authorization': 'Bearer ${ApiService.token}',
    });
    final Response response = await dioClient.get(
      '/api/specialization',
    );
    List<Specialization> specializations =
        getSpecializationsList(response.data);
    dbg(specializations);
    return specializations;
  }

  @override
  Future<void> requestConsultation({
    required List<String> images,
    required String specializationId,
    required String title,
    required String description,
    required String consultationType,
  }) async {
    dioClient.options.headers.addAll({
      'authorization': 'Bearer ${ApiService.token}',
    });
    Map<String, dynamic> map = {
      'title': title,
      'consultationText': description,
      'specializationId ': specializationId,
      'consultationType  ': consultationType.toUpperCase(),
      'files': []
    };
    for (String item in images) {
      map["files"].add(await MultipartFile.fromFile(item, filename: item));
    }

    final formData = FormData.fromMap(map);
    await dioClient.post(
      '/api/consultation',
      data: formData,
    );
  }

  @override
  Future<void> answerConsultation(
      {required int consultationId, required String answer}) async {
    dioClient.options.headers.addAll({
      'authorization': 'Bearer ${ApiService.token}',
    });
    // Map<String, dynamic> map = {
    //   'answer': answer,
    //   'consultationId': consultationId,
    // };
    // final formData = FormData.fromMap(map);
    await dioClient.patch(
      '/api/consultation/',
      data: {
        'answer': answer,
        'consultationId': consultationId,
      },
    );
  }

  @override
  Future<void> rateConsultation({required num rate, required int id}) async {
    dioClient.options.headers.addAll({
      'authorization': 'Bearer ${ApiService.token}',
    });
    // Map<String, dynamic> map = {
    //   'answer': answer,
    //   'consultationId': consultationId,
    // };
    // final formData = FormData.fromMap(map);
    await dioClient.post(
      '/api/consultation/$id/rate',
      data: {
        'rating': rate,
      },
    );
  }
}

List<Consultation> getConsultationsList(Map<String, dynamic> data) {
  List<Consultation> consultations = [];
  for (var consultationMap
      in ((data['data'] is List) ? data['data'] : data['data']['content'])) {
    // dbg('ssss$consultationMap');
    consultations.add(Consultation.fromJson(consultationMap));
  }
  return consultations;
}

List<Specialization> getSpecializationsList(Map<String, dynamic> data) {
  List<Specialization> specializations = [];

  for (var specializationMap in data['data']) {
    specializations.add(Specialization.fromJson(specializationMap));
  }
  return specializations;
}
