import 'package:akemha/core/utils/services/api_service.dart';
import 'package:akemha/features/home/models/post_model.dart';
import 'package:akemha/features/home/models/slider_image.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/errors/base_error.dart';
import '../../../../../core/resource/string_manager.dart';
import '../../../../doctor/model/doctor_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<PostModel>> fetchPostsPage({int pageNumber = 0});

  Future<List<CommentModel>> fetchCommentsPage(
      {required int id, int pageNumber = 0});

  Future<void> addComment({required int id, required String comment});

  Future<List<DoctorDataModel>> fetchDoctorsPage({int pageNumber = 0});

  Future<List<SliderImage>> fetchSliderImages();

  Future<String> addPost(String token, String image, String description);

  Future<Either<Failure, void>> addLike(String token, String postId);
}

class HomeRemoteDataSourceImpl extends HomeRemoteDataSource {
  final Dio dioClient;

  HomeRemoteDataSourceImpl(this.dioClient);

  @override
  Future<List<PostModel>> fetchPostsPage({
    int pageNumber = 0,
  }) async {
    dioClient.options.headers
        .addAll({'Authorization': 'Bearer ${ApiService.token}'});
    final Response response = await dioClient.get(
      '/api/post',
      queryParameters: {"page": "$pageNumber"},
    );
    List<PostModel> posts = getPostsList(response.data);
    return posts;
  }

  @override
  Future<List<CommentModel>> fetchCommentsPage({
    required int id,
    int pageNumber = 0,
  }) async {
    dioClient.options.headers
        .addAll({'Authorization': 'Bearer ${ApiService.token}'});
    final Response response = await dioClient.get(
      '/api/post/comment/$id',
      queryParameters: {"page": "$pageNumber"},
    );
    List<CommentModel> posts = getCommentsList(response.data);
    return posts;
  }

  @override
  Future<void> addComment({required int id, required String comment}) async {
    dioClient.options.headers
        .addAll({'Authorization': 'Bearer ${ApiService.token}'});
    await dioClient.post(
      '/api/post/comment/$id',
      queryParameters: {"description": comment},
    );
  }

  @override
  Future<List<DoctorDataModel>> fetchDoctorsPage({int pageNumber = 0}) async {
    //FixMe: implement Remote Get doctors
    dioClient.options.headers
        .addAll({'authorization': 'Bearer ${ApiService.token}'});
    final Response response = await dioClient.get(
      '/admin/doctor',
      queryParameters: {"page": "$pageNumber"},
    );

    List<DoctorDataModel> doctors = getDoctorsList(response.data);

    return doctors;
  }

  @override
  Future<List<SliderImage>> fetchSliderImages() async {
    dioClient.options.headers
        .addAll({'Authorization': 'Bearer ${ApiService.token}'});
    final Response response = await dioClient.get('/api/slider');
    List<SliderImage> images = getSliderImagesList(response.data);
    return images;
  }

  @override
  Future<String> addPost(String token, String image, String description) async {
    dioClient.options.headers.addAll({
      'authorization': 'Bearer $token',
    });

    Map<String, dynamic> map = {
      'description': description,
      'image': await MultipartFile.fromFile(image, filename: image)
    };

    final formData = FormData.fromMap(map);
    final Response response = await dioClient.post(
      '/api/post',
      data: formData,
    );
    return "${response.data['msg']}";
  }

  List<PostModel> getPostsList(Map<String, dynamic> data) {
    List<PostModel> posts = [];
    for (var postMap in ((data['data'] ?? {})['content'] ?? [])) {
      posts.add(PostModel.fromJson(postMap));
    }
    return posts;
  }

  List<CommentModel> getCommentsList(Map<String, dynamic> data) {
    List<CommentModel> comments = [];

    for (var commentMap in (data['data'] ?? [])) {
      comments.add(CommentModel.fromJson(commentMap));
    }
    return comments;
  }

  List<SliderImage> getSliderImagesList(Map<String, dynamic> data) {
    List<SliderImage> images = [];
    for (var imageMap in (data['data'] ?? [])) {
      images.add(SliderImage.fromJson(imageMap));
    }
    return images;
  }

