import 'package:akemha/core/widgets/custom_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/route_manager.dart';
import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/string_manager.dart';
import '../../../../core/utils/services/api_service.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../model/medical_record_model.dart';
import '../bloc/medical_record_bloc.dart';
import '../widgets/add_medical_record_button.dart';
import '../widgets/additional_info_widget.dart';
import '../widgets/blood_type_widget.dart';
import '../widgets/height_weight_widget.dart';
import '../widgets/switch_button_widget.dart';

class MedicalRecordPage extends StatefulWidget {
  const MedicalRecordPage({super.key});

  @override
  State<MedicalRecordPage> createState() => _MedicalRecordPageState();
}

class _MedicalRecordPageState extends State<MedicalRecordPage> {
  MedicalRecordModelData? model;
  BloodType? bloodType;

  List<AdditionalRecordInfoResponse>? surgeriesList;
  List<AdditionalRecordInfoResponse>? illnessesList;
  List<AdditionalRecordInfoResponse>? allergiesList;
  List<AdditionalRecordInfoResponse>? familyIllnessesList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: StringManager.medicalRecord.tr(),
      ),
      body: BlocProvider(
        create: (context) => GetIt.I.get<MedicalRecordBloc>(),
        child: SingleChildScrollView(
          child: BlocConsumer<MedicalRecordBloc, MedicalRecordState>(
            listener: (context, state) {
              if (state is MedicalRecordGetSuccess) {
                model = state.medicalRecordModel.data;
                bloodType = state.medicalRecordModel.data?.bloodType;
                surgeriesList =
                    state.medicalRecordModel.data?.previousSurgeries ?? [];
                illnessesList =
                    state.medicalRecordModel.data?.previousIllnesses ?? [];
                allergiesList = state.medicalRecordModel.data?.allergies ?? [];
                familyIllnessesList =
                    state.medicalRecordModel.data?.familyHistoryOfIllnesses ??
                        [];
              }
            },
            builder: (context, state) {
              if (state is MedicalRecordInitial) {
                context.read<MedicalRecordBloc>().add(MedicalRecordGetEvent(
                    token: context.read<AuthBloc>().token ??
                        ApiService.token ??
                        ''));
              }
              if (state is MedicalRecordGetFailed) {
                if (state.failure.message == "Medical Record is Not Found") {
                  return const AddMedicalRecordButton();
                } else {
                  return FailureWidget(
                    errorMessage: state.failure.message,
                    onPressed: () {
                      context.read<MedicalRecordBloc>().add(
                          MedicalRecordGetEvent(
                              token: context.read<AuthBloc>().token ??
                                  ApiService.token ??
                                  ''));
                    },
                  );
                }
              }
              if (state is MedicalRecordGetSuccess) {
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // coffee
                          SizedBox(
                            height: 60.h,
                            child: SwitchButtonWidget(
                              title: StringManager.coffee.tr(),
                              icon: Icons.coffee_rounded,
                              value: model?.coffee ?? true,
                              isGet: true,
                            ),
                          ),

                          // alcohol
                          SizedBox(
                            height: 60.h,
                            child: SwitchButtonWidget(
                              title: StringManager.alcohol.tr(),
                              icon: Icons.liquor_rounded,
                              value: model?.alcohol ?? true,
                              isGet: true,
                            ),
                          ),

                          // smoker
                          SizedBox(
                            height: 60.h,
                            child: SwitchButtonWidget(
                              title: StringManager.smoker.tr(),
                              icon: Icons.smoking_rooms_rounded,
                              value: model?.smoker ?? true,
                              isGet: true,
                            ),
                          ),

                          //married
                          SizedBox(
                            height: 60.h,
                            child: SwitchButtonWidget(
                              title: StringManager.married.tr(),
                              icon: Icons.favorite_rounded,
                              value: model?.married ?? true,
                              isGet: true,
                            ),
                          ),

                          // covid vaccine
                          SizedBox(
                            height: 60.h,
                            child: SwitchButtonWidget(
                              title: StringManager.covidVaccine.tr(),
                              icon: Icons.vaccines,
                              value: model?.covidVaccine ?? true,
                              isGet: true,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // height
                          HeightWeightWidget(
                            title: StringManager.height.tr(),
                            icon: Icons.height_rounded,
                            isGet: true,
                            isheight: true,
                            volume: model?.height ?? 180.0,
                          ),
                          // weight
                          HeightWeightWidget(
                            title: StringManager.weight.tr(),
                            icon: Icons.scale_rounded,
                            isGet: true,
                            isheight: false,
                            volume: model?.weight ?? 80.0,
                          ),

                          const SizedBox(height: 20),
                          Text(
                            "${StringManager.bloodType.tr()}:",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: ColorManager.c1,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),

                          /// blood type
                          BloodTypeWidget(
                            selectedBloodType:
                                bloodType?.name ?? BloodType.oPositive.name,
                            isGet: true,
                          ),

                          const SizedBox(height: 10),

                          AdditionalInfoWidget(
                            title: StringManager.previousSurgeries.tr(),
                            isGet: true,
                            list: surgeriesList ?? [],
                            type: AdditionalInfoType.previousSurgeries,
                            suggestionList: const [],
                          ),

                          const SizedBox(height: 10),

                          AdditionalInfoWidget(
                            title: StringManager.previousIllnesses.tr(),
                            isGet: true,
                            list: illnessesList ?? [],
                            type: AdditionalInfoType.previousIllness,
                            suggestionList: const [],
                          ),
                          const SizedBox(height: 10),
                          AdditionalInfoWidget(
                            title: StringManager.allergies.tr(),
                            isGet: true,
                            list: allergiesList ?? [],
                            type: AdditionalInfoType.allergies,
                            suggestionList: const [],
                          ),
                          const SizedBox(height: 10),
                          AdditionalInfoWidget(
                            title: StringManager.familyHistoryOfIllnesses.tr(),
                            isGet: true,
                            list: familyIllnessesList ?? [],
                            type: AdditionalInfoType.familyHistoryOfIllnesses,
                            suggestionList: const [],
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: CustomButton(
                              onPressed: () {
                                context.pushNamed(
                                  RouteManager.addMedicalRecord,
                                  extra: model,
                                );
                              },
                              color: ColorManager.c2,
                              text: StringManager.update.tr(),
                              fontSize: 14.sp,
                              width: 150.w,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              if (state is MedicalRecordLoading) {
                const LoadingWidget(
                  fullScreen: true,
                );
              }
              return const LoadingWidget(
                fullScreen: true,
              );
            },
          ),
        ),
      ),
    );
  }
}
