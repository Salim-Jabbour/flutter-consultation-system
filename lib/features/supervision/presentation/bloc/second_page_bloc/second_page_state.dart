part of 'second_page_bloc.dart';

@immutable
sealed class SecondPageState {}

final class SecondPageInitial extends SecondPageState {}

final class SecondPageLoading extends SecondPageState {}

// second tab
final class SupervisionSecondTabSuccess extends SecondPageState {
  final SupervisionModel supervisionModel;

  SupervisionSecondTabSuccess(this.supervisionModel);
}

final class SupervisionSecondTabFailure extends SecondPageState {
  final Failure failure;

  SupervisionSecondTabFailure(this.failure);
}

// delete supervision (can go three ways: 1. first tab 2. second tab 3. inside bell)
final class SupervisionDeleteSuccess extends SecondPageState {
  final String msg;

  SupervisionDeleteSuccess(this.msg);
}

final class SupervisionDeleteFailure extends SecondPageState {
  final Failure failure;

  SupervisionDeleteFailure(this.failure);
}
