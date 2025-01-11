// ignore_for_file: must_be_immutable

import 'package:akemha/config/router/route_manager.dart';
import 'package:akemha/config/theme/color_manager.dart';
import 'package:akemha/core/resource/asset_manager.dart';
import 'package:akemha/core/resource/string_manager.dart';
import 'package:akemha/core/utils/dbg_print.dart';
import 'package:akemha/features/auth/presentation/widgets/custom_radio.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/global_snackbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../new_doctor_request/presentation/pages/new_doctor_request_page.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/new_doctor_request_info_widget.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final bool selected = false;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  DateTime birthDate = DateTime.now();
  String gender = 'female';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Container(
          decoration: const BoxDecoration(
            color: ColorManager.c3,
            image: DecorationImage(
              alignment: Alignment.topCenter,
              image: AssetImage(
                AssetImageManager.logo2,
              ),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: ColorManager.transparent,
              scrolledUnderElevation: 0,
              leading: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              actions: [
                NewDoctorRequestInfoWidget(
                  onTapFunction: () {
                    dbg("ENETTERRED HERE");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const NewDoctorRequestPage()));
                  },
                  headline: StringManager.joinAkemha.tr(),
                  headlineDetails: StringManager.joinAkemhaDetails.tr(),
                ),
              ],
            ),
            backgroundColor: ColorManager.transparent,
            body: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSignUpSuccess) {
                  gShowSuccessSnackBar(
                      context: context, message: StringManager.welcome.tr());
                  // Restart.restartApp();
                  context.pushNamed(RouteManager.otp);
                }
                if (state is AuthSignUpFailed) {
                  gShowErrorSnackBar(
                      context: context, message: state.faliuer.message);
                }
              },
              builder: (context, state) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            AssetImageManager.logo,
                            width: 275.r,
                            height: 275.r,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          SizedBox(
                            width: 400.w,
                            child: CustomTextField(
                              textEditingController: usernameController,
                              hintText: StringManager.userNameHintText.tr(),
                              // height: 60.h,
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
                          SizedBox(
                            height: 10.h,
                          ),
                          SizedBox(
                            width: 400.w,
                            child: CustomTextField(
                              textEditingController: phoneController,
                              hintText: StringManager.phone.tr(),
                              // height: 60.h,
                              icon: Icons.phone,
                              textFieldColor: ColorManager.c3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return StringManager.emptyFieldError.tr();
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          SizedBox(
                            width: 400.w,
                            child: CustomTextField(
                              textEditingController: passwordController,
                              hintText: StringManager.password.tr(),
                              // height: 60.h,
                              icon: Icons.password,
                              textFieldColor: ColorManager.c3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return StringManager.emptyFieldError.tr();
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          SizedBox(
                            width: 400.w,
                            child: CustomTextField(
                              textEditingController: confirmPasswordController,
                              hintText: StringManager.confirmPassword.tr(),
                              // height: 60.h,
                              icon: Icons.password,
                              textFieldColor: ColorManager.c3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return StringManager.emptyFieldError.tr();
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          SizedBox(
                            height: 100.h,
                            // width: 400.w,
                            child: CupertinoDatePicker(
                              // FIXME: put constraints on the date
                              initialDateTime: DateTime.now(),
                              maximumDate: DateTime.now(),
                              minimumDate:
                                  DateTime.utc(DateTime.now().year - 100),
                              minimumYear: DateTime.now().year - 100,
                              maximumYear: DateTime.now().year,
                              mode: CupertinoDatePickerMode.date,
                              onDateTimeChanged: (time) {
                                birthDate = time;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomRadio(
                                onChange: (value) {
                                  gender = value;
                                },
                              ),
                              // CustomRadio(Gender("female", Icons.female, false)),
                              // TextButton.icon(
                              //   onPressed: () {},
                              //   style: TextButton.styleFrom(
                              //     iconColor: selected ? ColorManager.c1 : ColorManager.c2,
                              //   ),
                              //   icon: const Icon(Icons.male),
                              //   label: const Text("Male"),
                              // )
                              // IconButton(
                              //   color: selected ? ColorManager.c1 : ColorManager.c2,
                              //   iconSize: 60.r,
                              //   onPressed: () {},
                              //   icon: const Icon(Icons.male),
                              // ),
                              // IconButton(
                              //   color: !selected ? ColorManager.c1 : ColorManager.c2,
                              //   onPressed: () {},
                              //   iconSize: 60.r,
                              //   icon: const Icon(Icons.female),
                              // ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          CustomButton(
                            text: StringManager.login.tr(),
                            width: 178.w,
                            height: 50.h,
                            fontSize: 15.sp,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                dbg("Username ${usernameController.text}");
                                dbg("phone ${phoneController.text}");
                                dbg("password ${passwordController.text}");
                                dbg("con_password ${confirmPasswordController.text}");
                                dbg("bD ${DateFormat('yyyy-MM-dd').format(birthDate)}");
                                dbg("bD $gender");
                                context.read<AuthBloc>().add(
                                      AuthRegisterRequested(
                                        name: usernameController.text,
                                        phone: phoneController.text,
                                        password: passwordController.text,
                                        confirmPassword:
                                            confirmPasswordController.text,
                                        birthDate: birthDate,
                                        gender: gender,
                                      ),
                                    );
                              }
                            },
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(0, 15.0, 0, 10.0),
                            child: Text(StringManager.appSumury.tr()),
                          ),
                        ],
                      ),
                    ),
                    if (state is AuthLoading)
                      SizedBox(
                        height: 1.sh,
                        child: const LoadingWidget(
                          fullScreen: false,
                        ),
                      ),
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
