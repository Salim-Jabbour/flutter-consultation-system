import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/string_manager.dart';

class NewDoctorRequestInfoWidget extends StatelessWidget {
  const NewDoctorRequestInfoWidget({
    super.key,
    required this.onTapFunction,
    required this.headline,
    required this.headlineDetails,
  });

  final Function() onTapFunction;
  final String headline;
  final String headlineDetails;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showAlertDialog(context);
      },
      icon: const Icon(
        Icons.info_outline_rounded,
        color: ColorManager.c1,
        // size: 25.sp,
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(headline),
          content: Text(headlineDetails),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onTapFunction();
              },
              child: Text(StringManager.yes.tr()),
            ),
            ElevatedButton(
              child: Text(StringManager.no.tr()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
