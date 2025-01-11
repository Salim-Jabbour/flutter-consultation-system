import 'package:akemha/config/theme/color_manager.dart';
import 'package:akemha/core/utils/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(
            key: key ?? const ValueKey<String>('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 450 || true) {
        return ScaffoldWithNavigationBar(
          body: navigationShell,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
        );
      }
      // else {
      //   return ScaffoldWithNavigationRail(
      //     body: navigationShell,
      //     selectedIndex: navigationShell.currentIndex,
      //     onDestinationSelected: _goBranch,
      //   );
      // }
    });
  }
}

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: body,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          height: 54.h,
          indicatorColor: ColorManager.transparent,
          backgroundColor: ColorManager.white,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: [
            NavigationDestination(
              label: 'Home',
              tooltip: 'Home',
              icon: Icon(
                Icons.home_outlined,
                color: ColorManager.c2,
                size: 34.r,
              ),
              selectedIcon: Icon(
                Icons.home,
                color: ColorManager.c2,
                size: 34.r,
              ),
            ),
            NavigationDestination(
              label: 'Consultations',
              tooltip: 'Consultations',
              icon: Icon(
                Icons.article_outlined,
                color: ColorManager.c2,
                size: 34.r,
              ),
              selectedIcon: Icon(
                Icons.article,
                color: ColorManager.c2,
                size: 34.r,
              ),
            ),
            if (ApiService.userRole == 'USER') ...[
              NavigationDestination(
                label: 'Devices',
                tooltip: 'Devices',
                icon: Icon(
                  Icons.medical_information_outlined,
                  color: ColorManager.c2,
                  size: 34.r,
                ),
                selectedIcon: Icon(
                  Icons.medical_information,
                  color: ColorManager.c2,
                  size: 34.r,
                ),
              )
            ],
            NavigationDestination(
              label: 'Profile',
              tooltip: 'Profile',
              icon: Icon(
                Icons.account_circle_outlined,
                color: ColorManager.c2,
                size: 34.r,
              ),
              selectedIcon: Icon(
                Icons.account_circle,
                color: ColorManager.c2,
                size: 34.r,
              ),
            ),
          ],
          onDestinationSelected: onDestinationSelected,
        ),
      ),
    );
  }
}

class ScaffoldWithNavigationRail extends StatelessWidget {
  const ScaffoldWithNavigationRail({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            destinations: [
              NavigationRailDestination(
                label: const Text('Home'),
                icon: Icon(
                  Icons.home_outlined,
                  color: ColorManager.c2,
                  size: 34.r,
                ),
              ),
              NavigationRailDestination(
                label: const Text('Consultations'),
                icon: Icon(
                  Icons.article_outlined,
                  color: ColorManager.c2,
                  size: 34.r,
                ),
              ),
              NavigationRailDestination(
                label: const Text('Devices'),
                icon: Icon(
                  Icons.devices_other,
                  color: ColorManager.c2,
                  size: 34.r,
                ),
              ),
              NavigationRailDestination(
                label: const Text('Profile'),
                icon: Icon(
                  Icons.account_circle_outlined,
                  color: ColorManager.c2,
                  size: 34.r,
                ),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }
}
