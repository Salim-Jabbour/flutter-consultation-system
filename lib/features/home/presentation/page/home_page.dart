
import 'package:akemha/core/utils/dbg_print.dart';

import 'package:akemha/config/router/route_manager.dart';
import 'package:akemha/config/theme/color_manager.dart';
import 'package:akemha/core/resource/string_manager.dart';
import 'package:akemha/core/utils/services/api_service.dart';
import 'package:akemha/core/widgets/custom_app_bar.dart';
import 'package:akemha/features/home/presentation/bloc/slider_cubit.dart';
import 'package:akemha/features/home/presentation/widgets/image_slider.dart';
import 'package:akemha/features/home/presentation/widgets/post_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/utils/global_snackbar.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../models/post_model.dart';
import '../bloc/doctor_cubit.dart';
import '../bloc/home_bloc.dart';
import '../widgets/doctor_list.dart';
import '../widgets/lr_list_tile.dart';




class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc homeBloc = GetIt.I.get<HomeBloc>();
  DoctorCubit doctorCubit = GetIt.I.get<DoctorCubit>();
  SliderCubit sliderCubit = GetIt.I.get<SliderCubit>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorManager.c3,
        appBar: CustomAppBar(
          left: false,
          title: StringManager.homePage.tr(),
          // FIXME:
          // actions: [
          //   PopupMenuButton(
          //     icon: const Icon(Icons.notifications_outlined),
          //     itemBuilder: (context) {
          //       return [
          //         const PopupMenuItem(
          //             value: 0,
          //             child: ListTile(
          //               title: Text('data'),
          //             ))
          //       ];
          //     },
          //   )
          //   // IconButton(
          //   //   onPressed: () {},
          //   //   icon: const Icon(
          //   //     Icons.notifications_outlined,
          //   //   ),
          //   // ),
          // ],
        ),
        body: BlocProvider(
          create: (context) => homeBloc,
          child: RefreshIndicator(
            onRefresh: () async {
              await sliderCubit.getSliderImages();
              await doctorCubit.getDoctorsPage();
              homeBloc.add(GetPostsPage());
              await homeBloc.refreshCompleter.future;
            },
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      ImagesSlider(
                        cubit: sliderCubit,
                      ),
                      LRListTile(
                        left: Text(
                          StringManager.doctors.tr(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: ColorManager.c2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        right: InkWell(
                          child: Text(
                            StringManager.seeMore.tr(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: ColorManager.c1,
                            ),
                          ),
                          onTap: () {
                            context.pushNamed(RouteManager.doctors);
                          },
                        ),
                      ),
                      DoctorsList(
                        cubit: doctorCubit,
                      ),
                      LRListTile(
                        left: Text(
                          StringManager.posts.tr(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: ColorManager.c2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                BlocConsumer<HomeBloc, HomeState>(
                  listener: (context, state) {
                    if (state is PostsInitialFailure) {
                      gShowErrorSnackBar(
                        context: context,
                        message: state.errMessage,
                      );
                    }
                  },
                  builder: (context, state) {
                    dbg(state);
                    if (state is HomeInitial) {
                      context.read<HomeBloc>().add(GetPostsPage());
                      dbg("initial");
                    }
                    if (state is PostsLoaded) {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: state.posts.posts.length +
                              (state.posts.reachMax ? 0 : 2),
                          (BuildContext context, int index) {
                            dbg("message$index");
                            if (index < state.posts.posts.length) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: PostCard(
                                  post: state.posts.posts[index],
                                  // tag: UniqueKey(),
                                ),
                              );
                            } else {
                              if (!state.posts.reachMax && !state.isLoading) {
                                dbg("Looooodiiiiing......");
                                context.read<HomeBloc>().add(GetPostsPage(page: state.posts.currentPage));
                              }
                              return const Skeletonizer(
                                enabled: true,
                                child: PostCard(
                                  post: loadingPost,
                                ),
                              );
                            }
                          },
                        ),
                      );
                    } else if (state is PostsEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Text("No Posts"),
                        ),
                      );
                    } else {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(childCount: 10,
                            (BuildContext context, int index) {
                          return const Skeletonizer(
                            enabled: true,
                            child: PostCard(
                              post: loadingPost,
                            ),
                          );
                        }),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: ApiService.userRole == "DOCTOR" ||
                context.read<AuthBloc>().role == 'DOCTOR'
            ? FloatingActionButton(
                backgroundColor: ColorManager.c3,
                child: const Icon(
                  Icons.add,
                  color: ColorManager.c2,
                ),
                onPressed: () {
                  context.pushNamed("addPost");
                })
            : null,
      ),
    );
  }
}
