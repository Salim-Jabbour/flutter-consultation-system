import 'package:akemha/core/resource/string_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../config/theme/color_manager.dart';
import '../widgets/consultation_tap.dart';
import '../widgets/doctor_consultation_tap.dart';

class DoctorConsultationsPage extends StatelessWidget {
  const DoctorConsultationsPage({super.key});

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
                child: Text(StringManager.notAnswered.tr()),
              ),
              Tab(
                child: Text(StringManager.answered.tr()),
              ),
              // Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),
          centerTitle: true,
          title: Text(
            StringManager.consultationLogs.tr(),
            style: const TextStyle(
              color: ColorManager.c1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: ColorManager.c3,
        body: const TabBarView(
          children: [
            DoctorConsultationTap(),
            ConsultationTap(),
          ],
        ),
      ),
    );
  }
}




