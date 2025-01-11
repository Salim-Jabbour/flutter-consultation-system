import 'package:dartz/dartz.dart';

import '../../../core/errors/base_error.dart';
import '../../medicine_calendar/models/medicine_model.dart';
import '../model/notification_reminder_model.dart';
import '../model/supervision_model.dart';

abstract class SupervisionRepository {
// first tab
  Future<Either<Failure, SupervisionModel>>
      getApprovedSupervisionBySupervisorFirstTab(String token);
  // second tab
  Future<Either<Failure, SupervisionModel>>
      getApprovedSupervisionBySupervisedSecondTab(String token);
  // inside bell
  Future<Either<Failure, SupervisionModel>> viewSupervisionRequestInsideBell(
      String token);
  // delete supervision (can go three ways: 1. first tab 2. second tab 3. inside bell)
  Future<Either<Failure, String>> deleteSupervision(
      String supervisionId, String token);
  // inside bell by pressing check hence approve
  Future<Either<Failure, String>> approveSupervision(
      String supervisionId, String token);

  // sending request in first tab floating action button
  Future<Either<Failure, String>>
      sendSupervisionRequestInsideFloatingActionButton(
          String supervisedId, String token);
  // get random 10 users
  Future<Either<Failure, SupervisionUserModel>> getRandomTenUser(String token);
  // get 10 usrs after search
  Future<Either<Failure, SupervisionUserModel>> getTenUserSearchedByKeyword(
      String token, String keyword);

  // get todays medicine for the supervised
  Future<Either<Failure, MedicineModel>> getTodaysSupervisedMedicines(
      String token, String supervisedId);

  // send notification
  Future<Either<Failure, NotificationReminderModel>>
      sendNotificationToSupervised(
          String token, String supervisedId, String name, String time);
}
