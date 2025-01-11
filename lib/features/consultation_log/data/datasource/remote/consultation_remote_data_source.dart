import 'package:dio/dio.dart';

import '../../../../../core/utils/dbg_print.dart';
import '../../../../../core/utils/services/api_service.dart';
import '../../../../consultation/models/Consultation.dart';

abstract class ConsultationLogRemoteDataSource {
  Future<List<Consultation>> fetchConsultationsLogPage({int pageNumber = 0});

  Future<List<Consultation>> fetchMyAnsweredConsultationsPage(
      {int pageNumber = 0});
}

class ConsultationLogRemoteDataSourceImpl
    extends ConsultationLogRemoteDataSource {
  final Dio dioClient;

  ConsultationLogRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<Consultation>> fetchConsultationsLogPage(
      {int pageNumber = 0}) async {
    dioClient.options.headers.addAll({
      'authorization': 'Bearer ${ApiService.token}',
    });
    Response response;

    response = await dioClient.get(
        '/api/consultation/PersonalNullConsultations',
        queryParameters: {
          "page": "$pageNumber",
        });
    dbg(response.data);
    List<Consultation> consultations = getConsultationsLogList(response.data);
    return consultations;
  }

  @override
  Future<List<Consultation>> fetchMyAnsweredConsultationsPage(
      {int pageNumber = 0}) async {
    dioClient.options.headers.addAll({
      'authorization': 'Bearer ${ApiService.token}',
    });
    Response response;

    response = await dioClient.get(
        '/api/consultation/PersonalAnsweredConsultations',
        queryParameters: {
          "page": "$pageNumber",
        });
    dbg(response.data);
    List<Consultation> consultations = getConsultationsLogList(response.data);
    return consultations;
  }
}

List<Consultation> getConsultationsLogList(Map<String, dynamic> data) {
  List<Consultation> consultations = [];
  for (var consultationMap in data['data']??[]) {
    consultations.add(Consultation.fromJson(consultationMap));
  }
  return consultations;
}
