// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../../config/theme/color_manager.dart';
import '../../../../../core/resource/const_manager.dart';
import '../../../../../core/resource/string_manager.dart';
import '../../../../../core/utils/services/api_service.dart';
import '../../../../../core/widgets/failure_widget.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../profile/presentation/widgets/profile_card_widget.dart';
import '../../models/beneficiary_profile_model.dart';
import '../manager/profile_bloc/review_beneficiary_profile_bloc.dart';
import '../widgets/rich_text_widget.dart';
import 'beneficiary_consultation_page.dart';
import 'beneficiary_medical_record_page.dart';
import 'beneficiary_medicines_page.dart';

class BeneficiaryProfilePage extends StatelessWidget {
  BeneficiaryProfilePage({super.key, required this.userId});

  final String userId;
  BeneficiaryProfileDetails? model;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.c3,
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => GetIt.I.get<ReviewBeneficiaryProfileBloc>(),
          child: BlocConsumer<ReviewBeneficiaryProfileBloc,
              ReviewBeneficiaryProfileState>(
            listener: (context, state) {
              if (state is ReviewBeneficiaryProfileSuccess) {
                model = state.beneficiaryProfileModel.data;
              }
            },
            builder: (context, state) {
              if (state is ReviewBeneficiaryProfileInitial) {
                context.read<ReviewBeneficiaryProfileBloc>().add(
                      ReviewBeneficiaryGetProfileEvent(
                        token: context.read<AuthBloc>().token ??
                            ApiService.token ??
                            '',
                        userId: userId,
                      ),
                    );
              }

              if (state is ReviewBeneficiaryProfileLoading) {
                return const Padding(
                  padding: EdgeInsets.only(top: 60.0),
                  child: LoadingWidget(fullScreen: true),
                );
              }
              if (state is ReviewBeneficiaryProfileFailure) {
                return Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: FailureWidget(
                    errorMessage: state.failure.message,
                    onPressed: () {
                      context.read<ReviewBeneficiaryProfileBloc>().add(
                            ReviewBeneficiaryGetProfileEvent(
                              token: context.read<AuthBloc>().token ??
                                  ApiService.token ??
                                  '',
                              userId: userId,
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
                                model?.profileImage ?? ConstManager.tempImage,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Center(
                          child: Text(
                            model?.name ?? ConstManager.userModel.name,
                            style: TextStyle(
                              color: ColorManager.c1,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        RichTextWidget(
                          first: "${StringManager.phone.tr()}: ",
                          second: model?.phoneNumber ?? "09999999",
                        ),
                        const SizedBox(height: 8),
                        RichTextWidget(
                          first: "${StringManager.dob.tr()}: ",
                          second: model?.dob ?? "01-01-2000",
                        ),
                        const SizedBox(height: 8),
                        RichTextWidget(
                          first: "${StringManager.gender.tr()}: ",
                          second: model?.gender ?? "MALE",
                        ),
                        ProfileCardWidget(
                          title: StringManager.medicalRecord.tr(),
                          paddingValue: 16,
                          navigatorFunc: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BeneficiaryMedicalProfilePage(
                                            userId: userId)));
                          },
                        ),
                        ProfileCardWidget(
                          title: StringManager.medicineCalendar.tr(),
                          paddingValue: 8,
                          navigatorFunc: () {
                            // TODO
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BeneficiaryMedicinesPage(
                                            beneficiaryId: userId)));
                          },
                        ),
                        ProfileCardWidget(
                          title: StringManager.consultationLogs.tr(),
                          paddingValue: 8,
                          navigatorFunc: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BeneficiaryConsultationPage(
                                            userId: userId)));
                          },
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
