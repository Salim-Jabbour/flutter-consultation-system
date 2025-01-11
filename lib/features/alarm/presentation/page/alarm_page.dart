import 'dart:async';

import 'package:akemha/config/router/route_manager.dart';
import 'package:akemha/config/theme/color_manager.dart';
import 'package:akemha/core/resource/asset_manager.dart';
import 'package:akemha/core/utils/dbg_print.dart';
import 'package:akemha/core/widgets/custom_text_field.dart';
import 'package:akemha/features/alarm/presentation/enums/alarm_routine.dart';
import 'package:akemha/features/alarm/presentation/enums/alarm_routine_type.dart';
import 'package:akemha/features/alarm/presentation/enums/days.dart';
import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/services/api_service.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/alarm_bloc.dart';

// var _tag = "AlarmPage";

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  //TODO:
  //mn hon
  // late List<AlarmSettings> alarms;
  // static StreamSubscription<AlarmSettings>? subscription;

  // @override
  // void initState() {
  //   super.initState();
  //   if (Alarm.android) {
  //     checkAndroidNotificationPermission();
  //     checkAndroidScheduleExactAlarmPermission();
  //   }
  //   loadAlarms();
  //   subscription ??= Alarm.ringStream.stream.listen(navigateToRingScreen);
  // }

  // Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute<void>(
  //       builder: (context) => AlarmRingPage(alarmSettings: alarmSettings),
  //     ),
  //   );
  //   loadAlarms();
  // }

  // void loadAlarms() {
  //   setState(() {
  //     alarms = Alarm.getAlarms();
  //     alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
  //   });
  // }
  //TODO: lhon, 7t hl 7ki bl home

  final List<AlarmRoutine> _routine = AlarmRoutine.values;
  final List<bool> _selectedRoutine = <bool>[true, false, false];

  final List<String> _dailyFrequently =
      List.generate(6, (index) => (index + 1).toString());
  List<bool> _selectedDailyFrequently = List.generate(6, (index) => index == 0);

  List<DateTime> _dailyTime = <DateTime>[
    DateTime.now().add(const Duration(minutes: 1))
  ];
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now().add(const Duration(days: 1));

  final List<AlarmRoutineType> _routineType = AlarmRoutineType.values;
  final List<bool> _selectedRoutineType = <bool>[true, false];

  // week
  final List<bool> _selectedWeekDay =
      List.generate(AlarmWeekDay.values.length, (index) => index == -1);
  //

  // month
  final List<int> _dayInMonthly = List.generate(29, (index) => (index + 1));
  List<bool> _selectedDayInMonthly = List.generate(29, (index) => index == 0);
  //

  AlarmRoutine getSelectedRoutine() {
    int selectedIndex = _selectedRoutine.indexWhere((element) => element);
    return _routine[selectedIndex];
  }

  AlarmRoutineType getSelectedRoutineType() {
    int selectedIndex = _selectedRoutineType.indexWhere((element) => element);
    return _routineType[selectedIndex];
  }

  AlarmWeekDay? getSelectedAlarmWeekDay() {
    int selectedIndex = _selectedWeekDay.indexWhere((element) => element);
    if (selectedIndex == -1) return null;
    return AlarmWeekDay.values[selectedIndex];
  }

  int getSelectedDayInMonth() {
    int selectedIndex = _selectedDayInMonthly.indexWhere((element) => element);
    return _dayInMonthly[selectedIndex];
  }

  // String getSelectedDuration() {
  //   int selectedIndex = _selectedDuration.indexWhere((element) => element);
  //   return _duration[selectedIndex];
  // }

  final Key formKey = GlobalKey();

  //TODO: this is the Start of seperate UI

  // Create a TextEditingController
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _medicineDescrebtionController =
      TextEditingController();

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    // subscription?.cancel();
    _medicineNameController.dispose();
    _medicineDescrebtionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      // floatingActionButton: _buildFloatingActionButtons(context),
      body: BlocProvider(
        create: (context) => GetIt.I.get<AlarmBloc>()..add(AlarmScreenOpened()),
        child: BlocConsumer<AlarmBloc, AlarmState>(
          listener: _blocListener,
          builder: (context, state) {
            if (state is AlarmLoading) {
              return const LoadingWidget();
            }
            return SafeArea(
              child: Scaffold(
                body: SingleChildScrollView(child: _buildBody(context)),
              ),
            );
          },
        ),
      ),
    ));
  }

  void _blocListener(BuildContext context, AlarmState state) {
    if (state is AlarmLoading) {
      dbgt("AlarmPage", "AlarmLoading: hi");
    }
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorManager.c3,
        image: DecorationImage(
          alignment: Alignment.topCenter,
          image: AssetImage(AssetImageManager.logo2),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100.h),
            // TODO: must not be empty the data inside
            _buildMedicationField(),
            SizedBox(height: 20.h),
            _buildDescriptionField(),
            SizedBox(height: 20.h),
            _buildRoutineToggleButtons(),
            SizedBox(height: 10.h),
            _buildDailyFrequencyToggle(),
            SizedBox(height: 10.h),
            _buildWeeklyToggle(),
            SizedBox(height: 10.h),
            _buildMonthlyToggle(),
            Center(
              child: SizedBox(
                width: 350.w,
                // color: Colors.amber,
                child: Column(
                  children: [
                    Column(children: _buildTimeViewList()),
                    SizedBox(height: 10.h),
                    _buildStartDatePicker(context),
                    SizedBox(height: 10.h),
                    _buildEndDatePicker(context),
                  ],
                ),
              ),
            ),
            // SizedBox(height: 10.h),
            // _buildStartDatePicker(context),
            // SizedBox(height: 10.h),
            // _buildEndDatePicker(context),
            SizedBox(height: 10.h),
            _buildRoutineTypeToggleButtons(),
            SizedBox(height: 40.h),
            _buildSaveButton(context),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationField() {
    return SizedBox(
      width: 360.w,
      height: 70.h,
      child: Center(
        child: CustomTextField(
          hintText: "اسم الدواء",
          icon: Icons.medication_rounded,
          textEditingController: _medicineNameController,
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return SizedBox(
      width: 360.w,
      height: 70.h,
      child: Center(
        child: CustomTextField(
          hintText: "الوصف",
          icon: Icons.description,
          textEditingController: _medicineDescrebtionController,
        ),
      ),
    );
  }

  Widget _buildRoutineToggleButtons() {
    return getToggleButtons(
      _routine.map((e) => e.name).toList(),
      _selectedRoutine,
      (int index) {
        setState(() {
          for (int i = 0; i < _selectedRoutine.length; i++) {
            _selectedRoutine[i] = i == index;
          }
          _resetDailyTime();
          _resetDailyFrequency();
        });
      },
    );
  }

  void _resetDailyTime() {
    _dailyTime = <DateTime>[DateTime.now().add(const Duration(minutes: 1))];
  }

  void _resetDailyFrequency() {
    _selectedDailyFrequently = List.generate(6, (index) => index == 0);
  }

  Widget _buildDailyFrequencyToggle() {
    return Visibility(
      visible: getSelectedRoutine() == AlarmRoutine.daily,
      child: getToggleButtons(
        _dailyFrequently,
        _selectedDailyFrequently,
        (int index) {
          setState(() {
            for (int i = 0; i < _selectedDailyFrequently.length; i++) {
              _selectedDailyFrequently[i] = i == index;
            }
            _updateDailyTime(index);
          });
        },
      ),
    );
  }

  void _updateDailyTime(int index) {
    _dailyTime = List.generate(
      index + 1,
      (item) => DateTime.now().add(Duration(minutes: 1 + item)),
    );
  }

  Widget _buildWeeklyToggle() {
    return Visibility(
      visible: getSelectedRoutine() == AlarmRoutine.weekly,
      child: getGridToggle(
        isSmall: false,
        AlarmWeekDay.values.map((e) => e.name).toList(),
        _selectedWeekDay,
        (int index) {
          setState(() {
            for (int i = 0; i < _selectedWeekDay.length; i++) {
              _selectedWeekDay[i] = i == index;
            }
          });
        },
      ),
    );
  }

  Widget _buildMonthlyToggle() {
    return Visibility(
      visible: getSelectedRoutine() == AlarmRoutine.monthly,
      child: getGridToggle(
        isSmall: true,
        _dayInMonthly.map((e) => e.toString()).toList(),
        _selectedDayInMonthly,
        (int index) {
          setState(() {
            for (int i = 0; i < _selectedDayInMonthly.length; i++) {
              _selectedDayInMonthly[i] = i == index;
            }
          });
        },
      ),
    );
  }

  List<Widget> _buildTimeViewList() {
    return _dailyTime.map((time) {
      var index = _dailyTime.indexOf(time);
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "وقت الدواء",
          ),
          RawMaterialButton(
            onPressed: () {
              pickTime(index);
            },
            fillColor: Colors.grey[200],
            child: Container(
              width: 100.w,
              margin: const EdgeInsets.all(0),
              child: Center(
                child: Text(
                  TimeOfDay.fromDateTime(time).format(context),
                ),
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildStartDatePicker(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("تاريخ البدء"),
        RawMaterialButton(
          onPressed: pickDateStartDate,
          fillColor: Colors.grey[200],
          child: Container(
            width: 100.w,
            margin: const EdgeInsets.all(0),
            child: Center(
                child:
                    Text(DateFormat('yyyy-MM-dd').format(_selectedStartDate))),
          ),
        ),
      ],
    );
  }

  Widget _buildEndDatePicker(BuildContext context) {
    return Visibility(
      visible: getSelectedRoutineType() == AlarmRoutineType.acute,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("تاريخ الإنتهاء"),
          RawMaterialButton(
            onPressed: pickDateEndDate,
            fillColor: Colors.grey[200],
            child: Container(
              margin: const EdgeInsets.all(5),
              child: Text(DateFormat('yyyy-MM-dd').format(_selectedEndDate)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineTypeToggleButtons() {
    return getToggleButtons(
      _routineType.map((e) => e.name).toList(),
      _selectedRoutineType,
      (int index) {
        setState(() {
          for (int i = 0; i < _selectedRoutineType.length; i++) {
            _selectedRoutineType[i] = i == index;
          }
        });
      },
    );
  }

// to change time and add minute
  // DateTime changeStartDate(List<DateTime> dateTimeList) {
  //   DateTime startDate = _selectedStartDate;
  //   final now = DateTime.now();
  //   for (int i = 0; i < dateTimeList.length; i++) {
  //     dbgt("AMMMMMM", dateTimeList[i].difference(now));
  //     if (now.isBefore(dateTimeList[i])) {
  //       dbgt("SALIM AMMMMMM: ", i);
  //     } else {
  //       dbgt("SAMIIIIIIIIIIIIIIIII AMMMMMM: ", i);
  //     }
  //   }
  //   return startDate;
  // }

  Widget _buildSaveButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomButton(
          text: "Save",
          width: 178.w,
          height: 50.h,
          fontSize: 15.sp,
          onPressed: () {
            print("*************************************");
            print(_medicineNameController.text);

            context.read<AlarmBloc>().add(
                  AlarmScheduleSetEvent(
                    token: context.read<AuthBloc>().token ??
                        ApiService.token ??
                        "",
                    selectedRoutine: getSelectedRoutine(),
                    times: _dailyTime,
                    startDate: _selectedStartDate,
                    endDate: getSelectedRoutineType() == AlarmRoutineType.acute
                        ? _selectedEndDate
                        : null,
                    routineType: getSelectedRoutineType(),
                    alarmWeekDay: getSelectedAlarmWeekDay(),
                    selectedDayInMonth: getSelectedDayInMonth(),
                    medicineName: _medicineNameController.text,
                    medicineDescription: _medicineDescrebtionController.text,
                  ),
                );
          },
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _buildFloatingActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // FloatingActionButton(
          //   onPressed: () {
          //     context.pushNamed(RouteManager.alarmDev);
          //   },
          //   heroTag: "alarmDev",
          //   child: const Icon(Icons.bug_report, size: 33),
          // ),
          FloatingActionButton(
            onPressed: () {
              context.pushNamed(RouteManager.alarmList);
            },
            heroTag: "alarmList",
            child: const Icon(Icons.list, size: 33),
          ),
        ],
      ),
    );
  }

  //TODO: this is the End of seperate UI

  Future<void> pickTime(int index) async {
    final res = await showTimePicker(
      initialTime: TimeOfDay.fromDateTime(_dailyTime[index]),
      context: context,
    );

    if (res != null) {
      setState(() {
        final now = DateTime.now().add(const Duration(minutes: 1));
        _dailyTime[index] = now.copyWith(
          hour: res.hour,
          minute: res.minute,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
        if (_dailyTime[index].isBefore(now)) {
          _dailyTime[index] = _dailyTime[index].add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> pickDateStartDate() async {
    final res = await showDatePicker(
      initialDate: _selectedStartDate,
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 366)),
    );

    if (res != null) {
      setState(() {
        final now = DateTime.now();
        _selectedStartDate = now.copyWith(
          year: res.year,
          month: res.month,
          day: res.day,
          hour: 0,
          minute: 0,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
        if (_selectedStartDate.isAfter(_selectedEndDate)) {
          _selectedEndDate = now.copyWith(
            year: res.year,
            month: res.month,
            day: res.day,
            hour: 0,
            minute: 0,
            second: 0,
            millisecond: 0,
            microsecond: 0,
          );
        }
      });
    }
  }

  Future<void> pickDateEndDate() async {
    final res = await showDatePicker(
      initialDate: _selectedEndDate,
      context: context,
      firstDate: _selectedStartDate,
      lastDate: _selectedStartDate.add(const Duration(days: 366)),
    );

    if (res != null) {
      setState(() {
        final now = DateTime.now();
        _selectedEndDate = now.copyWith(
          year: res.year,
          month: res.month,
          day: res.day,
          hour: 0,
          minute: 0,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
      });
    }
  }
}

ToggleButtons getToggleButtons(
  List<String> options,
  List<bool> selectedState,
  void Function(int) onPressedCallback,
) {
  return ToggleButtons(
    direction: Axis.horizontal,
    onPressed: (int index) {
      onPressedCallback(index);
    },
    borderRadius: const BorderRadius.all(Radius.circular(8)),
    selectedBorderColor: ColorManager.c2,
    selectedColor: Colors.white,
    fillColor: ColorManager.c2,
    color: ColorManager.c2,
    // constraints: const BoxConstraints(
    //   minHeight: 40.0,
    //   minWidth: 80.0,
    // ),
    isSelected: selectedState,
    children: options.map((e) => Text(e)).toList(),
  );
}

Widget getToggleButtons2(
  List<String> options,
  List<bool> selectedState,
  void Function(int) onPressedCallback,
) {
  return Ink(
    width: 200,
    // height: 60,
    color: Colors.white,
    child: GridView.count(
      primary: true,
      crossAxisCount: 4,
      //set the number of buttons in a row
      crossAxisSpacing: 8,
      //set the spacing between the buttons
      childAspectRatio: 1,
      //set the width-to-height ratio of the button,
      //>1 is a horizontal rectangle
      children: List.generate(selectedState.length, (index) {
        //using Inkwell widget to create a button
        return InkWell(
            splashColor: Colors.yellow, //the default splashColor is grey
            onTap: () {
              onPressedCallback(index);
            },
            child: Ink(
              decoration: BoxDecoration(
                //set the background color of the button when it is selected/ not selected
                color: selectedState[index] ? Color(0xffD6EAF8) : Colors.white,
                // here is where we set the rounded corner
                borderRadius: BorderRadius.circular(8),
                //don't forget to set the border,
                //otherwise there will be no rounded corner
                border: Border.all(color: Colors.red),
              ),
              child: Text(options[index]),
            ));
      }),
    ),
  );
}

Widget getGridToggle(List<String> options, List<bool> selectedState,
    void Function(int) onPressedCallback,
    {required bool isSmall}) {
  const itemHeight = 50.0;
  int crossAxisCount;
  if (isSmall == true) {
    crossAxisCount = 7;
  } else {
    crossAxisCount = 4;
  }
  return SizedBox(
    child: AutoHeightGridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        itemCount: options.length,
        builder: (BuildContext context, int index) {
          return SizedBox(
            height: itemHeight,
            child: Card(
              color: selectedState[index]
                  ? ColorManager.c2
                  : ColorManager.textFieldFill,
              child: InkWell(
                onTap: () {
                  onPressedCallback(index);
                },
                child: Center(
                  child: Text(options[index]),
                ),
              ),
            ),
          );
        }),
  );
}
