import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/string_manager.dart';
import '../bloc/new_doctor_request_bloc.dart';

class UploadCvWidget extends StatefulWidget {
  const UploadCvWidget({super.key, required this.bloc});
  final NewDoctorRequestBloc bloc;

  @override
  State<UploadCvWidget> createState() => _UploadCvWidgetState();
}

class _UploadCvWidgetState extends State<UploadCvWidget> {
  File? _file;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        _file = await widget.bloc.pickPdfFile();
        setState(() {});
      },
      child: BlocBuilder<NewDoctorRequestBloc, NewDoctorRequestState>(
          builder: (context, state) {
        return Container(
          height: 250.h,
          width: 200.w,
          decoration: BoxDecoration(
            color: Colors.white54,
            borderRadius: BorderRadius.circular(8),
          ),
          child: _file != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      PdfViewer.file(_file!.path),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          ),
                          child: Text(
                            widget.bloc.fileName!.length > 20
                                ? "${widget.bloc.fileName!.substring(0, 17)}..."
                                : widget.bloc.fileName!,
                            style: TextStyle(
                              color: ColorManager.c3,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Icon(
                        Icons.file_copy_rounded,
                        color: Colors.grey[800],
                        size: 80.r,
                      ),
                      const Spacer(),
                      Text(
                        StringManager.addCvFile.tr(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: ColorManager.c1,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
