import 'package:akemha/config/theme/color_manager.dart';
import 'package:akemha/core/resource/asset_manager.dart';
import 'package:akemha/core/resource/string_manager.dart';
import 'package:akemha/core/utils/global_snackbar.dart';
import 'package:akemha/core/widgets/custom_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as text_service;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../../config/router/route_manager.dart';
import '../../../../core/firebase/firebase_api.dart';
import '../../../../core/utils/dbg_print.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../bloc/auth_bloc.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  OtpState createState() => OtpState();
}

class OtpState extends State<OtpPage> {
  TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoginSuccess) {
                gShowSuccessSnackBar(
                    context: context, message: StringManager.welcome.tr());
                context.goNamed(RouteManager.home);
              }
              if (state is AuthLoginFailed) {
                gShowErrorSnackBar(
                    context: context, message: state.faliuer.message);
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  Column(
                    children: [
                      // Align(
                      //   alignment: Alignment.topLeft,
                      //   child: GestureDetector(
                      //     onTap: () => Navigator.pop(context),
                      //     child: const Icon(
                      //       Icons.arrow_back,
                      //       size: 32,
                      //       color: Colors.black54,
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 18,
                      // ),
                      Container(
                        width: 220.w,
                        height: 220.h,
                        decoration: const BoxDecoration(
                          color: ColorManager.c3,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(AssetImageManager.logo),
                      ),
                      SizedBox(
                        height: 60.h,
                      ),
                      Text(
                        StringManager.verification.tr(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.c1,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        StringManager.enterOtp.tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.c2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 28.h,
                      ),
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     _textFieldOTP(first: true, last: false),
                            //     _textFieldOTP(first: false, last: false),
                            //     _textFieldOTP(first: false, last: false),
                            //     _textFieldOTP(first: false, last: false),
                            //     _textFieldOTP(first: false, last: false),
                            //     _textFieldOTP(first: false, last: true),
                            //   ],
                            // ),

                            Directionality(
                              textDirection: text_service.TextDirection.ltr,
                              child: Pinput(
                                controller: codeController,
                                length: 6,
                                // defaultPinTheme: defaultPinTheme,
                                // focusedPinTheme: focusedPinTheme,
                                // submittedPinTheme: submittedPinTheme,
                                inputFormatters: [
                                  text_service
                                      .FilteringTextInputFormatter.digitsOnly
                                ],
                                defaultPinTheme: const PinTheme(
                                  width: 56,
                                  height: 60,
                                  textStyle: TextStyle(),
                                  decoration: BoxDecoration(
                                    color: ColorManager.c3,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                ),
                                showCursor: true,
                                onCompleted: (pin) {
                                  dbg(pin);
                                },
                              ),
                            ),
                            SizedBox(
                              height: 22.h,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  dbg("complete ${codeController.text}");
                                  if (codeController.text.length == 6) {
                                    dbg("AuthVerify");
                                    context.read<AuthBloc>().add(
                                          AuthVerify(
                                            code: codeController.text,
                                            deviceToken: FirebaseApi.fcmToken,
                                          ),
                                        );
                                  } else {
                                    gShowErrorSnackBar(
                                        context: context,
                                        message: "Enter Code First");
                                  }
                                },
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          ColorManager.c2),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Text(
                                    StringManager.verify.tr(),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 58.h,
                      ),
                      Text(
                        StringManager.didntReceiveOtp.tr(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black38,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        StringManager.resendOtp.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.c2,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
              );
            },
          ),
        ),
      ),
    );
  }

// Widget _textFieldOTP({bool? first, last}) {
//   return SizedBox(
//     height: 55,
//     width: 45,
//     child: AspectRatio(
//       aspectRatio: 1.0,
//       child: TextField(
//         autofocus: true,
//         onChanged: (value) {
//           if (value.length == 1 && last == false) {
//             FocusScope.of(context).nextFocus();
//           }
//           if (value.isEmpty && first == false) {
//             FocusScope.of(context).previousFocus();
//           }
//         },
//         showCursor: false,
//         readOnly: false,
//         textAlign: TextAlign.center,
//         style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         keyboardType: TextInputType.number,
//         maxLength: 1,
//         textAlignVertical: TextAlignVertical.top,
//         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//         decoration: InputDecoration(
//           counter: const Offstage(),
//           enabledBorder: OutlineInputBorder(
//               borderSide: const BorderSide(width: 2, color: ColorManager.c3),
//               borderRadius: BorderRadius.circular(12)),
//           focusedBorder: OutlineInputBorder(
//               borderSide: const BorderSide(width: 2, color: ColorManager.c2),
//               borderRadius: BorderRadius.circular(12)),
//         ),
//       ),
//     ),
//   );
// }
}
