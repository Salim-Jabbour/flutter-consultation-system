part of 'add_post_bloc.dart';

@immutable
sealed class AddPostState extends Equatable {
  const AddPostState();

  @override
  List<Object> get props => [];
}

final class AddPostInitial extends AddPostState {}

final class AddPostLoading extends AddPostState {}

final class AddPostSuccess extends AddPostState {
  final String message;

  const AddPostSuccess(this.message);
}

final class AddPostFailure extends AddPostState {
  final Failure failure;

  const AddPostFailure(this.failure);
}
