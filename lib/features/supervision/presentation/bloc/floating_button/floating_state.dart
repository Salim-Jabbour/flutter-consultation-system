part of 'floating_bloc.dart';

@immutable
sealed class FloatingState {}

final class FloatingInitial extends FloatingState {}

final class FloatingLoading extends FloatingState {}

// sending request in first tab floating action button
final class SupervisionRequestSuccess extends FloatingState {
  final String msg;

  SupervisionRequestSuccess(this.msg);
}

final class SupervisionRequestFailure extends FloatingState {
  final Failure failure;

  SupervisionRequestFailure(this.failure);
}

// get random 10 users
final class SupervisionRandomTenSuccess extends FloatingState {
  final SupervisionUserModel userLessResponseModelList;

  SupervisionRandomTenSuccess(this.userLessResponseModelList);
}

final class SupervisionRandomTenFailure extends FloatingState {
  final Failure failure;

  SupervisionRandomTenFailure(this.failure);
}

// get 10 usrs after search
final class SupervisionSearchedTenSuccess extends FloatingState {
  final SupervisionUserModel userLessResponseModelList;

  SupervisionSearchedTenSuccess(this.userLessResponseModelList);
}

final class SupervisionSearchedTenFailure extends FloatingState {
  final Failure failure;

  SupervisionSearchedTenFailure(this.failure);
}
