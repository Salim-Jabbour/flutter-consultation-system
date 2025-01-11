import 'package:akemha/config/theme/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool left;
  final Color color, iconColor;

  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.left = true,
    this.color = ColorManager.c3,
    this.iconColor = ColorManager.c1,
    this.bottom,
  });

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      leading: context.canPop()&&left
          ? IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            )
          : const Icon(
              Icons.ac_unit,
              color: ColorManager.transparent,
            ),
      backgroundColor: color,
      iconTheme: IconThemeData(
        color: iconColor,
      ),
      title: Text(
        title ?? '',
        style: const TextStyle(
          color: ColorManager.c1,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: actions,bottom: bottom,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
