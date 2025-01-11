import 'package:akemha/features/home/models/post_model.dart';
import 'package:akemha/features/home/models/slider_image.dart';
import 'package:dartz/dartz.dart';

import '../../../core/errors/failure.dart';
import '../../doctor/model/doctor_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, PostsListModel>> fetchPostsPage({int pageNumber = 0});

  Future<Either<Failure, List<CommentModel>>> fetchCommentsPage(
      {required int id, int pageNumber = 0});

  Future<Either<Failure, void>> addComment(
      {required int id, required String comment});

  Future<Either<Failure, List<DoctorDataModel>>> fetchDoctorsPage(
      {int pageNumber = 0});

  Future<Either<Failure, List<SliderImage>>> fetchSliderImages();

  Future<Either<Failure, String>> addPost(
      String token, String image, String description);

  Future<Either<Failure, void>> addLike(String token, String postId);
}
