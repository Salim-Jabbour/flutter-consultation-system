import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../../config/theme/color_manager.dart';
import '../../../../../core/resource/string_manager.dart';
import '../../../../../core/utils/services/api_service.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/empty_widget.dart';
import '../../../../../core/widgets/failure_widget.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../medical_record/model/medical_record_model.dart';
import '../../../../medical_record/presentation/widgets/additional_info_widget.dart';
import '../../../../medical_record/presentation/widgets/blood_type_widget.dart';
import '../../../../medical_record/presentation/widgets/height_weight_widget.dart';
import '../../../../medical_record/presentation/widgets/switch_button_widget.dart';
import '../manager/medical_record_bloc/beneficiary_medical_record_bloc.dart';

class BeneficiaryMedicalProfilePage extends StatefulWidget {
  const BeneficiaryMedicalProfilePage({super.key, required this.userId});
  final String userId;
  @override
  State<BeneficiaryMedicalProfilePage> createState() =>
      _BeneficiaryMedicalProfilePageState();
}

class _BeneficiaryMedicalProfilePageState
    extends State<BeneficiaryMedicalProfilePage> {
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
        create: (context) => GetIt.I.get<BeneficiaryMedicalRecordBloc>(),
        child: SingleChildScrollView(
          child: BlocConsumer<BeneficiaryMedicalRecordBloc,
              BeneficiaryMedicalRecordState>(
            listener: (context, state) {
              if (state is BeneficiaryMedicalRecordSuccess) {
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
              if (state is BeneficiaryMedicalRecordInitial) {
                context.read<BeneficiaryMedicalRecordBloc>().add(
                    BeneficiaryGetMedicalRecordEvent(
                        token: context.read<AuthBloc>().token ??
                            ApiService.token ??
                            '',
                        userId: widget.userId));
              }
              if (state is BeneficiaryMedicalRecordFailure) {
                if (state.failure.message == "Medical Record is Not Found") {
                  return EmptyWidget(
                    height: 0.7.sh,
                  );
                } else {
                  return FailureWidget(
                    errorMessage: state.failure.message,
                    onPressed: () {
                      context.read<BeneficiaryMedicalRecordBloc>().add(
                          BeneficiaryGetMedicalRecordEvent(
                              token: context.read<AuthBloc>().token ??
                                  ApiService.token ??
                                  '',
                              userId: widget.userId));
                    },
                  );
                }
              }
              if (state is BeneficiaryMedicalRecordSuccess) {
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
                            
                          ),

                          const SizedBox(height: 10),

                          AdditionalInfoWidget(
                            title: StringManager.previousIllnesses.tr(),
                            isGet: true,
                            list: illnessesList ?? [],
                            type: AdditionalInfoType.previousIllness,
                          ),
                          const SizedBox(height: 10),
                          AdditionalInfoWidget(
                            title: StringManager.allergies.tr(),
                            isGet: true,
                            list: allergiesList ?? [],
                            type: AdditionalInfoType.allergies,
                          ),
                          const SizedBox(height: 10),
                          AdditionalInfoWidget(
                            title: StringManager.familyHistoryOfIllnesses.tr(),
                            isGet: true,
                            list: familyIllnessesList ?? [],
                            type: AdditionalInfoType.familyHistoryOfIllnesses,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                );
              }
              if (state is BeneficiaryMedicalRecordLoading) {
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
