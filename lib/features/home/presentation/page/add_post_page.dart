import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/router/route_manager.dart';
import '../../../../core/resource/string_manager.dart';
import '../../../../core/utils/global_snackbar.dart';
import '../../../../core/utils/services/api_service.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/add_post_bloc/add_post_bloc.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _descriptionController = TextEditingController();

  File? _image;

  Future<void> _pickImage() async {
    // ignore: no_leading_underscores_for_local_identifiers
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => GetIt.I.get<AddPostBloc>(),
          child: BlocConsumer<AddPostBloc, AddPostState>(
            listener: (context, state) {
              if (state is AddPostSuccess) {
                gShowSuccessSnackBar(
                  context: context,
                  message: state.message,
                );
                // navigate to home
                // context.pushReplacementNamed(RouteManager.home);
                context.pushReplacementNamed(RouteManager.doctorHome);
              }

              if (state is AddPostFailure) {
                gShowErrorSnackBar(
                  context: context,
                  message: state.failure.message,
                );
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),
                        GestureDetector(
                            onTap: () {
                              _pickImage();
                            },
                            child: Container(
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: _image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        _image!,
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                  : Icon(
                                      Icons.add_a_photo,
                                      color: Colors.grey[800],
                                      size: 100,
                                    ),
                            ),),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 10,
                          decoration: const InputDecoration(
                            hintText: 'Enter description',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: StringManager.addPost.tr(),
                          onPressed: () {
                            if (_descriptionController.text.isNotEmpty ||
                                _image != null) {
                              context.read<AddPostBloc>().add(AddGetPostEvent(
                                    context.read<AuthBloc>().token ??
                                        ApiService.token ??
                                        "",
                                    _image!.path,
                                    _descriptionController.text,
                                  ));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  if (state is AddPostLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: SizedBox(
                          height: 1.sh,
                          child: const LoadingWidget(fullScreen: false)),
                    )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
