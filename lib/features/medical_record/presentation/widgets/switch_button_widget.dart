import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/color_manager.dart';

class SwitchButtonWidget extends StatefulWidget {
  const SwitchButtonWidget({
    required this.title,
    required this.value,
    required this.isGet,
    required this.icon,
    this.getValueFunc,
    super.key,
  });
  final String title;
  final bool value;
  final bool isGet;
  final IconData icon;
  final void Function(bool value)? getValueFunc;
  @override
  State<SwitchButtonWidget> createState() => _SwitchButtonWidgetState();
}

class _SwitchButtonWidgetState extends State<SwitchButtonWidget> {
  late bool valueB;
  @override
  void initState() {
    valueB = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: ColorManager.c3,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 4), // Shadow position
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
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
                Text(widget.title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: ColorManager.c1,
                    )),
              ],
            ),
            Transform.scale(
              scale: 0.7,
              child: Switch(
                value: valueB,
                activeTrackColor: ColorManager.c2,
                onChanged: widget.isGet
                    ? null
                    : (bool value) {
                        widget.getValueFunc!(value);
                        setState(() {
                          valueB = value;
                          // widget.getValueFunc ? null : ;
                        });
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
