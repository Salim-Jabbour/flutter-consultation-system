// ignore_for_file: must_be_immutable

import 'package:akemha/features/profile/presentation/widgets/logout_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../../config/router/route_manager.dart';
import '../../../../../config/theme/color_manager.dart';
import '../../../../../core/resource/const_manager.dart';
import '../../../../../core/resource/string_manager.dart';
import '../../../../../core/utils/global_snackbar.dart';
import '../../../../../core/utils/services/api_service.dart';
import '../../../../../core/widgets/custom_text_icon_button.dart';
import '../../../../../core/widgets/failure_widget.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../profile/presentation/widgets/profile_card_widget.dart';
import '../manager/doctor_profile/doctor_profile_bloc.dart';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({super.key});

  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  late DoctorProfileBloc _bloc;

  @override
  void initState() {
    _bloc = GetIt.I.get<DoctorProfileBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.c3,
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => _bloc,
          child: BlocConsumer<DoctorProfileBloc, DoctorProfileState>(
            listener: (context, state) {
              if (state is DoctorGetProfileSuccess) {
                _bloc.model = state.model.data;
              }
            },
            builder: (context, state) {
              if (state is DoctorProfileInitial) {
                context.read<DoctorProfileBloc>().add(
                      DoctorGetProfileEvent(
                        context.read<AuthBloc>().token ??
                            ApiService.token ??
                            '',
                        context.read<AuthBloc>().userId ??
                            ApiService.userId ??
                            '2',
                      ),
                    );
              }

              if (state is DoctorProfileLoading) {
                return Padding(
                  padding: EdgeInsets.only(top: 60.0.h),
                  child: const LoadingWidget(fullScreen: true),
                );
              }
              if (state is DoctorGetProfileFailure) {
                return Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: FailureWidget(
                    errorMessage: state.failure.message,
                    onPressed: () {
                      context.read<DoctorProfileBloc>().add(
                            DoctorGetProfileEvent(
                              context.read<AuthBloc>().token ??
                                  ApiService.token ??
                                  '',
                              context.read<AuthBloc>().userId ??
                                  ApiService.userId ??
                                  '2',
                            ),
                          );
                    },
                  ),
                );
              }
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        Center(
                          child: SizedBox(
                            height: 200,
                            width: 150,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Image.network(
                                _bloc.model?.profileImage ??
                                    ConstManager.tempImage,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Center(
                          child: Text(
                            _bloc.model?.name ?? ConstManager.userModel.name,
                            style: TextStyle(
                              color: ColorManager.c1,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: Text(
                            _bloc.model?.specialization?.name ?? "أُخرى",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded,
                                color: ColorManager.c1, size: 25),
                            const SizedBox(width: 8),
                            Text(
                              _bloc.model?.location != null &&
                                      _bloc.model!.location!.length > 30
                                  ? "${_bloc.model!.location!.substring(0, 27)} ..."
                                  : _bloc.model?.location ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                color: ColorManager.c2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.timelapse_rounded,
                              color: ColorManager.c1,
                              size: 25,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _bloc.model?.openingTimes != null &&
                                      _bloc.model!.openingTimes!.length > 30
                                  ? "${_bloc.model!.openingTimes!.substring(0, 27)} ..."
                                  : _bloc.model?.openingTimes ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                color: ColorManager.c2,
                              ),
                            ),
                          ],
                        ),
                        // personal info
                        ProfileCardWidget(
                          title: StringManager.personalInfo.tr(),
                          paddingValue: 16,
                          navigatorFunc: () {
                            context.pushNamed(RouteManager.doctorPersonalInfo,
                                extra: {
                                  'model': _bloc.model,
                                  'bloc': _bloc,
                                });
                          },
                        ),
                        // doctor's posts
                        ProfileCardWidget(
                          title: StringManager.posts.tr(),
                          paddingValue: 8,
                          navigatorFunc: () {
                            context.pushNamed(
                              RouteManager.doctorPosts,
                              extra: "${_bloc.model?.id ?? 2}",
                            );
                          },
                        ),
                        // doctor's consultations log
                        ProfileCardWidget(
                          title: StringManager.consultationLogs.tr(),
                          paddingValue: 8,
                          navigatorFunc: () {
                            context.pushNamed(
                              RouteManager.doctorConsultationsLog,
                            );
                          },
                        ),
                        ProfileCardWidget(
                          title: StringManager.activities.tr(),
                          paddingValue: 8,
                          navigatorFunc: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ActivitiesPage()));

                            context.pushNamed(
                              RouteManager.doctorActivites,
                            );
                          },
                        ),
                        // FIXME
                        // const SizedBox(height: 16),
                        // Center(
                        //   child: CustomTextIconButton(
                        //     width: 300,
                        //     text: StringManager.deleteAccount.tr(),
                        //     onPressed: () {
                        //       //TODO: implement Function
                        //     },
                        //     color: ColorManager.red,
                        //     icon: Icons.delete_outline_rounded,
                        //   ),
                        // ),
                        const SizedBox(height: 10), const SizedBox(height: 16),
                        Center(
                          child: BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is AuthLogoutSuccess) {
                                gShowSuccessSnackBar(
                                    context: context,
                                    message: StringManager.logoutSuccess.tr());

                                context
                                    .pushReplacementNamed(RouteManager.login);
                              }

                              if (state is AuthLogoutFailed) {
                                gShowErrorSnackBar(
                                    context: context,
                                    message: StringManager.sthWrong.tr());
                                context.pop();
                              }
                            },
                            builder: (context, state) {
                              return CustomTextIconButton(
                                width: 300,
                                text: StringManager.logout.tr(),
                                onPressed: () {
                                  showLogoutDialog(context, () {
                                    context.read<AuthBloc>().add(
                                        AuthLogoutRequested(
                                            context.read<AuthBloc>().token ??
                                                ApiService.token ??
                                                ""));
                                  });
                                },
                                color: ColorManager.red,
                                icon: Icons.delete_outline_rounded,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
