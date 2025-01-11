import 'package:akemha/features/personal_info/models/personal_info_model.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/utils/services/api_service.dart';

abstract class PersonalInfoRemoteDataSource {
  Future<PersonalInfoModel> fetchPersonalInfo({required int id});

  Future<PersonalInfoModel> updatePersonalInfo(
      {String? name, String? email, String? gender, DateTime? dob,String? image});
}

class PersonalInfoRemoteDataSourceImpl extends PersonalInfoRemoteDataSource {
  final Dio dioClient;

  PersonalInfoRemoteDataSourceImpl(this.dioClient);

  @override
  Future<PersonalInfoModel> fetchPersonalInfo({required int id}) async {
    dioClient.options.headers
        .addAll({'authorization': 'Bearer ${ApiService.token}'});
    final Response response = await dioClient.get('/api/user/information/$id');
    return PersonalInfoModel.fromJson(response.data['data'] ?? {});
  }

  @override
  Future<PersonalInfoModel> updatePersonalInfo(
      {String? name, String? email, String? gender, DateTime? dob,String? image}) async {
    dioClient.options.headers
        .addAll({'authorization': 'Bearer ${ApiService.token}'});
    final Response response = await dioClient.patch(
      '/api/user/information/edit',
      data: FormData.fromMap({
        'name': name,
        'email': email,
        'gender': gender?.toUpperCase(),
        'dob': dob != null ? DateFormat('yyyy-MM-dd').format(dob) : null,
        'profileImg': image != null ? await MultipartFile.fromFile(image, filename: image) : null,
      }),
    );
    return PersonalInfoModel.fromJson(response.data['data'] ?? {});
  }
}
