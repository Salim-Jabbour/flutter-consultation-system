part of 'first_page_bloc.dart';

@immutable
sealed class FirstPageBlocState {}

final class FirstPageBlocInitial extends FirstPageBlocState {}

final class FirstPageLoading extends FirstPageBlocState {}

final class FirstPageSuccess extends FirstPageBlocState {
  final SupervisionModel supervisionModel;

  FirstPageSuccess(this.supervisionModel);
}

final class FirstPageFailure extends FirstPageBlocState {
  final Failure failure;

  FirstPageFailure(this.failure);
}

// delete supervision (can go three ways: 1. first tab 2. second tab 3. inside bell)
final class SupervisionDeleteSuccess extends FirstPageBlocState {
  final String msg;

  SupervisionDeleteSuccess(this.msg);
}

final class SupervisionDeleteFailure extends FirstPageBlocState {
  final Failure failure;

  SupervisionDeleteFailure(this.failure);
}

// for getting todays medicine
final class TodaysMedicineSupervisedSuccess extends FirstPageBlocState {
  final MedicineModel medicineModel;

  TodaysMedicineSupervisedSuccess(this.medicineModel);
}

final class TodaysMedicineSupervisedFailure extends FirstPageBlocState {
  final Failure failure;

  TodaysMedicineSupervisedFailure(this.failure);
}

// for sending notification to supervised
final class SendNotificationLoading extends FirstPageBlocState {}

final class SendNotificationToSupervisedSuccess extends FirstPageBlocState {
  final NotificationReminderModel notificationReminderModel;

  SendNotificationToSupervisedSuccess(this.notificationReminderModel);
}

final class SendNotificationToSupervisedFailure extends FirstPageBlocState {
  final Failure failure;

  SendNotificationToSupervisedFailure(this.failure);
}

