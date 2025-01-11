import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/utils/global_snackbar.dart';
import '../../../../core/utils/services/api_service.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/first_page_bloc/first_page_bloc.dart';

class SupervisedNotficationReminderWidget extends StatefulWidget {
  const SupervisedNotficationReminderWidget(
      {super.key,
      required this.time,
      required this.name,
      required this.supervisedId,
      required this.isTaken});
  final String supervisedId;
  final String name;
  final String time;
  final bool isTaken;
  @override
  State<SupervisedNotficationReminderWidget> createState() =>
      _SupervisedNotficationReminderWidgetState();
}

class _SupervisedNotficationReminderWidgetState
    extends State<SupervisedNotficationReminderWidget> {
  bool isLoading = false;
  bool isSent = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FirstPageBlocBloc, FirstPageBlocState>(
      listener: (context, state) {
        if (state is SendNotificationToSupervisedFailure) {
          isLoading = false;
          isSent = false;
          gShowErrorSnackBar(
            context: context,
            message: state.failure.message,
          );
        }

        if (state is SendNotificationToSupervisedSuccess) {
          isLoading = false;
          gShowSuccessSnackBar(
            context: context,
            message: state.notificationReminderModel.data,
          );
        }
      },
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.time,
              style: TextStyle(
                fontSize: 18.sp,
                color: ColorManager.c1,
                // fontWeight: FontWeight.bold,
              ),
            ),
            isLoading
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      strokeAlign: 0,
                      strokeWidth: 1,
                      color: ColorManager.c1,
                    ),
                  )
                : IconButton(
                    onPressed: widget.isTaken || isSent
                        ? null
                        : () {
                            setState(() {
                              isLoading = true;
                            });

                            context
                                .read<FirstPageBlocBloc>()
                                .add(SendNotificationToSupervisedEvent(
                                  context.read<AuthBloc>().token ??
                                      ApiService.token ??
                                      "",
                                  widget.supervisedId,
                                  widget.name,
                                  widget.time,
                                ));
                            setState(() {
                              isSent = true;
                            });
                          },
                    icon: Icon(
                      widget.isTaken || isSent
                          ? Icons.check_circle_outline_rounded
                          : Icons.notifications,
                      color: ColorManager.c1,
                      size: 25.r,
                    ),
                  )
          ],
        );
      },
    );
  }
}
