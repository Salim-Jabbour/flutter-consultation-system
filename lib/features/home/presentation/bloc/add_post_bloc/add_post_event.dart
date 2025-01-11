part of 'add_post_bloc.dart';

sealed class AddPostEvent extends Equatable {
  const AddPostEvent();

  @override
  List<Object> get props => [];
}

class AddGetPostEvent extends AddPostEvent {
  final String token;
  final String image;
  final String description;

  const AddGetPostEvent(this.token, this.image, this.description);
}
