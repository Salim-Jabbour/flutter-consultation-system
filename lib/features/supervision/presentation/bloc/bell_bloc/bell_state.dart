part of 'bell_bloc.dart';

@immutable
sealed class BellState {}

final class BellInitial extends BellState {}

final class BellLoading extends BellState {}

final class SupervisionInsideBellSuccess extends BellState {
  final SupervisionModel supervisionModel;

  SupervisionInsideBellSuccess(this.supervisionModel);
}

final class SupervisionInsideBellFailure extends BellState {
  final Failure failure;

  SupervisionInsideBellFailure(this.failure);
}

// delete supervision (can go three ways: 1. first tab 2. second tab 3. inside bell)
final class SupervisionDeleteSuccess extends BellState {
  final String msg;

  SupervisionDeleteSuccess(this.msg);
}

final class SupervisionDeleteFailure extends BellState {
  final Failure failure;

  SupervisionDeleteFailure(this.failure);
}

// inside bell by pressing check hence approve
final class SupervisionApproveSuccess extends BellState {
  final String msg;

  SupervisionApproveSuccess(this.msg);
}

final class SupervisionApproveFailure extends BellState {
  final Failure failure;

  SupervisionApproveFailure(this.failure);
}
