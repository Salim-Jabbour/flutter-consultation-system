import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/route_manager.dart';
import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/string_manager.dart';
import 'supervised_page.dart';
import 'supervisors_page.dart';

class SupervisionPage extends StatelessWidget {
 const SupervisionPage({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorManager.c3,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(StringManager.supervised.tr()),
              ),
              Tab(
                child: Text(StringManager.supervisors.tr()),
              ),
            ],
          ),
          centerTitle: true,
          title: Text(
            StringManager.supervision.tr(),
            style: const TextStyle(
              color: ColorManager.c1,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Tooltip(
              message: StringManager.supervisionRequest.tr(),
              preferBelow: true,
              textStyle: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
              ),
              child: IconButton(
                onPressed: () {
                  context.pushNamed(
                    RouteManager.supervisorsRequest,
                  );
                },
                icon: Icon(
                  Icons.notifications_rounded,
                  color: ColorManager.c1,
                  size: 25.sp,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: ColorManager.c3,
        body: const TabBarView(
          children: [
            Center(
              child: SupervisedPage(),
            ),
            Center(
              child: SupervisorsPage(),
            ),
          ],
        ),
      ),
    );
  }
}
