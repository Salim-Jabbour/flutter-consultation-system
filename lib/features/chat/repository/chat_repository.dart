import 'package:akemha/features/chat/model/message_consultation_model.dart';
import 'package:dartz/dartz.dart';

import '../../../core/errors/base_error.dart';

abstract class ChatRepository {
  Future<Either<Failure, MessageConsultationModel>> getInitialMessages(
      String token, int cosultationId);
}
