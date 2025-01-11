part of 'doctor_post_bloc.dart';

sealed class DoctorPostEvent extends Equatable {
  const DoctorPostEvent();

  @override
  List<Object> get props => [];
}

class DoctorGetPostEvent extends DoctorPostEvent {
  final String token;
  final String doctorId;
  final int page;
  final bool isInitial;

  const DoctorGetPostEvent(
    this.token,
    this.doctorId,
    this.page,
    this.isInitial,
  );
}

class DeletePostEvent extends DoctorPostEvent {
  final String token;
  final String postId;

  const DeletePostEvent(this.token, this.postId);
}
