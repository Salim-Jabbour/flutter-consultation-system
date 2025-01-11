import 'dart:async';

import 'package:akemha/config/router/route_manager.dart';
import 'package:akemha/config/theme/color_manager.dart';
import 'package:akemha/core/resource/asset_manager.dart';
import 'package:akemha/core/utils/dbg_print.dart';
import 'package:akemha/core/utils/services/api_service.dart';
import 'package:akemha/features/alarm/presentation/enums/alarm_routine.dart';
import 'package:akemha/features/alarm/presentation/enums/alarm_routine_type.dart';
import 'package:akemha/features/alarm/scheduler/alarm_helper.dart';
import 'package:akemha/features/auth/data/datasource/local/auth_local_data_source.dart';
import 'package:alarm/alarm.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'config/router/app_route_config.dart';
import 'core/bloc/bloc_observer.dart';
import 'core/firebase/firebase_api.dart';
import 'core/resource/string_manager.dart';
import 'features/alarm/presentation/bloc/alarm_ring_bloc/alarm_ring_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

import 'core/firebase/firebase_options.dart';
import 'core/storage/alarm_preferences.dart';
import 'injection_container/main_injection.dart';

Future<void> initBeforeMain() async {
  await initInjection();
  await Alarm.init(); //add
  initPreferences(); //add
  scheduleNewAlarms(); //add

  ApiService.token = await GetIt.I.get<AuthLocalDataSource>().getUserToken();
  ApiService.userId = await GetIt.I.get<AuthLocalDataSource>().getUserId();
  ApiService.userRole = await GetIt.I.get<AuthLocalDataSource>().getUserRole();
  ApiService.userName = await GetIt.I.get<AuthLocalDataSource>().getUserName();
  dbg("Token ${ApiService.token}");
  dbg("Role ${ApiService.userRole}");
  Bloc.observer = MyBlocObserver();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initBeforeMain();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'SA')],
      path: 'asset/translations',
      fallbackLocale: const Locale('ar', 'SA'),
      startLocale: const Locale('ar', 'SA'),
      // startLocale: const Locale('en', 'US'),
      child: const Akemha(),
    ),
  );
}

Future<void> scheduleNewAlarms() async {
  //add
  // last 30 days only
  const int offsetScheduler = 30;
  var alarms = await alarmRepo.getDailyAlarms();
  var unlimitedAlarms = alarms.where((element) =>
      element.alarmRoutineType ==
      AlarmRoutineType.chronic); //get chronic alarms
  var now = DateTime.now();
  for (var alarm in unlimitedAlarms) {
    var lastId = alarm.alarmIdsInLib.last;
    var lastDateTime = Alarm.getAlarm(lastId)?.dateTime;
    if (alarm.alarmRoutine == AlarmRoutine.daily) {
      if (now.difference(lastDateTime!).inDays.abs() >= offsetScheduler) {
        //3m a7sb al wa2t bl ayam ben now w a5r lastDateTime
        continueSchedulerDailyAlarm(
            alarm, lastDateTime); //TODO: //test >= maybe it should be <=
      }
    } else if (alarm.alarmRoutine == AlarmRoutine.weekly) {
      if (now.difference(lastDateTime!).inDays.abs() >= offsetScheduler) {
        continueSchedulerWeeklyAlarm(alarm, lastDateTime);
      }
    } else if (alarm.alarmRoutine == AlarmRoutine.monthly) {
      if (now.difference(lastDateTime!).inDays.abs() >= offsetScheduler) {
        continueSchedulerMonthlyAlarm(alarm, lastDateTime);
      }
    }
  }
}

class Akemha extends StatelessWidget {
  const Akemha({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GetIt.I.get<AuthBloc>(),
          ),
          BlocProvider(
            create: (context) =>
                GetIt.I.get<AlarmRingBloc>()..add(AlarmRang(context)),
            lazy: false,
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          // home: const Splash(),
          routerConfig: MyAppRouter.router,
          // routeInformationParser: MyAppRouter().router.routeInformationParser,
          theme: ThemeData(
            useMaterial3: true,
            appBarTheme: const AppBarTheme(scrolledUnderElevation: 0),
            colorScheme: ColorScheme.fromSeed(seedColor: ColorManager.c2)
                .copyWith(background: ColorManager.c3),
            textTheme: GoogleFonts.rubikTextTheme(
              Theme.of(context).textTheme,
            ),
          ),
        ),
      ),
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 2),
      () {
        if (ApiService.token != null) {
          if (ApiService.userRole == "DOCTOR") {
            context.goNamed(RouteManager.doctorHome);
          } else if (ApiService.userRole == "USER") {
            context.goNamed(RouteManager.home);
          } else {
            context.goNamed(RouteManager.login);
          }
        } else if (ApiService.userId != null) {
          context.goNamed(RouteManager.otp);
        } else {
          context.goNamed(RouteManager.login);
        }
      },
    );
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: ColorManager.c3,
          image: DecorationImage(
            alignment: Alignment.topCenter,
            image: AssetImage(
              AssetImageManager.logo2,
            ),
          ),
        ),
        child: Scaffold(
          backgroundColor: ColorManager.transparent,
          body: Column(
            children: [
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      // context.goNamed("login");
                    },
                    child: Hero(
                      transitionOnUserGestures: true,
                      tag: "logo",
                      child: Image.asset(
                        AssetImageManager.logo,
                        width: 275.r,
                        height: 275.r,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(StringManager.appSumury.tr()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
/*


subscription ??= Alarm.ringStream.stream.listen((alarmSettings) {
  if (mounted) {
    navigateToRingScreen(alarmSettings);
  }
}, cancelOnError: true);


 */