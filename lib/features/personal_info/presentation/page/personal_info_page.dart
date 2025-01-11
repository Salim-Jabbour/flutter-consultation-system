import 'dart:io';

import 'package:akemha/core/resource/const_manager.dart';
import 'package:akemha/core/resource/string_manager.dart';
import 'package:akemha/core/utils/global_snackbar.dart';
import 'package:akemha/core/utils/services/api_service.dart';
import 'package:akemha/core/widgets/custom_app_bar.dart';
import 'package:akemha/core/widgets/custom_text_field.dart';
import 'package:akemha/features/personal_info/presentation/bloc/personal_info_bloc.dart';
import 'package:akemha/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/widgets/custom_radio.dart';
import '../widgets/change_password_dialog.dart';

class PersonalInfoPage extends StatefulWidget {
  PersonalInfoPage({super.key, required this.profileBloc});

  final ProfileBloc profileBloc;

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController genderController = TextEditingController();

  final TextEditingController imageController = TextEditingController();

  final OverlayPortalController overlayController = OverlayPortalController();

  PersonalInfoBloc bloc = GetIt.I.get<PersonalInfoBloc>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: StringManager.personalInfo.tr(),
      ),
      // backgroundColor: ColorManager.transparent,
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => bloc,
          child: BlocConsumer<PersonalInfoBloc, PersonalInfoState>(
            listener: (context, state) {
              if (state is PersonalInfoFailure) {
                gShowErrorSnackBar(context: context, message: state.errMessage);
              }
              if (state is UpdatePersonalInfoFailure) {
                gShowErrorSnackBar(context: context, message: state.errMessage);
                context.pop();
              }
              if (state is UpdatePersonalInfoSuccess) {
                widget.profileBloc.add(ProfileGetProfileInfoEvent(
                    token: ApiService.token ?? '',
                    userId: ApiService.userId ?? '0'));
                gShowSuccessSnackBar(
                  context: context,
                  message: StringManager.updatedSuccessfully.tr(),
                );
                context.pop();
              }
            },
            builder: (context, state) {
              if (state is PersonalInfoInitial) {
                bloc.add(GetPersonalInfo(
                    id: int.tryParse(ApiService.userId ?? '0') ?? 0));
              }
              if (state is PersonalInfoSuccess ||
                  state is UpdatePersonalInfoLoading) {
                nameController.text = bloc.info?.name ?? "";
                emailController.text = bloc.info?.email ?? "";
                genderController.text = bloc.info?.gender ?? "";
                DateTime dob = bloc.info?.dob ?? DateTime.now();
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileImage(
                      controller: imageController,
                    ),
                    // CircleAvatar(
                    //   radius: 100.w,
                    //   backgroundImage: const CachedNetworkImageProvider(
                    //     "https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250",
                    //     // width: 275.r,
                    //     // height: 275.r,
                    //   ),
                    // ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      width: 400.w,
                      child: CustomTextField(
                        textEditingController: nameController,
                        hintText: StringManager.username.tr(),
                        icon: Icons.account_circle_outlined,
                        textFieldColor: ColorManager.c3,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      width: 400.w,
                      child: CustomTextField(
                        textEditingController: emailController,
                        hintText: StringManager.email.tr(),
                        icon: Icons.alternate_email,
                        textFieldColor: ColorManager.c3,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      width: 400.w,
                      child: CustomButton(
                        onPressed: () {
                          showChangePasswordDialog(context);
                        },
                        text: StringManager.changePassword.tr(),
                      ),
                      // child: CustomTextField(
                      //   hintText: StringManager.password.tr(),
                      //   height: 60.h,
                      //   icon: Icons.password,
                      //   textFieldColor: ColorManager.c3,
                      // ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      height: 100.h,
                      // width: 400.w,
                      child: CupertinoDatePicker(
                        initialDateTime: dob,
                        maximumDate: DateTime.now(),
                        minimumDate: DateTime.utc(DateTime.now().year - 100),
                        minimumYear: DateTime.now().year - 100,
                        maximumYear: DateTime.now().year,
                        mode: CupertinoDatePickerMode.date,
                        onDateTimeChanged: (time) {
                          dob = time;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomRadio(
                          gender: Gender(
                              (bloc.info?.gender ?? "male").toLowerCase(),
                              ((bloc.info?.gender ?? "male").toLowerCase() ==
                                      "male")
                                  ? Icons.male
                                  : Icons.female,
                              ((bloc.info?.gender ?? "male").toLowerCase() !=
                                  "male")),
                          onChange: (String gender) {
                            genderController.text = gender;
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    CustomButton(
                      text: StringManager.save.tr(),
                      width: 178.w,
                      height: 50.h,
                      fontSize: 15.sp,
                      onPressed: () {
                        overlayController.show();
                        bloc.add(
                          UpdatePersonalInfo(
                            name: nameController.text,
                            email: emailController.text,
                            dob: dob,
                            gender: genderController.text,
                            image: imageController.text != ''
                                ? imageController.text
                                : null,
                          ),
                        );
                      },
                    ),
                    OverlayPortal(
                        controller: overlayController,
                        overlayChildBuilder: (context) {
                          return Container(
                            color: Colors.black.withOpacity(0.22),
                            height: 1.sh,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: LoadingAnimationWidget.inkDrop(
                                      color: ColorManager.c2,
                                      size: 55.r,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Text(
                                      StringManager.loading.tr(),
                                      style: TextStyle(
                                        color: ColorManager.c1,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                  ],
                );
              } else if (state is PersonalInfoFailure) {
                return FailureWidget(
                  errorMessage: state.errMessage,
                  onPressed: () {},
                );
              } else if (state is UpdatePersonalInfoFailure) {
                return FailureWidget(
                  errorMessage: state.errMessage,
                  onPressed: () {},
                );
              } else {
                return const LoadingWidget(fullScreen: true);
              }
            },
          ),
        ),
      ),
    );
  }
}

class ProfileImage extends StatefulWidget {
  const ProfileImage({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        widget.controller.text = pickedFile.path;
      });
    }
  }

  void _showPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Select Image Source",
            style: TextStyle(color: ColorManager.c2, fontSize: 26.sp),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: .6.sw,
              height: .11.sh,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.camera_alt_outlined,
                          size: 60,
                          color: ColorManager.c2,
                        ),
                        Text(
                          "Camera",
                          style: TextStyle(
                              color: ColorManager.c2, fontSize: 18.sp),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.image_outlined,
                          size: 60,
                          color: ColorManager.c2,
                        ),
                        Text(
                          "Gallery",
                          style: TextStyle(
                              color: ColorManager.c2, fontSize: 18.sp),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 75,
          backgroundColor: Colors.grey.shade200,
          child: CircleAvatar(
            radius: 70,
            backgroundImage: ((_image != null)
                ? Image.file(
                    File(_image!.path),
                    fit: BoxFit.cover,
                  ).image
                : context.read<PersonalInfoBloc>().info?.profileImage != null
                    ? CachedNetworkImageProvider(
                        context.read<PersonalInfoBloc>().info?.profileImage ??
                            "")
                    : const CachedNetworkImageProvider(ConstManager.tempImage)
                        as ImageProvider<Object>),
          ),
        ),
        Positioned(
          bottom: 1,
          right: 1,
          child: GestureDetector(
            onTap: () {
              // ImagePicker().pickImage(source: ImageSource.camera);
              _showPickerDialog(context);
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 3,
                    color: Colors.white,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      50,
                    ),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(2, 4),
                      color: Colors.black.withOpacity(
                        0.3,
                      ),
                      blurRadius: 3,
                    ),
                  ]),
              child: const Padding(
                padding: EdgeInsets.all(2.0),
                child: Icon(Icons.add_a_photo, color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
