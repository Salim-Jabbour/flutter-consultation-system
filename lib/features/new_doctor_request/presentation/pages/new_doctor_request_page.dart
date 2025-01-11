import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/firebase/firebase_api.dart';
import '../../../../core/resource/string_manager.dart';
import '../../../../core/utils/global_snackbar.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../consultation/models/specialization.dart';
import '../../../consultation/presentation/page/request_consultation_page.dart';
import '../bloc/new_doctor_request_bloc.dart';
import '../widgets/custom_radio_widget.dart';
import '../widgets/upload_cv_widget.dart';

class NewDoctorRequestPage extends StatefulWidget {
  const NewDoctorRequestPage({super.key});

  @override
  State<NewDoctorRequestPage> createState() => _NewDoctorRequestPageState();
}

class _NewDoctorRequestPageState extends State<NewDoctorRequestPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController aboutMeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();

  List<Specialization> specializations = [];

  late NewDoctorRequestBloc _bloc;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String gender = "MALE";

  @override
  void initState() {
    _bloc = GetIt.I.get<NewDoctorRequestBloc>();

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    aboutMeController.dispose();
    nameController.dispose();
    _specializationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: ColorManager.c3,
        appBar: CustomAppBar(
          title: StringManager.newDoctorRequest.tr(),
        ),
        body: SingleChildScrollView(
          child: BlocProvider(
            create: (context) => _bloc,
            child: BlocConsumer<NewDoctorRequestBloc, NewDoctorRequestState>(
              listener: (context, state) {
                if (state is NewDoctorRequestSuccess) {
                  gShowSuccessSnackBar(
                    context: context,
                    message: state.message,
                  );
                  Navigator.of(context).pop();
                }
                if (state is NewDoctorRequestFailure) {
                  gShowErrorSnackBar(
                    context: context,
                    message: state.failure.message,
                  );
                }
                if (state is DoctorProfileSpecializationSuccess) {
                  specializations = state.model.data;
                }
              },
              builder: (context, state) {
                if (state is DoctorProfileSpecializationFailure) {
                  return FailureWidget(
                    errorMessage: state.failure.message,
                    onPressed: () {
                      _bloc.add(const DoctorProfileGetSpecializationsEvent());
                    },
                  );
                }
                if (state is NewDoctorRequestInitial) {
                  // to get specializations
                  _bloc.add(const DoctorProfileGetSpecializationsEvent());
                }
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          // CV
                          UploadCvWidget(bloc: _bloc),

                          const SizedBox(height: 32),
                          //NAME
                          SizedBox(
                            width: 400.w,
                            child: CustomTextField(
                              keyboardType: TextInputType.name,
                              textEditingController: nameController,
                              hintText: StringManager.userNameHintText.tr(),
                              icon: Icons.account_circle_outlined,
                              textFieldColor: ColorManager.c3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return StringManager.emptyFieldError.tr();
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          // EMAIL
                          SizedBox(
                            width: 400.w,
                            child: CustomTextField(
                              keyboardType: TextInputType.emailAddress,
                              textEditingController: emailController,
                              hintText: StringManager.email.tr(),
                              icon: Icons.email,
                              textFieldColor: ColorManager.c3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return StringManager.emptyFieldError.tr();
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          // About Me
                          SizedBox(
                            width: 400.w,
                            child: CustomTextField(
                              suffixIconWidget: null,
                              visibility: false,
                              textEditingController: aboutMeController,
                              hintText: StringManager.aboutMe.tr(),
                              icon: Icons.info_outline_rounded,
                              textFieldColor: ColorManager.c3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return StringManager.emptyFieldError.tr();
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),

                          // specialization
                          Center(
                            child: CustomDropdownButton(
                              controller: _specializationController,
                              values: specializations.sublist(0),
                              title: StringManager.specialization.tr(),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("${StringManager.gender.tr()}: "),
                              const Spacer(),
                              CustomRadioWidget(
                                onChange: (value) {
                                  gender = value;
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 48),

                          CustomButton(
                            color: ColorManager.c2,
                            text: StringManager.add.tr(),
                            fontSize: 14.sp,
                            width: 200.w,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _bloc.add(
                                  NewDoctorRequestAddEvent(
                                    file: _bloc.pdfFile,
                                    aboutMe: aboutMeController.text,
                                    emailAddress: emailController.text,
                                    name: nameController.text,
                                    deviceToken: FirebaseApi.fcmToken,
                                    gender: gender,
                                    specializationId:
                                        _specializationController.text.isEmpty
                                            ? "0"
                                            : _specializationController.text,
                                  ),
                                );
                              } else {
                                gShowErrorSnackBar(
                                  context: context,
                                  message: StringManager.missingData.tr(),
                                );
                                return;
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    if (state is NewDoctorRequestLoading)
                      const LoadingWidget(fullScreen: true)
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
