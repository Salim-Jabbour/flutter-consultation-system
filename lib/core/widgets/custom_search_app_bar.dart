import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:akemha/config/theme/color_manager.dart';

class CustomSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool left;
  final Color color, iconColor;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;
  final String hintText;

  const CustomSearchAppBar({
    super.key,
    this.left = true,
    this.color = ColorManager.c3,
    this.iconColor = ColorManager.c1,
    this.bottom,
    this.actions,
    this.hintText = 'Search...',
  });

  @override
  _CustomSearchAppBarState createState() => _CustomSearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomSearchAppBarState extends State<CustomSearchAppBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: context.canPop() && widget.left
          ? IconButton(
        onPressed: () {
          context.pop();
        },
        icon: const Icon(Icons.arrow_back_ios_new),
      )
          : const SizedBox.shrink(),
      backgroundColor: widget.color,
      iconTheme: IconThemeData(
        color: widget.iconColor,
      ),
      title: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none,
          hintStyle: TextStyle(color: widget.iconColor),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              setState(() {});
            },
          )
              : null,
        ),
        style: TextStyle(color: widget.iconColor),
        onChanged: (query) {
          // Implement search functionality here
        },
      ),
      centerTitle: true,
      actions: widget.actions,
      bottom: widget.bottom,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
