// ignore_for_file: unused_field

import 'package:akemha/features/home/models/post_model.dart';
import 'package:akemha/features/home/models/slider_image.dart';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../core/errors/failure.dart';

import '../../../core/network/network_info.dart';
import '../../doctor/model/doctor_model.dart';
import '../data/datasource/local/home_local_data_source.dart';
import '../data/datasource/remote/home_remote_data_source.dart';
import 'home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  final HomeLocalDataSource _homeLocalDataSource;
  final HomeRemoteDataSource _homeRemoteDataSource;
  final NetworkInfo _networkInfo;

  HomeRepositoryImpl(
    this._homeRemoteDataSource,
    this._homeLocalDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, PostsListModel>> fetchPostsPage(
      {int pageNumber = 0}) async {
    List<PostModel> postsList;
    try {
      postsList =
          await _homeRemoteDataSource.fetchPostsPage(pageNumber: pageNumber);
      return right(PostsListModel(
        posts: postsList,
        currentPage: pageNumber,
        reachMax: postsList.length < 10,
      ));
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CommentModel>>> fetchCommentsPage(
      {required int id, int pageNumber = 0}) async {
    List<CommentModel> commentsList;
    try {
      commentsList = await _homeRemoteDataSource.fetchCommentsPage(
          id: id, pageNumber: pageNumber);
      return right(commentsList);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addComment(
      {required int id, required String comment}) async {
    try {
      await _homeRemoteDataSource.addComment(id: id, comment: comment);
      return right(null);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DoctorDataModel>>> fetchDoctorsPage(
      {int pageNumber = 0}) async {
    List<DoctorDataModel> doctorsList;
    try {
      doctorsList =
          await _homeRemoteDataSource.fetchDoctorsPage(pageNumber: pageNumber);
      return right(doctorsList);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SliderImage>>> fetchSliderImages() async {
    List<SliderImage> images;
    try {
      images = await _homeRemoteDataSource.fetchSliderImages();
      return right(images);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> addPost(
      String token, String image, String description) async {
    try {
      String response =
          await _homeRemoteDataSource.addPost(token, image, description);
      return right(response);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  // add like
  @override
  Future<Either<Failure, void>> addLike(String token, String postId) async {
    try {
      await _homeRemoteDataSource.addLike(token, postId);
      return right(null);
    } catch (e) {
      if (e is DioException) {
        return left(ServerFailure.fromDiorError(e));
      }
      return left(ServerFailure(e.toString()));
    }
  }
}
