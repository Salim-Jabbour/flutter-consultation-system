import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';
import '../../consultation/models/Consultation.dart';
import '../../consultation/models/ConsultationModel.dart';

abstract class ConsultationLogRepository {

  Future<Either<Failure, List<Consultation>>> fetchConsultationsLogPage({int pageNumber = 0});
  Future<Either<Failure, List<Consultation>>> fetchMyAnsweredConsultationsPage({int pageNumber = 0});
}