  // add like
  @override
  Future<Either<Failure, void>> addLike(String token, String postId) async {
    final Response response;
    try {
      dioClient.options.headers.addAll({'authorization': 'Bearer $token'});

      response = await dioClient.post("/api/post/add_like/$postId");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(null);
      }
    } on DioException catch (e) {
      if (e.response == null) {
        return left(NoInternetFailure());
      }
      if (e.response!.data['message'] != null) {
        return left(Failure(message: e.response!.data['message'].toString()));
      } else {
        return Left(
          Failure(message: StringManager.sthWrong.tr()),
        );
      }
    }
    return Left(ServerFailure());
  }
}
// List<DoctorDataModel> getTempDoctorsList(Map<String, dynamic> data) {
//   List<DoctorDataModel> doctors = [];

//   //FixMe: implement Parsing posts
//   doctors = const [
//     DoctorDataModel(
//         name: "سامي",
//         description:
//             "رحلة طبيب القلب طويلة وشاقة. يقضي سنوات عديدة في دراسة الطب، يتعمق في تشريح القلب وعصبه ووظائفه المعقدة. يتعلم تشخيص الأمراض المختلفة التي تُصيبه، من انسداد الشرايين إلى عدم انتظام ضرباته. كما يتدرب على إجراء الفحوصات الدقيقة، مثل تخطيط كهربائية القلب والموجات فوق الصوتية، التي تكشف له أسرار ما يدور داخل هذا العضو النبيل.",
//         specialization:
//             Specialization(id: 0, specializationType: "specializationType"),
//         profileImage:
//             'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200',
//         answeredConsultation: 10,
//         email: 'sss',
//         id: 0,
//         location: '',
//         openingTimes: '',
//         phoneNumber: '123'),
//     DoctorDataModel(
//         name: "سامي",
//         description:
//             "رحلة طبيب القلب طويلة وشاقة. يقضي سنوات عديدة في دراسة الطب، يتعمق في تشريح القلب وعصبه ووظائفه المعقدة. يتعلم تشخيص الأمراض المختلفة التي تُصيبه، من انسداد الشرايين إلى عدم انتظام ضرباته. كما يتدرب على إجراء الفحوصات الدقيقة، مثل تخطيط كهربائية القلب والموجات فوق الصوتية، التي تكشف له أسرار ما يدور داخل هذا العضو النبيل.",
//         specialization:
//             Specialization(id: 0, specializationType: "specializationType"),
//         profileImage:
//             'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200',
//         answeredConsultation: 10,
//         email: 'sss',
//         id: 0,
//         location: '',
//         openingTimes: '',
//         phoneNumber: '123'),
//     DoctorDataModel(
//         name: "سامي",
//         description:
//             "رحلة طبيب القلب طويلة وشاقة. يقضي سنوات عديدة في دراسة الطب، يتعمق في تشريح القلب وعصبه ووظائفه المعقدة. يتعلم تشخيص الأمراض المختلفة التي تُصيبه، من انسداد الشرايين إلى عدم انتظام ضرباته. كما يتدرب على إجراء الفحوصات الدقيقة، مثل تخطيط كهربائية القلب والموجات فوق الصوتية، التي تكشف له أسرار ما يدور داخل هذا العضو النبيل.",
//         specialization:
//             Specialization(id: 0, specializationType: "specializationType"),
//         profileImage:
//             'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200',
//         answeredConsultation: 10,
//         email: 'sss',
//         id: 0,
//         location: '',
//         openingTimes: '',
//         phoneNumber: '123'),
//     DoctorDataModel(
//         name: "سامي",
//         description:
//             "رحلة طبيب القلب طويلة وشاقة. يقضي سنوات عديدة في دراسة الطب، يتعمق في تشريح القلب وعصبه ووظائفه المعقدة. يتعلم تشخيص الأمراض المختلفة التي تُصيبه، من انسداد الشرايين إلى عدم انتظام ضرباته. كما يتدرب على إجراء الفحوصات الدقيقة، مثل تخطيط كهربائية القلب والموجات فوق الصوتية، التي تكشف له أسرار ما يدور داخل هذا العضو النبيل.",
//         specialization:
//             Specialization(id: 0, specializationType: "specializationType"),
//         profileImage:
//             'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200',
//         answeredConsultation: 10,
//         email: 'sss',
//         id: 0,
//         location: '',
//         openingTimes: '',
//         phoneNumber: '123'),
//   ];
//   // for (var bookMap in data['items']) {
//   //   posts.add(PosModel.fromJson(bookMap));
//   // }
//   return doctors;
// }

List<DoctorDataModel> getDoctorsList(Map<String, dynamic> data) {
  List<DoctorDataModel> doctors = [];

  for (var doctorMap in data['data']['content']) {
    doctors.add(DoctorDataModel.fromJson(doctorMap));
  }
  return doctors;
}
