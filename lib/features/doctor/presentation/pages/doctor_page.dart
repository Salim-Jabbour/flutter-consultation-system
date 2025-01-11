import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/string_manager.dart';
import '../../../../core/utils/services/api_service.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/empty_widget.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../../../core/widgets/header_page.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../model/doctor_model.dart';
import '../bloc/doctor_bloc.dart';
import '../widgets/doctor_details_card.dart';

class DoctorPage extends StatefulWidget {
  const DoctorPage({super.key});

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  List<DoctorDataModel>? doctorDataModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I.get<DoctorBloc>(),
      child: Scaffold(
        backgroundColor: ColorManager.c3,
        body: BlocConsumer<DoctorBloc, DoctorState>(listener: (context, state) {
          if (state is DoctorGetDoctorsSuccess) {
            doctorDataModel = state.doctorModel.doctorDataModel;
          }

          if (state is DoctorSearchDoctorsSuccess) {
            doctorDataModel = state.doctorModel.doctorDataModel;
          }
        }, builder: (context, state) {
          if (state is DoctorGetDoctorsFailed) {
            return SizedBox(
              height: 1.sh,
              child: FailureWidget(
                errorMessage: state.failure.message,
                onPressed: () {
                  context.read<DoctorBloc>().add(DoctorGetDoctorsEvent(
                      token: context.read<AuthBloc>().token ??
                          ApiService.token ??
                          ''));
                },
              ),
            );
          }
          if (state is DoctorSearchDoctorsFailure) {
            return FailureWidget(
              errorMessage: state.failure.message,
              onPressed: () {
                context.read<DoctorBloc>().add(DoctorGetDoctorsEvent(
                    token: context.read<AuthBloc>().token ??
                        ApiService.token ??
                        ''));
              },
            );
          }
          if (state is DoctorInitial) {
            context.read<DoctorBloc>().add(DoctorGetDoctorsEvent(
                token:
                    context.read<AuthBloc>().token ?? ApiService.token ?? ''));
          }
          if (state is DoctorLoading) {
            return SizedBox(
              height: 1.sh,
              child: const LoadingWidget(
                fullScreen: true,
              ),
            );
          }
          if (state is DoctorGetDoctorsSuccess &&
              state.doctorModel.doctorDataModel!.isEmpty) {
            return EmptyWidget(height: 1.sh);
          }
          return SizedBox(
            height: 1.sh,
            // width: 1.sw,
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<DoctorBloc>().add(DoctorGetDoctorsEvent(
                    token: context.read<AuthBloc>().token ??
                        ApiService.token ??
                        ''));
              },
              child: Stack(
                children: [
                  Column(
                    children: [
                      HeaderPage(
                        title: StringManager.doctors.tr(),
                        left: true,
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: CustomTextField(
                          hintText: "Search doctors",
                          icon: Icons.search_rounded,
                          onFieldSubmittedFunc: (inputs) {
                            String search = inputs == null
                                ? ''
                                : inputs.replaceAll(RegExp(r'^\s+'), '');
                            if (search.isNotEmpty) {
                              context.read<DoctorBloc>().add(
                                  DoctorSearchDoctorsEvent(
                                      token: context.read<AuthBloc>().token ??
                                          ApiService.token ??
                                          '',
                                      keyword: search));
                            }
                            return;
                          },
                          textFieldColor: Colors.white,
                          // width: 00.w,
                          // height: 100.h,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: doctorDataModel?.length ?? 0,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                SizedBox(
                                  width: 400.w,
                                  height: 180.h,
                                  child: DoctorDetailsCard(
                                    doctorDataModel: doctorDataModel![index],
                                  ),
                                ),
                                (doctorDataModel!.length - 1) == index
                                    ? const SizedBox.shrink()
                                    : Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 50.w),
                                        child: const Divider(),
                                      ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  if (state is DoctorSearchDoctorsSuccess &&
                      state.doctorModel.doctorDataModel!.isEmpty)
                    EmptyWidget(height: 1.sh)
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
