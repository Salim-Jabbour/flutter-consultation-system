import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/color_manager.dart';
import '../bloc/medical_record_bloc.dart';

class HeightWeightWidget extends StatefulWidget {
  const HeightWeightWidget({
    super.key,
    required this.title,
    required this.isGet,
    required this.icon,
    required this.isheight,
    required this.volume,
  });
  final String title;
  final bool isGet;
  final IconData icon;
  final bool isheight;
  final double volume;

  @override
  State<HeightWeightWidget> createState() => _HeightWeightWidgetState();
}

class _HeightWeightWidgetState extends State<HeightWeightWidget> {
  late double selectedVolume;

  @override
  void initState() {
    selectedVolume = widget.volume;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  widget.icon,
                  color: ColorManager.c1,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: ColorManager.c1,
                  ),
                ),
                SizedBox(
                  width: 200.0, // Adjust width as needed
                  child: Slider(
                    value: selectedVolume,
                    min: widget.isheight ? 80.0 : 40.0,
                    max: 250.0,
                    divisions: widget.isheight ? 170 : 210,
                    label: widget.isheight
                        ? '${selectedVolume.toInt()}cm'
                        : '${selectedVolume.toInt()}Kg',
                    activeColor: ColorManager.c2,
                    onChanged: widget.isGet
                        ? null
                        : (double newValue) {
                            setState(() {
                              selectedVolume = newValue;
                              widget.isheight
                                  ? context
                                      .read<MedicalRecordBloc>()
                                      .add(MedicalRecordPatientHeight(newValue))
                                  : context.read<MedicalRecordBloc>().add(
                                      MedicalRecordPatientWeight(newValue));
                            });
                          },
                  ),
                ),
              ],
            ),
            Text(
              widget.isheight
                  ? '${selectedVolume.toInt()}cm'
                  : '${selectedVolume.toInt()}Kg',
              style: TextStyle(color: ColorManager.c1, fontSize: 12.sp),
            )
          ],
        ),
      ),
    );
  }
}
