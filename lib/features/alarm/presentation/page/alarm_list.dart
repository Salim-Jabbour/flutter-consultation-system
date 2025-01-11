import 'package:akemha/core/storage/alarm_preferences.dart';
import 'package:akemha/core/utils/dbg_print.dart';
import 'package:akemha/core/widgets/loading_widget.dart';
import 'package:akemha/features/alarm/models/alarm_info.dart';
import 'package:akemha/features/alarm/presentation/widget/alarm_tile.dart';
import 'package:akemha/features/alarm/scheduler/alarm_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/utils/global_snackbar.dart';
import '../../../../core/utils/services/api_service.dart';
import '../../../../core/widgets/empty_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/alarm_bloc.dart';

// var _tag = "AlarmListPage";

class AlarmListPage extends StatefulWidget {
  const AlarmListPage({super.key});

  @override
  State<AlarmListPage> createState() => _AlarmListPageState();
}

class _AlarmListPageState extends State<AlarmListPage> {
  final alarmRepo = GetIt.I.get<AlarmPreferences>();
  late List<MedicamentAlarmData> alarms = [];

  @override
  void initState() {
    loadAlarms();
    super.initState();
  }

  Future<void> loadAlarms() async {
    final temp = await alarmRepo.getDailyAlarms();
    setState(() {
      alarms = temp;
    });
  }

  int deleteIndex = -1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I.get<AlarmBloc>(),
      child: BlocConsumer<AlarmBloc, AlarmState>(
        listener: (context, state) async {
          if (state is AlarmLoading) {
            // dbgt(_tag, "AlarmLoading: hi");
            dbg("AlarmLoading: hi");
            // context.pushNamed("home");
          }
          if (state is AlarmInitial) {
            context.read().add((AlarmScreenOpened()));
          }
          if (state is AlarmDeleteFailure) {
            deleteIndex = -1;
            gShowErrorSnackBar(
              context: context,
              message: state.failure.message,
            );
          }

          if (state is AlarmDeleteSuccess) {
            setState(() {
              deleteAlarm(alarms[deleteIndex]);
              alarms.removeAt(deleteIndex);
            });
          }
        },
        builder: (context, state) {
          if (state is AlarmDeleteLoading) {
            return const LoadingWidget(fullScreen: true);
          }
          // if (state is AlarmDeleteSuccess) {
          //   deleteAlarm(alarms[deleteIndex]);
          // }
          if (state is AlarmDeleteFailure) {
            deleteIndex = -1;
          }

          return SafeArea(
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: alarms.isNotEmpty
                    ? ListView.separated(
                        itemCount: alarms.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          return AlarmTile(
                            // key: Key(alarms[index]),
                            key: Key(alarms[index].id.toString()),
                            dailyAlarm: alarms[index],
                            onDismissed: () {
                              context.read<AlarmBloc>().add(AlarmDeleteEvent(
                                  token: context.read<AuthBloc>().token ??
                                      ApiService.token ??
                                      "",
                                  alarmLocalId: alarms[index].id));
                              deleteIndex = index;
                            },
                          );
                        },
                      )
                    : EmptyWidget(height: 0.65.sh),
              ),
            ),
          );
        },
      ),
    );
  }
}
