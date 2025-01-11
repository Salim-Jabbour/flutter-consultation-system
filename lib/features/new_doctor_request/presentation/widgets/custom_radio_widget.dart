import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/string_manager.dart';
import '../../../../core/utils/dbg_print.dart';

class CustomRadioWidget extends StatefulWidget {
  final void Function(String gender) onChange;
  final Gender? gender;

  const CustomRadioWidget({
    required this.onChange,
    super.key,
    this.gender,
  });

  @override
  State<CustomRadioWidget> createState() => _CustomRadioWidgetState();
}

class _CustomRadioWidgetState extends State<CustomRadioWidget> {
  late Gender _gender;

  @override
  void initState() {
    _gender = widget.gender ?? Gender("MALE", Icons.male, false);
    dbg(_gender.name);
    dbg(_gender.isSelected);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            setState(
              () {
                _gender.isSelected = false;
                widget.onChange("MALE");
              },
            );
          },
          child: Card(
              color: !_gender.isSelected ? ColorManager.c2 : ColorManager.c3,
              child: Container(
                height: 70.w,
                width: 70.w,
                alignment: Alignment.center,
                margin: EdgeInsets.all(5.0.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.male,
                      color: !_gender.isSelected
                          ? ColorManager.c3
                          : ColorManager.c2,
                      size: 40.r,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      StringManager.male.tr(),
                      style: TextStyle(
                          color: !_gender.isSelected
                              ? ColorManager.c3
                              : ColorManager.c2),
                    )
                  ],
                ),
              )),
        ),
        InkWell(
          onTap: () {
            setState(
              () {
                _gender.isSelected = true;
                widget.onChange("FEMALE");
              },
            );
          },
          child: Card(
            color: _gender.isSelected ? ColorManager.c2 : ColorManager.c3,
            child: Container(
              height: 70.w,
              width: 70.w,
              alignment: Alignment.center,
              margin: EdgeInsets.all(5.0.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.female,
                    color:
                        _gender.isSelected ? ColorManager.c3 : ColorManager.c2,
                    size: 40.r,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    StringManager.female.tr(),
                    style: TextStyle(
                        color: _gender.isSelected
                            ? ColorManager.c3
                            : ColorManager.c2),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Gender {
  String name;
  IconData icon;
  bool isSelected;

  Gender(this.name, this.icon, this.isSelected);
}
