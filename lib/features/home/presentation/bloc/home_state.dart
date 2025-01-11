part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class PostsInitialLoading extends HomeState {}

final class PostsLoaded extends HomeState {
  final PostsListModel posts;
  final bool isLoading;

  PostsLoaded({
    required this.posts,
    this.isLoading = false,
  });
}

class PostsEmpty extends HomeState {}

final class PostsInitialFailure extends HomeState {
  final String errMessage;

  PostsInitialFailure(this.errMessage);
}

final class AddLikeSuccess extends HomeState {}

final class AddLikeFailure extends HomeState {
  final Failure failure;

  AddLikeFailure(this.failure);
}

