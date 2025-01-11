import 'package:akemha/core/widgets/loading_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../config/theme/color_manager.dart';
import '../../../../../core/resource/string_manager.dart';
import '../../../../../core/utils/global_snackbar.dart';
import '../../../../../core/utils/services/api_service.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/empty_widget.dart';
import '../../../../../core/widgets/failure_widget.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../home/models/post_model.dart';
import '../../../../home/presentation/widgets/post_card.dart';
import '../../models/doctor_post_model.dart';
import '../manager/doctor_post/doctor_post_bloc.dart';
import '../widgets/post_card_widget.dart';

class DoctorPostPage extends StatefulWidget {
  const DoctorPostPage({super.key, required this.doctorId});
  final String doctorId;
  @override
  State<DoctorPostPage> createState() => _DoctorPostPageState();
}

class _DoctorPostPageState extends State<DoctorPostPage> {
  int page = 0;

  late DoctorPostBloc _bloc;

  final ScrollController _scrollController = ScrollController();
  bool isLoadingMore = false;

// this variable is to make sure that we dont need more data
  bool moreDataNeeded = true;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    _bloc = DoctorPostBloc(GetIt.I.get());
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 100 &&
        !isLoadingMore &&
        moreDataNeeded) {
      setState(() {
        isLoadingMore = true;
      });
      _bloc.add(
        DoctorGetPostEvent(
          context.read<AuthBloc>().token ?? ApiService.token ?? '',
          widget.doctorId,
          page,
          false,
        ),
      );
    }
  }

  bool checkIfMoreIsNeeded(List<DoctorPostDetailsModel> posts) {
    if (posts.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  int deleteIndex = -1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: Scaffold(
        backgroundColor: ColorManager.c3,
        appBar: CustomAppBar(
          title: StringManager.posts.tr(),
        ),
        body: BlocConsumer<DoctorPostBloc, DoctorPostState>(
          listener: (context, state) {
            if (state is DoctorGetPostSuccess) {
              setState(() {
                _bloc.postsList!.addAll(state.model.data);
                page++;
                moreDataNeeded = checkIfMoreIsNeeded(state.model.data);
                isLoadingMore = false;
              });
            }

            if (state is DoctorGetPostFailure) {
              setState(() {
                isLoadingMore = false;
              });
            }

            // deletion related
            if (state is DeletePostSuccess) {
              gShowSuccessSnackBar(
                context: context,
                message: StringManager.deleteSuccessfully.tr(),
              );
            }

            if (state is DeletePostFailure) {
              deleteIndex = -1;
              gShowErrorSnackBar(
                context: context,
                message: state.failure.message,
              );
            }
          },
          builder: (context, state) {
            if (state is DoctorPostInitial) {
              _bloc.add(
                DoctorGetPostEvent(
                  context.read<AuthBloc>().token ?? ApiService.token ?? '',
                  widget.doctorId,
                  page,
                  true,
                ),
              );
            }
            if (state is DoctorGetPostFailure) {
              _bloc.add(
                DoctorGetPostEvent(
                  context.read<AuthBloc>().token ?? ApiService.token ?? '',
                  widget.doctorId,
                  page,
                  true,
                ),
              );
            }

            if (state is DoctorGetPostFailure) {
              return FailureWidget(
                errorMessage: state.failure.message,
                onPressed: () {
                  _bloc.add(
                    DoctorGetPostEvent(
                      context.read<AuthBloc>().token ?? ApiService.token ?? '',
                      widget.doctorId,
                      page,
                      true,
                    ),
                  );
                },
              );
            }

            if (state is DeletePostSuccess) {
              _bloc.postsList!.removeAt(deleteIndex);
            }

            if (state is DeletePostFailure) {
              deleteIndex = -1;
            }

            return RefreshIndicator(
              onRefresh: () async {
                _bloc.add(
                  DoctorGetPostEvent(
                    context.read<AuthBloc>().token ?? ApiService.token ?? '',
                    widget.doctorId,
                    page,
                    true,
                  ),
                );
              },
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount:
                              _bloc.postsList!.length + (isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _bloc.postsList!.length) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                      color: ColorManager.c2),
                                ),
                              );
                            }
                            return PostCardWidget(
                              details: _bloc.postsList![index],
                              deleteFunction: () {
                                _bloc.add(DeletePostEvent(
                                    context.read<AuthBloc>().token ??
                                        ApiService.token ??
                                        '',
                                    _bloc.postsList![index].id.toString()));

                                deleteIndex = index;
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  if (state is DeletePostLoading)
                    const LoadingWidget(fullScreen: true),
                  if (state is DoctorPostLoading)
                    const SingleChildScrollView(
                      child: Column(
                        children: [
                          Skeletonizer(
                            child: PostCard(
                              post: loadingPost,
                            ),
                          ),
                          Skeletonizer(
                            child: PostCard(
                              post: loadingPost,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (state is DoctorGetPostSuccess && _bloc.postsList!.isEmpty)
                    EmptyWidget(height: 0.7.sh)
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
