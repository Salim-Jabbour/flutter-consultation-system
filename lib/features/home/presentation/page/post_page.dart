import 'package:akemha/core/utils/dbg_print.dart';

import 'package:akemha/core/widgets/custom_app_bar.dart';
import 'package:akemha/core/widgets/custom_text_field.dart';
import 'package:akemha/features/home/models/post_model.dart';
import 'package:akemha/features/home/presentation/bloc/comment_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/const_manager.dart';
import '../../../../core/resource/string_manager.dart';
import '../widgets/comment_card.dart';
import '../widgets/lr_list_tile.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key, required this.post});

  final PostModel post;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController _controller = TextEditingController();
  late CommentCubit cubit;

  @override
  void initState() {
    cubit = GetIt.I.get<CommentCubit>(param1: widget.post.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: SingleChildScrollView(
          child: SizedBox(
            height: .91.sh,
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 20.r,
                    backgroundImage: CachedNetworkImageProvider(
                      widget.post.doctor.profileImg ?? ConstManager.tempImage,
                    ),
                  ),
                  title: Text(
                    widget.post.doctor.name,
                    style: TextStyle(
                      color: ColorManager.c2,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  widget.post.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ColorManager.c1,
                  ),
                ),
                Container(
                  constraints: BoxConstraints(maxHeight: .4.sh),
                  child: CachedNetworkImage(
                    imageUrl: widget.post.imageUrl,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                LRListTile(
                  left: Text(
                    "${StringManager.comments.tr()}:",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: ColorManager.c2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: BlocConsumer<CommentCubit, CommentState>(
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      if (state is CommentInitial) {
                        context.read<CommentCubit>().getCommentsPage();
                      }
                      if (state is CommentsEmpty) {
                        return const Center(
                          child: Text(
                            "No Comment",
                          ),
                        );
                      }
                      return RefreshIndicator(
                        onRefresh: () async {
                          cubit.isReachMax = false;
                          cubit.comments = [];
                          cubit.nextPage = 0;
                          await cubit.getCommentsPage();
                        },
                        child: ListView.builder(
                          itemCount: cubit.comments.length +
                              ((state is CommentsLoaded && !cubit.isReachMax)
                                  ? 2
                                  : ((state is CommentInitial) ? 5 : 0)),
                          itemBuilder: (context, index) {
                            if (index < cubit.comments.length) {
                              return CommentCard(
                                comment: cubit.comments[index],
                              );
                            } else {
                              if (state is! CommentsLoading &&
                                  !cubit.isReachMax) {
                                cubit.getCommentsPage(page: cubit.nextPage);
                              }
                              return const Skeletonizer(
                                enabled: true,
                                child: CommentCard(
                                  comment: loadingComment,
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  height: 70.h,
                  color: ColorManager.textFieldFill,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8.0.r),
                          child: CustomTextField(
                            textEditingController: _controller,
                            hintText: StringManager.writeAComment.tr(),
                          ),
                        ),
                      ),
                      BlocBuilder<CommentCubit, CommentState>(
                          builder: (context, state) {
                        if (state is AddCommentLoading) {
                          return const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return TextButton(
                            onPressed: () async {
                              if (_controller.text.isNotEmpty) {
                                await cubit.addComment(_controller.text);
                                if (state is AddCommentSuccess) {
                                  _controller.clear();
                                }
                              }
                            },
                            child: const Icon(
                              Icons.send,
                              color: ColorManager.c2,
                            ),
                          );
                        }
                      })
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
