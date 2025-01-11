import 'package:akemha/core/errors/base_error.dart';
import 'package:akemha/features/chat/data/datasource/remote/chat_remote_data_source.dart';
import 'package:akemha/features/chat/model/message_consultation_model.dart';
import 'package:akemha/features/chat/repository/chat_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/errors/execption.dart';
import '../../../core/network/network_info.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatRemoteDataSource _chatRemoteDataSource;
  final NetworkInfo _networkInfo;

  ChatRepositoryImpl(
    this._chatRemoteDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, MessageConsultationModel>> getInitialMessages(
      String token, int cosultationId) async {
    if (await _networkInfo.isConnected) {
      try {
        final addSuccess = await _chatRemoteDataSource.getIinitialMessages(
            token, cosultationId);
        return addSuccess.fold(
          (failure) => Left(failure),
          (getMessages) {
            return right(getMessages);
          },
        );
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return left(NoInternetFailure());
    }
  }
}
