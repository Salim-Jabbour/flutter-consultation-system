import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LRListTile extends StatelessWidget {
  const LRListTile({
    super.key,
    this.left,
    this.right,
  });

  final Widget? left;
  final Widget? right;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45.h,
      child: ListTile(
        leading: left,
        trailing: right,
      ),
    );
  }
}

