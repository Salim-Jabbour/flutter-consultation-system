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
import '../../../../core/utils/global_snackbar.dart';
import '../../../../core/utils/services/api_service.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../model/medical_record_model.dart';
import '../bloc/medical_record_bloc.dart';
import '../widgets/additional_info_widget.dart';
import '../widgets/blood_type_widget.dart';
import '../widgets/height_weight_widget.dart';
import '../widgets/switch_button_widget.dart';

class AddMedicalRecordPage extends StatefulWidget {
  const AddMedicalRecordPage({
    super.key,
    required this.model,
  });
  final MedicalRecordModelData? model;

  @override
  State<AddMedicalRecordPage> createState() => _AddMedicalRecordPageState();
}

class _AddMedicalRecordPageState extends State<AddMedicalRecordPage> {
  late MedicalRecordModelData model;
  late MedicalRecordBloc _bloc;
  @override
  void initState() {
    model = widget.model ??
        MedicalRecordModelData(
            id: 0,
            coffee: false,
            alcohol: false,
            married: false,
            smoker: false,
            covidVaccine: false,
            height: 80,
            weight: 50,
            bloodType: BloodType.oPositive,
            previousSurgeries: [],
            previousIllnesses: [],
            allergies: [],
            familyHistoryOfIllnesses: []);

    // BLoC
    _bloc = GetIt.I.get<MedicalRecordBloc>();

    // bools
    _bloc.add(MedicalRecordChangeCoffee(widget.model?.coffee ?? model.coffee));
    _bloc
        .add(MedicalRecordChangeAlcohol(widget.model?.alcohol ?? model.coffee));
    _bloc.add(MedicalRecordChangeSmoker(widget.model?.smoker ?? model.coffee));
    _bloc
        .add(MedicalRecordChangeMarried(widget.model?.married ?? model.coffee));
    _bloc.add(MedicalRecordChangeCovidVaccine(
        widget.model?.covidVaccine ?? model.coffee));

    // doubles
    _bloc.add(MedicalRecordPatientHeight(widget.model?.height ?? model.height));
    _bloc.add(MedicalRecordPatientWeight(widget.model?.weight ?? model.weight));

    // blood type
    _bloc.add(MedicalRecordChangeBloodType(
        widget.model?.bloodType ?? model.bloodType));

    // additional info
    _bloc.add(MedicalRecordAddPreviousSurgieries(
        widget.model?.previousSurgeries ?? []));
    _bloc.add(MedicalRecordAddPreviousIllnesses(
        widget.model?.previousIllnesses ?? []));
    _bloc.add(MedicalRecordAddAllergies(widget.model?.allergies ?? []));
    _bloc.add(MedicalRecordAddFamilyHistoryofIllnesses(
        widget.model?.familyHistoryOfIllnesses ?? []));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '${StringManager.add.tr()} ${StringManager.medicalRecord.tr()}',
      ),
      body: BlocProvider(
        create: (context) => _bloc,
        child: SingleChildScrollView(
          child: BlocConsumer<MedicalRecordBloc, MedicalRecordState>(
            listener: (context, state) {
              if (state is MedicalRecordPostFailed) {
                gShowErrorSnackBar(
                    context: context, message: state.failure.message);
              }
              if (state is MedicalRecordPostSuccess) {
                gShowSuccessSnackBar(
                    context: context,
                    message: StringManager.updatedSuccessfully.tr());
              }
              if (state is MedicalRecordInitial) {
                context.goNamed(
                  RouteManager.profile,
                );
              }
            },
            builder: (context, state) {
              if (state is MedicalRecordLoading) {
                return const LoadingWidget(
                  fullScreen: true,
                );
              }
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
                            value: model.coffee,
                            isGet: false,
                            getValueFunc: (boolValue) {
                              _bloc.add(MedicalRecordChangeCoffee(boolValue));
                            },
                          ),
                        ),

                        // alcohol
                        SizedBox(
                          height: 60.h,
                          child: SwitchButtonWidget(
                            title: StringManager.alcohol.tr(),
                            icon: Icons.liquor_rounded,
                            value: model.alcohol,
                            isGet: false,
                            getValueFunc: (boolValue) {
                              _bloc.add(MedicalRecordChangeAlcohol(boolValue));
                            },
                          ),
                        ),

                        // smoker
                        SizedBox(
                          height: 60.h,
                          child: SwitchButtonWidget(
                            title: StringManager.smoker.tr(),
                            icon: Icons.smoking_rooms_rounded,
                            value: model.smoker,
                            isGet: false,
                            getValueFunc: (boolValue) {
                              _bloc.add(MedicalRecordChangeSmoker(boolValue));
                            },
                          ),
                        ),

                        //married
                        SizedBox(
                          height: 60.h,
                          child: SwitchButtonWidget(
                            title: StringManager.married.tr(),
                            icon: Icons.favorite_rounded,
                            value: model.married,
                            isGet: false,
                            getValueFunc: (boolValue) {
                              _bloc.add(MedicalRecordChangeMarried(boolValue));
                            },
                          ),
                        ),

                        // covid vaccine
                        SizedBox(
                          height: 60.h,
                          child: SwitchButtonWidget(
                            title: StringManager.covidVaccine.tr(),
                            icon: Icons.vaccines,
                            value: model.covidVaccine,
                            isGet: false,
                            getValueFunc: (boolValue) {
                              _bloc.add(
                                  MedicalRecordChangeCovidVaccine(boolValue));
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        // height
                        HeightWeightWidget(
                          title: StringManager.height.tr(),
                          icon: Icons.height_rounded,
                          isGet: false,
                          isheight: true,
                          volume: model.height,
                        ),

                        // weight
                        HeightWeightWidget(
                          title: StringManager.weight.tr(),
                          icon: Icons.scale_rounded,
                          isGet: false,
                          isheight: false,
                          volume: model.weight,
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
                          selectedBloodType: model.bloodType.name,
                          isGet: false,
                        ),

                        const SizedBox(height: 10),

                        AdditionalInfoWidget(
                          title: StringManager.previousSurgeries.tr(),
                          isGet: false,
                          list: model.previousSurgeries,
                          type: AdditionalInfoType.previousSurgeries,
                          getListFunc: (newList) {
                            context.read<MedicalRecordBloc>().add(
                                MedicalRecordAddPreviousSurgieries(newList));
                          },
                          suggestionList: _bloc.suggestPreviousSurgeries,
                        ),

                        const SizedBox(height: 10),

                        AdditionalInfoWidget(
                          title: StringManager.previousIllnesses.tr(),
                          isGet: false,
                          list: model.previousIllnesses,
                          type: AdditionalInfoType.previousIllness,
                          getListFunc: (newList) {
                            context.read<MedicalRecordBloc>().add(
                                MedicalRecordAddPreviousIllnesses(newList));
                          },
                          suggestionList: _bloc.suggestPreviousIllnesses,
                        ),

                        const SizedBox(height: 10),

                        AdditionalInfoWidget(
                          title: StringManager.allergies.tr(),
                          isGet: false,
                          list: model.allergies,
                          type: AdditionalInfoType.allergies,
                          getListFunc: (newList) {
                            context
                                .read<MedicalRecordBloc>()
                                .add(MedicalRecordAddAllergies(newList));
                          },
                          suggestionList: _bloc.suggestAllergies,
                        ),

                        const SizedBox(height: 10),

                        AdditionalInfoWidget(
                          title: StringManager.familyHistoryOfIllnesses.tr(),
                          isGet: false,
                          list: model.familyHistoryOfIllnesses,
                          type: AdditionalInfoType.familyHistoryOfIllnesses,
                          getListFunc: (newList) {
                            context.read<MedicalRecordBloc>().add(
                                MedicalRecordAddFamilyHistoryofIllnesses(
                                    newList));
                          },
                          suggestionList: _bloc.suggestFamilyHistoryOfIllnesses,
                        ),

                        const SizedBox(height: 20),

                        Center(
                          child: CustomButton(
                            onPressed: () {
                              MedicalRecordModelData data =
                                  MedicalRecordModelData(
                                id: 10000,
                                coffee: _bloc.coffee!,
                                alcohol: _bloc.alcohol!,
                                married: _bloc.married!,
                                smoker: _bloc.smoker!,
                                covidVaccine: _bloc.covidVaccine!,
                                height: _bloc.patientHeight!,
                                weight: _bloc.patientWeight!,
                                bloodType: _bloc.bloodType!,
                                previousSurgeries: _bloc.previousSurgeries!,
                                previousIllnesses: _bloc.previousIllnesses!,
                                allergies: _bloc.allergies!,
                                familyHistoryOfIllnesses:
                                    _bloc.familyHistoryOfIllnesses!,
                              );
                              _bloc.add(
                                MedicalRecordPostEvent(
                                    token: context.read<AuthBloc>().token ??
                                        ApiService.token ??
                                        '',
                                    data: data),
                              );
                            },
                            color: ColorManager.c2,
                            text: StringManager.add.tr(),
                            fontSize: 14.sp,
                            width: 150.w,
                          ),
                        ),
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
