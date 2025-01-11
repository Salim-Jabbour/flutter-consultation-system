import 'package:akemha/core/resource/string_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../config/theme/color_manager.dart';
import 'package:akemha/features/consultation_log/presentation/bloc/consultation_log_bloc.dart';

import '../widgets/consultation_log.dart';
import '../widgets/my_answered_consultation_log.dart';

class ConsultationsLogPage extends StatelessWidget {
  const ConsultationsLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I.get<ConsultationLogBloc>(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorManager.c3,
            bottom: TabBar(
              tabs: [
                Tab(
                  // icon: Icon(Icons.directions_car),
                  child: Text(StringManager.answered.tr()),
                ),
                Tab(
                  // icon: Icon(Icons.directions_transit),
                  child: Text(StringManager.notAnswered.tr()),
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
              MyAnsweredConsultationLog(),
              ConsultationLog(),
            ],
          ),
        ),
      ),
    );
  }
}
