import 'package:akemha/config/theme/color_manager.dart';
import 'package:akemha/core/storage/alarm_preferences.dart';
import 'package:akemha/core/utils/dbg_print.dart';
import 'package:akemha/features/alarm/models/alarm_info.dart';
import 'package:akemha/features/alarm/presentation/enums/alarm_routine.dart';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/global_snackbar.dart';
import '../../../../core/utils/services/api_service.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/alarm_bloc.dart';
import '../enums/alarm_routine_type.dart';
import '../enums/days.dart';

// var _tag = "AlarmRingPage";

class AlarmRingPage extends StatefulWidget {
  final AlarmSettings alarmSettings;

  const AlarmRingPage({required this.alarmSettings, super.key});

  @override
  State<AlarmRingPage> createState() => _AlarmAlarmRingPageState();
}

class _AlarmAlarmRingPageState extends State<AlarmRingPage> {
  late MedicamentAlarmData medicamentAlarmData;

  var alarmRepo = GetIt.I.get<AlarmPreferences>();

  // TODO
  // List<MedicamentAlarmData> alarms = [];
  @override
  void initState() {
    dbgt("AlarmRingPage", "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
    medicamentAlarmData = MedicamentAlarmData(
      id: 0,
      alarmRoutine: AlarmRoutine.daily,
      alarmRoutineType: AlarmRoutineType.acute,
      alarmTimes: [DateTime.now()],
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      medicamentName: "",
      medicamentType: "",
      alarmWeekDay: AlarmWeekDay.friday,
      selectedDayInMonth: 1,
    );
    loadMedicamentAlarmData();

    super.initState();
  }

  Future<void> loadMedicamentAlarmData() async {
    var alarm = await alarmRepo
        .getMedicamentAlarmDataByAlarmLibId(widget.alarmSettings.id);
    setState(() {
      medicamentAlarmData = alarm!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I.get<AlarmBloc>(),
      child: BlocConsumer<AlarmBloc, AlarmState>(
        listener: (context, state) async {
          if (state is AlarmLoading) {
            dbgt("AlarmRingPage", "AlarmLoading: hi");
            // context.pushNamed("home");
          }
          if (state is AlarmInitial) {
            dbgt("AlarmRingPage", "AlarmINITIAL: hiiiiiiiiiiiiiiiiiiiiiiiii");
          }

          if (state is AlarmTakenFailure) {
            gShowErrorSnackBar(
                context: context,
                message: //TODO: StringManager
                    "next time make sure u have internet connection");
            context.pop();
          }
          if (state is AlarmTakenSuccess) {
            dbg("JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ");
            context.pop();
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        ColorManager.c1,
                        ColorManager.c3,
                      ],
                      begin: FractionalOffset(1.0, 1.0),
                      end: FractionalOffset(0.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: Scaffold(
                  backgroundColor: ColorManager.transparent,
                  body: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(height: 150.h),
                        Text(
                          TimeOfDay.fromDateTime(widget.alarmSettings.dateTime)
                              .format(context),
                          style: const TextStyle(
                            color: ColorManager.c1,
                            fontWeight: FontWeight.normal,
                            fontSize: 80,
                          ),
                        ),
                        Text(medicamentAlarmData.medicamentName),
                        Text(medicamentAlarmData.medicamentType),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              width: MediaQuery.of(context).size.width / 2,
                              child: ElevatedButton(
                                onPressed: () async {
                                  DateTime ringingTime =
                                      widget.alarmSettings.dateTime;
                                  DateFormat formatter = DateFormat('hh:mm:00');

                                  MedicamentAlarmData? salimo = await alarmRepo
                                      .getMedicamentAlarmDataByAlarmLibId(
                                          widget.alarmSettings.id);

                                  Alarm.stop(widget.alarmSettings.id);

                                  dbg("DID NOT RETURN BEFORE");
                                  if (!context.mounted) return;
                                  dbg("DID NOT RETURN");

                                  context.read<AlarmBloc>().add(
                                        AlarmStopEvent(
                                          context.read<AuthBloc>().token ??
                                              ApiService.token ??
                                              "",
                                          salimo!.id,
                                          formatter.format(ringingTime),
                                        ),
                                      );
                                },
                                child: const Text(
                                  // TODO: String Manager
                                  'تناول الدواء',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
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
