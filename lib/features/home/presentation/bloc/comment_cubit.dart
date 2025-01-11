import 'package:akemha/core/utils/services/api_service.dart';
import 'package:akemha/features/consultation/models/doctor.dart';
import 'package:akemha/features/home/repository/home_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/post_model.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentState> {
  List<CommentModel> comments = [];
  int nextPage = 0;

  CommentCubit(this._homeRepository, this.id) : super(CommentInitial());
  final HomeRepository _homeRepository;
  final int id;
  bool isReachMax = false;

  Future<void> getCommentsPage({int page = 0}) async {
    emit(
      CommentsLoading(),
    );
    final result = await _homeRepository.fetchCommentsPage(
      id: id,
      pageNumber: page,
    );
    result.fold((error) {
      emit(CommentsFailure(error.message));
    }, (newComments) {
      if (page == 0) {
        comments = [];
      }
      comments.addAll(newComments);
      nextPage = page + 1;
      isReachMax |= newComments.length < 10;
      emit(CommentsLoaded());
    });
  }

  Future<void> addComment(String comment) async {
    emit(AddCommentLoading());
    final result = await _homeRepository.addComment(id: id, comment: comment);
    result.fold((error) {
      emit(AddCommentFailure(error.message));
    }, (newComments) {
      comments = [
            CommentModel(
              id: 1,
              doctor: Doctor(
                  id: 1,
                  name: ApiService.userName ?? "No Name",
                  email: "email"),
              description: comment,
            )
          ] +
          comments;
      emit(AddCommentSuccess());
    });
  }
}
