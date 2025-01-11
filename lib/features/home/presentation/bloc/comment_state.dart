part of 'comment_cubit.dart';

@immutable
sealed class CommentState {}

final class CommentInitial extends CommentState {}

final class CommentsLoading extends CommentState {}

final class AddCommentLoading extends CommentState {}

final class AddCommentSuccess extends CommentState {}

final class AddCommentFailure extends CommentState {
  final String message;

  AddCommentFailure(this.message);
}

final class CommentsLoaded extends CommentState {}

final class CommentsReachMax extends CommentState {}

class CommentsEmpty extends CommentState {}

final class CommentsFailure extends CommentState {
  final String errMessage;

  CommentsFailure(this.errMessage);
}
