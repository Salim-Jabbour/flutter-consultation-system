import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/string_manager.dart';

class RemovingSupervisorIconButton extends StatelessWidget {
  const RemovingSupervisorIconButton({
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
      icon: Icon(
        Icons.delete_rounded,
        color: ColorManager.red,
        size: 25.sp,
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
                onTapFunction();
                Navigator.of(context).pop();
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
