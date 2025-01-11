import 'dart:async';

import 'package:akemha/features/home/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failure.dart';
import '../../repository/home_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  PostsListModel posts = const PostsListModel(
    posts: [],
    currentPage: 0,
    reachMax: false,
  );

  Completer<void> refreshCompleter = Completer<void>();

  HomeBloc(this._homeRepository) : super(HomeInitial()) {
    refreshCompleter = Completer<void>();
    on<GetPostsPage>((event, emit) async {
      bool isInitial = event.page == 0;
      isInitial
          ? {
              emit(
                PostsInitialLoading(),
              ),
              posts = const PostsListModel(
                posts: [],
                currentPage: 0,
                reachMax: false,
              )
            }
          : emit(
              PostsLoaded(
                posts: posts,
                isLoading: true,
              ),
            );

      final result = await _homeRepository.fetchPostsPage(
        pageNumber: event.page,
      );
      if (!refreshCompleter.isCompleted) {
        refreshCompleter.complete();
      }
      result.fold((error) {
        isInitial
            ? emit(PostsInitialFailure(error.message))
            : PostsLoaded(
                posts: posts,
              );
      }, (newPosts) {
        if (isInitial) {
          posts = PostsListModel(
            posts: newPosts.posts,
            currentPage: event.page + 1,
            reachMax: newPosts.reachMax || newPosts.posts.length < 10,
          );
          if (newPosts.posts.isEmpty) {
            emit(PostsEmpty());
          }
        } else {
          posts = PostsListModel(
            posts: posts.posts + newPosts.posts,
            currentPage: newPosts.currentPage + 1,
            reachMax: (newPosts.posts.isEmpty || newPosts.posts.length < 10),
          );
        }
        emit(PostsLoaded(posts: posts));
      });
    });

    // add Like event
    on<AddLikeEvent>((event, emit) async {
      final successOrFailure =
          await _homeRepository.addLike(event.token, event.postId);
      successOrFailure.fold(
        (error) {
          emit(AddLikeFailure(error));
        },
        (medicalRecordModel) {
          emit(AddLikeSuccess());
        },
      );
    });
  }
}
