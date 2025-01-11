import 'package:akemha/core/utils/dbg_print.dart';
import 'dart:io';

import 'package:akemha/config/theme/color_manager.dart';
import 'package:akemha/core/resource/string_manager.dart';
import 'package:akemha/core/utils/global_snackbar.dart';
import 'package:akemha/core/widgets/custom_app_bar.dart';
import 'package:akemha/core/widgets/custom_button.dart';
import 'package:akemha/core/widgets/custom_text_field.dart';
import 'package:akemha/features/consultation/models/specialization.dart';
import 'package:akemha/features/consultation/presentation/bloc/consultation_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/widgets/loading_widget.dart';

class RequestConsultationPage extends StatelessWidget {
  RequestConsultationPage({super.key, required this.specializations});

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final ImagesModel images = ImagesModel();
  final List<Specialization> specializations;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I.get<ConsultationBloc>(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: StringManager.requestAConsultation.tr(),
          left: true,
        ),
        backgroundColor: ColorManager.c3,
        body: SingleChildScrollView(
          child: BlocConsumer<ConsultationBloc, ConsultationState>(
            listener: (context, state) {
              if (state is ConsultationsFailure) {
                gShowErrorSnackBar(context: context, message: state.errMessage);
              }
              if (state is ConsultationRequested) {
                gShowSuccessSnackBar(context: context, message: "successful");
                context.pop();
              }
            },
            builder: (context, state) {
              if (state is ConsultationsInitialLoading) {
                return const LoadingWidget(fullScreen: true);
              }

              return Column(
                children: [
                  RequestConsultationImages(
                    imagesModel: images,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16.0),
                    child: CustomDropdownButton(
                      controller: _specializationController,
                      // FixMe: Pass Consultation Types
                      values: specializations.sublist(1),
                      title: StringManager.specialization,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16.0),
                    child: CustomTextField(
                      textEditingController: _titleController,
                      textFieldColor: ColorManager.c3,
                      hintText: StringManager.title.tr(),
                    ),
                  ),
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16.0),
                  //   child: CustomDropdownButton(
                  //     values: ["public", "privet", "anonymous"],
                  //     title: StringManager.specialization,
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16.0),
                    child: CustomSegmentedButton(
                      controller: _typeController,
                      values: const ["public", "private", "anonymous"],
                      title: StringManager.type,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16.0),
                    child: CustomTextField(
                      textEditingController: _descriptionController,
                      height: 300.h,
                      textFieldColor: ColorManager.c3,
                      hintText: StringManager.writeAComment.tr(),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomButton(
                    height: 50,
                    width: 200,
                    onPressed: () {
                      dbg(_typeController.text);
                      dbg(_specializationController.text);
                      dbg(_titleController.text);
                      dbg(images.images);
                      dbg('requested');
                      context.read<ConsultationBloc>().add(
                            RequestConsultation(
                              images: images.images,
                              specializationId: _specializationController.text,
                              title: _titleController.text,
                              description: _descriptionController.text,
                              consultationType: _typeController.text,
                            ),
                          );
                    },
                    text: StringManager.sendConsultation.tr(),
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

class ImagesModel {
  List<String> images = [];
}

class RequestConsultationImages extends StatefulWidget {
  const RequestConsultationImages({
    super.key,
    required this.imagesModel,
  });

  final ImagesModel imagesModel;

  @override
  State<RequestConsultationImages> createState() =>
      _RequestConsultationImagesState();
}

class _RequestConsultationImagesState extends State<RequestConsultationImages> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.imagesModel.images.length + 1,
        itemBuilder: (context, index) {
          if (index == widget.imagesModel.images.length) {
            return GestureDetector(
              child: Icon(
                color: ColorManager.c1,
                Icons.add_box_outlined,
                size: 100.r,
              ),
              onTap: () async {
                // TODO: implement this method
                // log((await getImages()).length.toString());
                List<String> newImages = await getImages();
                setState(() {
                  widget.imagesModel.images.addAll(newImages);
                });
              },
            );
          } else {
            return Container(
              padding: EdgeInsets.all(8.r),
              width: 150.w,
              child: Image.file(
                File(widget.imagesModel.images[index]),
              ),
            );
          }
        },
      ),
    );
  }
}

//TODO: extract this class
class CustomDropdownButton extends StatefulWidget {
  const CustomDropdownButton(
      {super.key,
      required this.values,
      required this.title,
      required this.controller});

  final String title;
  final TextEditingController controller;

  final List<Specialization> values;

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  Specialization? classType;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("${widget.title.tr()}: "),
        const Spacer(),
        Container(
          width: 200.w,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: ColorManager.c3,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 4), // Shadow position
              ),
            ],
          ),
          child: DropdownButton<Specialization>(
            dropdownColor: ColorManager.c3,
            value: classType,
            onChanged: (Specialization? newValue) => setState(() {
              classType = newValue;
              widget.controller.text = "${classType?.id}";
            }),
            items: widget.values
                .map<DropdownMenuItem<Specialization>>(
                    (Specialization value) => DropdownMenuItem<Specialization>(
                          value: value,
                          child: Text(value.name),
                        ))
                .toList(),
            isExpanded: true,
            // add extra sugar..
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 25.sp,
            underline: const SizedBox(),
          ),
        ),
      ],
    );
  }
}

//TODO: extract this class
class CustomSegmentedButton extends StatefulWidget {
  const CustomSegmentedButton(
      {super.key,
      required this.values,
      required this.title,
      this.width = 300,
      required this.controller});

  final String title;
  final int width;
  final TextEditingController controller;

  final List<String> values;

  @override
  State<CustomSegmentedButton> createState() => _CustomSegmentedButtonState();
}

class _CustomSegmentedButtonState extends State<CustomSegmentedButton> {
  Set<String> classType = {"public"};

  @override
  Widget build(BuildContext context) {
    widget.controller.text = classType.first;
    return Row(
      children: [
        Text("${widget.title.tr()} : "),
        const Spacer(),
        SizedBox(
          width: 300.w,
          child: SegmentedButton(
            style: SegmentedButton.styleFrom(
                selectedBackgroundColor: ColorManager.c2),
            segments: widget.values
                .map<ButtonSegment<String>>(
                    (String value) => ButtonSegment<String>(
                          value: value,
                          label: Text(
                            value.tr(),
                          ),
                        ))
                .toList(),
            selected: classType,
            onSelectionChanged: (p0) {
              setState(() {
                classType = p0;
                widget.controller.text = p0.first;
              });
            },
            showSelectedIcon: false,
          ),
        ),
      ],
    );
  }
}

Future<List<String>> getImages() async {
  final picker = ImagePicker();
  List<String> selectedImages = [];
  List<XFile> xFilePick = await picker
      //     .pickImage(source: ImageSource.gallery);
      // log("Image${pickedFile?.path}");
      .pickMultiImage(
          imageQuality: 100, // To set quality of images
          maxHeight:
              1000, // To set maxHeight of images that you want in your app
          maxWidth:
              1000); // To set maxHeight of images that you want in your app

  //
  // // if atLeast 1 images is selected it will add
  // // all images in selectedImages
  // // variable so that we can easily show them in UI
  // if (xFilePick.isNotEmpty) {
  xFilePick.map((e) => selectedImages.add(e.path));
  for (var i = 0; i < xFilePick.length; i++) {
    selectedImages.add(xFilePick[i].path);
  }
  // } else {
  //   // If no image is selected it will show a
  //   // snackBar saying nothing is selected
  //   // ScaffoldMessenger.of(context).showSnackBar(
  //   //     const SnackBar(content: Text('Nothing is selected')));
  // }
  return selectedImages;
}
