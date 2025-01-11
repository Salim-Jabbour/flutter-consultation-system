import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:io';

import '../../../../../config/theme/color_manager.dart';
import '../manager/doctor_profile/doctor_profile_bloc.dart';

class ProfileImageWidget extends StatefulWidget {
  const ProfileImageWidget({super.key, required this.profileImage});
  final String profileImage;
  @override
  State<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _image = File(image.path);
        context
            .read<DoctorProfileBloc>()
            .add(DoctorProfileChangeProfileImage(_image));
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              _image != null
                  ? CircleAvatar(
                      backgroundColor: Colors.white70,
                      radius: 60,
                      backgroundImage: FileImage(_image!),
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.white70,
                      radius: 60,
                      backgroundImage:
                          CachedNetworkImageProvider(widget.profileImage),
                    ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () async {
                    _showPickerDialog(context);
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.add_a_photo_rounded,
                      color: ColorManager.c1,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
