import 'package:akemha/config/router/route_manager.dart';
import 'package:akemha/config/theme/color_manager.dart';
import 'package:akemha/core/resource/asset_manager.dart';
import 'package:akemha/core/resource/string_manager.dart';
import 'package:akemha/core/utils/services/api_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/firebase/firebase_api.dart';
import '../../../../core/utils/global_snackbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoginSuccess) {
          if (ApiService.userRole == "USER" ||
              ApiService.userRole == "DOCTOR") {
            gShowSuccessSnackBar(
                context: context, message: StringManager.welcome.tr());
          } else {
            gShowErrorSnackBar(
                context: context, message: "Only Users and Doctor can login");
          }
          if (ApiService.userRole == "USER") {
            context.goNamed(RouteManager.home);
          } else if (ApiService.userRole == "DOCTOR") {
            context.goNamed(RouteManager.doctorHome);
          }
        }
        if (state is AuthLoginFailed) {
          gShowErrorSnackBar(context: context, message: state.faliuer.message);
        }
      },
      builder: (context, state) {
        return SafeArea(
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
              // gradient: LinearGradient(
              //   begin: Alignment.topRight,
              //   end: Alignment.bottomLeft,
              //   stops: const [0.25, .92, 1],
              //   colors: [ColorManager.white, ColorManager.c3, ColorManager.c1],
              // ),
            ),
            child: Form(
              key: _formKey,
              child: Scaffold(
                backgroundColor: ColorManager.transparent,
                body: SingleChildScrollView(
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 100.h,
                          ),
                          Hero(
                            tag: "logo",
                            child: Image.asset(
                              AssetImageManager.logo,
                              width: 275.r,
                              height: 275.r,
                            ),
                          ),
                          Text(
                            StringManager.welcome.tr(),
                            style: TextStyle(fontSize: 30.sp),
                          ),
                          SizedBox(
                            height: 50.h,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 400.w,
                                child: CustomTextField(
                                  textEditingController: phoneController,
                                  hintText: StringManager.phoneOrUsername.tr(),
                                  // width: 345.w,
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
                                  // width: 345.w,
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
                              CustomButton(
                                text: StringManager.login.tr(),
                                width: 178.w,
                                height: 50.h,
                                fontSize: 15.sp,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                          AuthLoginEvent(
                                            email: phoneController.text,
                                            password: passwordController.text,
                                            deviceToken: FirebaseApi.fcmToken,
                                          ),
                                        );
                                  }
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("${StringManager.dontHaveAccount.tr()} "),
                              GestureDetector(
                                child: Text(
                                  StringManager.createAccount.tr(),
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onTap: () {
                                  context.pushNamed(RouteManager.register);
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 100.h,
                          ),
                          Text(StringManager.appSumury.tr()),
                        ],
                      ),
                      if (state is AuthLoading)
                        SizedBox(
                          height: 1.sh,
                          child: const LoadingWidget(
                            fullScreen: false,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
