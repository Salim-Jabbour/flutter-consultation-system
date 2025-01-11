import 'package:akemha/core/resource/const_manager.dart';
import 'package:akemha/features/chat/model/message_consultation_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/errors/base_error.dart';
import '../../../../../core/resource/string_manager.dart';

abstract class ChatRemoteDataSource {
  Future<Either<Failure, MessageConsultationModel>> getIinitialMessages(
      String token, int cosultationId);
}

class ChatRemoteDataSourceImpl extends ChatRemoteDataSource {
  final Dio dioClient;

  ChatRemoteDataSourceImpl(this.dioClient);
  @override
  Future<Either<Failure, MessageConsultationModel>> getIinitialMessages(
      String token, int cosultationId) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});
      //FIXME: change the path
      response = await dioClient
          .get("${ConstManager.baseUrl}consultation/messages/$cosultationId");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(MessageConsultationModel.fromJson(
            response.data as Map<String, dynamic>));
      }
    } on DioException catch (e) {
      if (e.response == null) {
        return left(NoInternetFailure());
      }
      if (e.response!.data['message'] != null) {
        return left(Failure(message: e.response!.data['message'].toString()));
      } else {
        return Left(
          Failure(message: StringManager.sthWrong.tr()),
        );
      }
    }
    return Left(ServerFailure());
  }
}
