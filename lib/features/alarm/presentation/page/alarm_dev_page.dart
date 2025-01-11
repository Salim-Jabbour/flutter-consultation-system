import 'package:akemha/core/utils/dbg_print.dart';
import 'package:akemha/features/alarm/presentation/widget/dev/tile.dart';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../bloc/alarm_bloc.dart';

var _tag = "AlarmDevPage";

class AlarmDevPage extends StatefulWidget {
  const AlarmDevPage({super.key});

  @override
  State<AlarmDevPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmDevPage> {
  late List<AlarmSettings> alarms;

  @override
  void initState() {
    super.initState();

    loadAlarms();
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I.get<AlarmBloc>()..add(AlarmScreenOpened()),
      child: BlocConsumer<AlarmBloc, AlarmState>(
        listener: (context, state) {
          if (state is AlarmLoading) {
            dbgt(_tag, "AlarmLoading: hi");
            // context.pushNamed("home");
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: SafeArea(
                child: alarms.isNotEmpty
                    ? ListView.separated(
                        itemCount: alarms.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          return ExampleAlarmTile(
                            key: Key(alarms[index].id.toString()),
                            title: DateFormat('yyyy-MM-dd HH:mm')
                                .format(alarms[index].dateTime),
                            info: "${alarms[index].notificationBody}",
                            onPressed: () => () {},
                            onDismissed: () {
                              Alarm.stop(alarms[index].id)
                                  .then((_) => loadAlarms());
                            },
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'No alarms set',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
