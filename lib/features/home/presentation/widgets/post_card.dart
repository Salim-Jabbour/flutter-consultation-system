import 'package:akemha/config/router/route_manager.dart';
import 'package:akemha/core/widgets/custom_app_bar.dart';
import 'package:akemha/core/widgets/image_viewer.dart';
import 'package:akemha/features/home/models/post_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/const_manager.dart';
import '../../../../core/utils/dbg_print.dart';
import '../../../../core/utils/services/api_service.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/home_bloc.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    super.key,
    required this.post,
    this.tag,
  });

  final PostModel post;
  final Key? tag;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;
  @override
  void initState() {
    isLiked = widget.post.isLiked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I.get<HomeBloc>(),
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is AddLikeSuccess) {
            dbg("added like successfully");
          }
          if (state is AddLikeFailure) {
            isLiked = !isLiked;
          }
        },
        builder: (context, state) {
          return Container(
            margin: EdgeInsets.only(top: 10.h),
            color: ColorManager.white,
            width: 100.sw,
            // height: 362.h,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      RouteManager.post,
                      extra: widget.post,
                    );
                  },
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: ColorManager.c3,
                          radius: 20.r,
                          backgroundImage: CachedNetworkImageProvider(
                              widget.post.doctor.profileImg ??
                                  ConstManager.tempImage),
                        ),
                        title: Text(
                          widget.post.doctor.name,
                          style: TextStyle(
                            color: ColorManager.c2,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(32.0.w, 0, 32.0.w, 12.0),
                        child: Text(
                          widget.post.description,
                          maxLines: 100,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: ColorManager.c1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  constraints: BoxConstraints(maxHeight: 0.4.sh,minHeight: 0.2.sh),
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: ImageViewer(
                    child: CachedNetworkImage(
                      imageUrl: widget.post.imageUrl,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  height: 44.h,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: ColorManager.c3,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isLiked = !isLiked;
                              });
                              context.read<HomeBloc>().add(AddLikeEvent(
                                    context.read<AuthBloc>().token ??
                                        ApiService.token ??
                                        "",
                                    widget.post.id.toString(),
                                  ));
                            },
                            child: Icon(
                              isLiked
                                  ? Icons.thumb_up_rounded
                                  : Icons.thumb_up_alt_outlined,
                              color: ColorManager.c2,
                            ),
                          ),
                        ),
                      ),
                      const VerticalDivider(
                        color: ColorManager.c3,
                        thickness: 1,
                      ),
                      Expanded(
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              context.pushNamed(
                                RouteManager.post,
                                extra: widget.post,
                              );
                            },
                            child: const Icon(
                              Icons.mode_comment_outlined,
                              color: ColorManager.c2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

// TODO: Extract Widget
class PhotoWidget extends StatelessWidget {
  const PhotoWidget({
    super.key,
    required this.imageUrl,
    required this.tag,
  });

  final String imageUrl;
  final Key tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        color: Colors.black,
        iconColor: ColorManager.white,
      ),
      body: Draggable(
        axis: Axis.vertical,
        onDragEnd: (details) {
          if (details.offset.dy < -100) Navigator.of(context).pop();
        },
        feedback: Container(
          color: ColorManager.c3,
        ),
        child: Hero(
          tag: tag,
          child: PhotoView(
            imageProvider: CachedNetworkImageProvider(
              imageUrl,
            ),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.contained * 5,
          ),
        ),
      ),
    );
  }
}
