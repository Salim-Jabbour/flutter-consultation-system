part of 'home_bloc.dart';

// modified : sealed must be abstract
@immutable
sealed class HomeEvent {}

class GetPostsPage extends HomeEvent {
  final int page;

  GetPostsPage({this.page = 0});
}

// class GetDoctorsPage extends HomeEvent {
//   final int page;
//   GetDoctorsPage({this.page=0});
// }
class AddLikeEvent extends HomeEvent {
  final String token, postId;

  AddLikeEvent(this.token, this.postId);
}
