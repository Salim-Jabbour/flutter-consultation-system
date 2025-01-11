import 'package:akemha/config/router/route_manager.dart';
import 'package:akemha/features/profile/presentation/widgets/logout_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/const_manager.dart';
import '../../../../core/resource/string_manager.dart';
import '../../../../core/utils/global_snackbar.dart';
import '../../../../core/utils/services/api_service.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../model/profile_model.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/profile_card_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileDataModel? profileModel;

  @override
  Widget build(BuildContext context) {
    ProfileBloc bloc = GetIt.I.get<ProfileBloc>();
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        backgroundColor: ColorManager.c3,
        body: SafeArea(
            child: RefreshIndicator(
          onRefresh: () async {
            bloc.add(
              ProfileGetProfileInfoEvent(
                token: context.read<AuthBloc>().token ?? ApiService.token ?? '',
                userId: context.read<AuthBloc>().userId ??
                    ApiService.userId ??
                    '1'
                        '',
              ),
            );
            await bloc.profileRefresh.future;
          },
          child: SingleChildScrollView(
            child: BlocConsumer<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state is ProfileGetInfoSuccess) {
                  profileModel = state.profileModel.profileDataModel;
                }
              },
              builder: (context, state) {
                if (state is ProfileGetInfoFailed) {
                  return FailureWidget(
                    errorMessage: state.failure.message,
                    onPressed: () {
                      context
                          .read<ProfileBloc>()
                          .add(ProfileGetProfileInfoEvent(
                            token: context.read<AuthBloc>().token ??
                                ApiService.token ??
                                '',
                            userId: context.read<AuthBloc>().userId ??
                                ApiService.userId ??
                                '1'
                                    '',
                          ));
                    },
                  );
                }
                if (state is ProfileInitial) {
                  context.read<ProfileBloc>().add(
                        ProfileGetProfileInfoEvent(
                          token: context.read<AuthBloc>().token ??
                              ApiService.token ??
                              '',
                          userId: context.read<AuthBloc>().userId ??
                              ApiService.userId ??
                              '1'
                                  '',
                        ),
                      );
                }
                return SingleChildScrollView(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 30.h),
                          ListTile(
                            trailing: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BlocConsumer<AuthBloc, AuthState>(
                                listener: (context, state) {
                                  if (state is AuthLogoutSuccess) {
                                    gShowSuccessSnackBar(
                                        context: context,
                                        message:
                                            StringManager.logoutSuccess.tr());

                                    context.pushReplacementNamed(
                                        RouteManager.login);
                                  }

                                  if (state is AuthLogoutFailed) {
                                    gShowErrorSnackBar(
                                        context: context,
                                        message: StringManager.sthWrong.tr());
                                    context.pop();
                                  }
                                },
                                builder: (context, state) {
                                  return IconButton(
                                    onPressed: () {
                                      showLogoutDialog(context, () {
                                        context.read<AuthBloc>().add(
                                            AuthLogoutRequested(context
                                                    .read<AuthBloc>()
                                                    .token ??
                                                ApiService.token ??
                                                ""));
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.logout,
                                      color: ColorManager.red,
                                    ),
                                  );
                                },
                              ),
                            ),
                            leading: Container(
                              height: 85.h,
                              width: 85.h,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    profileModel?.profileImage ??
                                        ConstManager.tempImage,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                color: Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.w),
                            title: Text(
                              profileModel?.name ?? ConstManager.userModel.name,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: ColorManager.c1,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // titleAlignment: ,
                            subtitle: Text(
                              profileModel?.email ??
                                  ConstManager.userModel.email,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: ColorManager.grey,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          // personal info
                          ProfileCardWidget(
                            title: StringManager.personalInfo.tr(),
                            navigatorFunc: () {
                              context.pushNamed(
                                RouteManager.personalInfo,
                                extra: context.read<ProfileBloc>(),
                              );
                            },
                          ),
                          //medical record
                          ProfileCardWidget(
                            title: StringManager.medicalRecord.tr(),
                            navigatorFunc: () {
                              context.pushNamed(RouteManager.medicalRecord);
                            },
                          ),
                          // medicine calendar
                          ProfileCardWidget(
                            title: StringManager.medicineCalendar.tr(),
                            navigatorFunc: () {
                              context.pushNamed(RouteManager.medicineCalendar);
                            },
                          ),
                          // consultaition logs
                          ProfileCardWidget(
                            title: StringManager.consultationLogs.tr(),
                            navigatorFunc: () {
                              context.pushNamed(RouteManager.consultationLogs);
                            },
                          ),
                          // supervision
                          ProfileCardWidget(
                            title: StringManager.supervision.tr(),
                            navigatorFunc: () {
                              context.pushNamed(RouteManager.supervision);
                            },
                          ),
                          ProfileCardWidget(
                            title: StringManager.activities.tr(),
                            navigatorFunc: () {
                              context.pushNamed(RouteManager.activities);
                            },
                          ),
                          // FIXME:
                          // SizedBox(height: 100.h),

                          // CustomTextIconButton(
                          //   text: StringManager.deleteAccount.tr(),
                          //   onPressed: () {
                          //     //TODO: implement Function
                          //   },
                          //   color: ColorManager.red,
                          //   icon: Icons.delete_outline_rounded,
                          // ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                      if (state is ProfileLoading)
                        SizedBox(
                          height: 1.sh,
                          child: const LoadingWidget(
                            fullScreen: true,
                          ),
                        )
                    ],
                  ),
                );
              },
            ),
          ),
        )),
      ),
    );
  }
}
