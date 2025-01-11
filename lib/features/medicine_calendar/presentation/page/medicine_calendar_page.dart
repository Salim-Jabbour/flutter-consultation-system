import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/route_manager.dart';
import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/string_manager.dart';
import '../../../../core/utils/services/api_service.dart';
import '../../../alarm/presentation/page/alarm_list.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import 'todays_medicine_page.dart';

class MedicineCalendarPage extends StatelessWidget {
  const MedicineCalendarPage({super.key});

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
                child: Text(StringManager.todaysMedicines.tr()),
              ),
              Tab(
                child: Text(StringManager.allMedicines.tr()),
              ),
              // Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),
          centerTitle: true,
          title: Text(
            StringManager.medicineCalendar.tr(),
            style: const TextStyle(
              color: ColorManager.c1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: ColorManager.c3,
        body: TabBarView(
          children: [
            // today medicine page
            TodaysMedicinesPage(
              supervisedId:
                  context.read<AuthBloc>().userId ?? ApiService.userId ?? "0",
            ),
            // all medicine page
            const AlarmListPage()
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.pushNamed(RouteManager.alarm);
          },
          backgroundColor: ColorManager.c3,
          child: Icon(
            Icons.add,
            size: 40.r,
            color: ColorManager.c2,
          ),
        ),
      ),
    );
  }
}
