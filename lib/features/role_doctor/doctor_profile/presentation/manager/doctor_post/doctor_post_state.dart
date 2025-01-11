part of 'doctor_post_bloc.dart';

@immutable
sealed class DoctorPostState extends Equatable {
  const DoctorPostState();

  @override
  List<Object> get props => [];
}

final class DoctorPostInitial extends DoctorPostState {}

final class DoctorPostLoading extends DoctorPostState {}

final class DoctorPostPageableLoading extends DoctorPostState {}

final class DoctorGetPostSuccess extends DoctorPostState {
  final DoctorPostModel model;

  const DoctorGetPostSuccess(this.model);
}

final class DoctorGetPostFailure extends DoctorPostState {
  final Failure failure;

  const DoctorGetPostFailure(this.failure);
}

final class DeletePostLoading extends DoctorPostState {}

final class DeletePostSuccess extends DoctorPostState {
  final bool deleteSuccess;

  const DeletePostSuccess(this.deleteSuccess);
}

final class DeletePostFailure extends DoctorPostState {
  final Failure failure;

  const DeletePostFailure(this.failure);
}
