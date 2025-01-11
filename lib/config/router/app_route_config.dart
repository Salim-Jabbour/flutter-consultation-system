import 'package:akemha/config/router/route_manager.dart';
import 'package:akemha/core/utils/dbg_print.dart';
import 'package:akemha/features/activity/presentation/page/activities_page.dart';
import 'package:akemha/features/alarm/presentation/page/alarm_dev_page.dart';
import 'package:akemha/features/alarm/presentation/page/alarm_list.dart';
import 'package:akemha/features/alarm/presentation/page/alarm_page.dart';
import 'package:akemha/features/alarm/presentation/page/alarm_ring.dart';
import 'package:akemha/features/auth/presentation/page/login_page.dart';
import 'package:akemha/features/auth/presentation/page/otp_page.dart';
import 'package:akemha/features/auth/presentation/page/register_page.dart';
import 'package:akemha/features/chat/model/message_consultation_model.dart';
import 'package:akemha/features/chat/presentation/pages/init_chat.dart';

import 'package:akemha/features/consultation/presentation/page/doctor_consultations_page.dart';

import 'package:akemha/features/consultation/presentation/page/request_consultation_page.dart';
import 'package:akemha/features/consultation/models/specialization.dart'
    as specialization;
import 'package:akemha/features/consultation/presentation/page/consultation_page.dart';
import 'package:akemha/features/consultation/presentation/page/consultations_page.dart';
import 'package:akemha/features/consultation_log/presentation/page/consultations_log_page.dart';
import 'package:akemha/features/device/presentation/page/devices_page.dart';
import 'package:akemha/features/doctor/presentation/pages/doctor_details_page.dart';
import 'package:akemha/features/doctor/presentation/pages/doctor_page.dart';
import 'package:akemha/features/home/models/post_model.dart';
import 'package:akemha/features/home/presentation/page/home_page.dart';
import 'package:akemha/features/home/presentation/page/post_page.dart';
import 'package:akemha/features/medical_record/presentation/page/medical_record_page.dart';
import 'package:akemha/features/medicine_calendar/presentation/page/medicine_calendar_page.dart';
import 'package:akemha/features/personal_info/presentation/page/personal_info_page.dart';
import 'package:akemha/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:akemha/features/profile/presentation/pages/profile_page.dart';
import 'package:akemha/features/supervision/presentation/page/supervision_page.dart';
import 'package:akemha/main.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/resource/string_manager.dart';
import '../../core/widgets/failure_widget.dart';
import '../../features/consultation/models/Consultation.dart';
import '../../features/consultation/presentation/page/consultation_search.dart';
import '../../features/doctor/model/doctor_model.dart';
import '../../features/home/presentation/page/add_post_page.dart';
import '../../features/home/presentation/page/test_page.dart';
import '../../features/home/presentation/widgets/scaffold_with_nested_navigation.dart';
import '../../features/medical_record/model/medical_record_model.dart';
import '../../features/medical_record/presentation/page/add_medical_record_page.dart';
import '../../features/role_doctor/doctor_profile/models/doctor_profile_model.dart';
import '../../features/role_doctor/doctor_profile/presentation/manager/doctor_profile/doctor_profile_bloc.dart';
import '../../features/role_doctor/doctor_profile/presentation/pages/doctor_consultation_page.dart';
import '../../features/role_doctor/doctor_profile/presentation/pages/doctor_personal_info_page.dart';
import '../../features/role_doctor/doctor_profile/presentation/pages/doctor_post_page.dart';
import '../../features/role_doctor/doctor_profile/presentation/pages/doctor_profile_page.dart';
import '../../features/role_doctor/review_beneficiary_profile/presentation/pages/beneficiary_profile_page.dart';
import '../../features/supervision/presentation/page/supervisors_request_page.dart';
import '../theme/color_manager.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'Home');
final _shellNavigatorConsultationKey =
    GlobalKey<NavigatorState>(debugLabel: 'Consultation');
final _shellNavigatorDevicesKey =
    GlobalKey<NavigatorState>(debugLabel: 'Devices');
final _shellNavigatorProfileKey =
    GlobalKey<NavigatorState>(debugLabel: 'Profile');

class MyAppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: "/splash",
    // initialLocation: "/alarm",
    debugLogDiagnostics: true,
    navigatorKey: rootNavigatorKey,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              // DOCTOR
              GoRoute(
                path: '/doctorHome',
                name: RouteManager.doctorHome,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomePage(),
                ),
                routes: [
                  GoRoute(
                    path: 'addPost',
                    name: RouteManager.addPost,
                    pageBuilder: (context, state) {
                      return const MaterialPage(child: AddPostPage());
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorConsultationKey,
            routes: [
              GoRoute(
                path: '/doctorConsultations',
                name: RouteManager.doctorConsultations,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: DoctorConsultationsPage(),
                ),
                routes: const [],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: [
              GoRoute(
                path: '/doctorProfile',
                name: RouteManager.doctorProfile,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: DoctorProfilePage(),
                ),
                routes: const [],
              ),
            ],
          ),
        ],
      ),
      // personal info
      GoRoute(
        name: RouteManager.doctorPersonalInfo,
        path: "/${RouteManager.doctorPersonalInfo}",
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;

          final model = extra['model'] as DoctorProfileDetailsModel?;
          final bloc = extra['bloc'] as DoctorProfileBloc;

          return MaterialPage(
            child: DoctorPersonalInfo(
              model: model,
              bloc: bloc,
            ),
          );
        },
      ),
      // doctor posts
      GoRoute(
        name: RouteManager.doctorPosts,
        path: "/${RouteManager.doctorPosts}",
        builder: (context, state) => DoctorPostPage(
          doctorId: state.extra as String,
        ),
      ),
      // doctor posts
      GoRoute(
        name: RouteManager.doctorConsultationsLog,
        path: "/${RouteManager.doctorConsultationsLog}",
        builder: (context, state) => const DoctorConsultationPage(),
      ),
      // activities
      GoRoute(
        name: RouteManager.doctorActivites,
        path: "/${RouteManager.doctorActivites}",
        builder: (context, state) => ActivitiesPage(),
      ),

      // BENEFICIARY
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _shellNavigatorHomeKey,
            routes: [
              GoRoute(
                path: '/home',
                name: RouteManager.home,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomePage(),
                ),
                routes: const [],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorConsultationKey,
            routes: [
              GoRoute(
                path: '/consultations',
                name: RouteManager.consultations,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ConsultationsPage(),
                ),
                routes: [
                  GoRoute(
                    path: RouteManager.requestConsultation,
                    name: RouteManager.requestConsultation,
                    builder: (context, state) => RequestConsultationPage(
                      specializations: (state.extra
                              as List<specialization.Specialization>?) ??
                          [],
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorDevicesKey,
            routes: [
              GoRoute(
                path: '/devices',
                name: RouteManager.devices,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: DevicesPage(),
                ),
                routes: [
                  GoRoute(
                    path: RouteManager.device,
                    name: RouteManager.device,
                    builder: (context, state) => const TestPage(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellNavigatorProfileKey,
            routes: [
              GoRoute(
                path: '/profile',
                name: RouteManager.profile,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProfilePage(),
                ),
                routes: const [
                  // GoRoute(
                  //   name: RouteManager.personalInfo,
                  //   path: RouteManager.personalInfo,
                  //   builder: (context, state) => PersonalInfoPage(
                  //     profileBloc: state.extra as ProfileBloc,
                  //   ),
                  // ),
                  // // GoRoute(
                  // //   name: RouteManager.medicalRecord,
                  // //   path: RouteManager.medicalRecord,
                  // //   builder: (context, state) => const MedicalRecordPage(),
                  // // ),
                  // GoRoute(
                  //   name: RouteManager.medicineCalendar,
                  //   path: RouteManager.medicineCalendar,
                  //   builder: (context, state) => const MedicineCalendarPage(),
                  // ),
                  // // GoRoute(
                  // //   name: RouteManager.addMedicine,
                  // //   path: RouteManager.addMedicine,
                  // //   builder: (context, state) => const AddMedicineTime(),
                  // // ),
                  // GoRoute(
                  //   name: RouteManager.consultationLogs,
                  //   path: RouteManager.consultationLogs,
                  //   builder: (context, state) => const ConsultationsLogPage(),
                  // ),
                  // GoRoute(
                  //   name: RouteManager.supervision,
                  //   path: RouteManager.supervision,
                  //   builder: (context, state) => const SupervisionPage(),
                  // ),
                  // GoRoute(
                  //   name: RouteManager.supervisorsRequest,
                  //   path: RouteManager.supervisorsRequest,
                  //   builder: (context, state) => const SupervisorsRequestPage(),
                  // ),
                  // GoRoute(
                  //   name: RouteManager.activities,
                  //   path: RouteManager.activities,
                  //   builder: (context, state) => ActivitiesPage(),
                  // ),
                  // GoRoute(
                  //   name: RouteManager.myPosts,
                  //   path: RouteManager.myPosts,
                  //   builder: (context, state) => ActivitiesPage(),
                  // ),
                ],
              ),
            ],
          )
        ],
      ),
/* profile related*/

      GoRoute(
        name: RouteManager.personalInfo,
        path: "/${RouteManager.personalInfo}",
        builder: (context, state) => PersonalInfoPage(
          profileBloc: state.extra as ProfileBloc,
        ),
      ),

      GoRoute(
        name: RouteManager.medicineCalendar,
        path: "/${RouteManager.medicineCalendar}",
        builder: (context, state) => const MedicineCalendarPage(),
      ),

      GoRoute(
        name: RouteManager.medicalRecord,
        path: "/${RouteManager.medicalRecord}",
        builder: (context, state) => const MedicalRecordPage(),
      ),
      GoRoute(
        name: RouteManager.addMedicalRecord,
        path: "/${RouteManager.addMedicalRecord}",
        builder: (context, state) => AddMedicalRecordPage(
          model: state.extra as MedicalRecordModelData,
        ),
      ),
      GoRoute(
        name: RouteManager.consultationLogs,
        path: "/${RouteManager.consultationLogs}",
        builder: (context, state) => const ConsultationsLogPage(),
      ),
      GoRoute(
        name: RouteManager.supervision,
        path: "/${RouteManager.supervision}",
        builder: (context, state) => const SupervisionPage(),
      ),
      GoRoute(
        name: RouteManager.supervisorsRequest,
        path: "/${RouteManager.supervisorsRequest}",
        builder: (context, state) => const SupervisorsRequestPage(),
      ),
      GoRoute(
        name: RouteManager.activities,
        path: "/${RouteManager.activities}",
        builder: (context, state) => ActivitiesPage(),
      ),
      GoRoute(
        name: RouteManager.myPosts,
        path: "/${RouteManager.myPosts}",
        builder: (context, state) => ActivitiesPage(),
      ),

/* profile related */
      GoRoute(
        path: '/post',
        name: RouteManager.post,
        pageBuilder: (context, state) {
          return MaterialPage(
              child: PostPage(
            post: state.extra as PostModel,
          ));
        },
      ),

      GoRoute(
          path: "/${RouteManager.consultation}",
          name: RouteManager.consultation,
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            dbg("${extra['isMyLog']}");
            return ConsultationPage(
              consultationModel: extra['consultation'] as Consultation,
              isMyLog: (extra['isMyLog']) as bool,
              canAnswered: (extra['canAnswered']) as bool,
              canRate: (extra['canRate']) as bool,
            );
          }),

      GoRoute(
        name: RouteManager.doctors,
        path: "/${RouteManager.doctors}",
        builder: (context, state) => const DoctorPage(),
      ),
      GoRoute(
        name: RouteManager.doctor,
        path: "/${RouteManager.doctor}",
        builder: (context, state) => DoctorDetailsPage(
          doctorDataModel: state.extra as DoctorDataModel,
        ),
      ),
      GoRoute(
        name: RouteManager.reviewBeneficiaryProfile,
        path: "/${RouteManager.reviewBeneficiaryProfile}",
        builder: (context, state) => BeneficiaryProfilePage(
          userId: state.extra as String,
        ),
      ),
      GoRoute(
        name: RouteManager.consultationSearch,
        path: "/${RouteManager.consultationSearch}",
        builder: (context, state) => const ConsultationSearchPage(),
      ),

      // GoRoute(
      //   name: RouteManager.doctorPersonalInfo,
      //   path: "/${RouteManager.doctorPersonalInfo}",
      //   builder: (context, state) => DoctorPersonalInfo(
      //     model: state.extra as DoctorProfileDetailsModel?,
      //   ),
      // ),
      GoRoute(
        path: '/splash',
        name: RouteManager.splash,
        pageBuilder: (context, state) {
          return const MaterialPage(child: Splash());
        },
      ),
      GoRoute(
        path: '/login',
        name: RouteManager.login,
        pageBuilder: (context, state) {
          return MaterialPage(child: LoginPage());
        },
      ),
      GoRoute(
        path: '/register',
        name: RouteManager.register,
        pageBuilder: (context, state) {
          return MaterialPage(child: RegisterPage());
        },
      ),
      GoRoute(
        path: '/otp',
        name: RouteManager.otp,
        pageBuilder: (context, state) {
          return const MaterialPage(child: OtpPage());
        },
      ),
      GoRoute(
        path: '/chat/:consultationId/:consultationTitle',
        name: "chat",
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final consultationId =
              int.parse(state.pathParameters['consultationId']!);
          final doctorModel = extra['doctorModel'] as UserLessResponse;
          final beneficiaryModel =
              extra['beneficiaryModel'] as UserLessResponse;

          final consultationTitle = state.pathParameters['consultationTitle']!;

          dbg("I'm In GoRoute");
          dbg(consultationId);
          dbg(doctorModel);
          dbg(beneficiaryModel);

          return MaterialPage(
            child: InitChat(
              doctorModel: doctorModel,
              beneficiaryModel: beneficiaryModel,
              consultationId: consultationId,
              consultationTitle: consultationTitle,
            ),
          );
        },
      ),
      GoRoute(
        path: '/alarm',
        name: RouteManager.alarm,
        pageBuilder: (context, state) {
          return const MaterialPage(child: AlarmPage());
        },
      ),
      GoRoute(
        path: '/${RouteManager.alarmList}',
        name: RouteManager.alarmList,
        pageBuilder: (context, state) {
          return const MaterialPage(child: AlarmListPage());
        },
      ),
      GoRoute(
        path: '/${RouteManager.alarmRing}',
        name: RouteManager.alarmRing,
        pageBuilder: (context, state) {
          AlarmSettings alarm =
              state.extra as AlarmSettings; // 👈 casting is important
          return MaterialPage(
              child: AlarmRingPage(
            alarmSettings: alarm,
          ));
        },
      ),
      GoRoute(
        path: '/${RouteManager.alarmDev}',
        name: RouteManager.alarmDev,
        pageBuilder: (context, state) {
          return const MaterialPage(child: AlarmDevPage());
        },
      )
    ],
    errorPageBuilder: (context, state) {
      return MaterialPage(
        child: Scaffold(
          backgroundColor: ColorManager.c3,
          //  Center(
          //   child: Text(
          //     "Error",
          //   ),
          // ),
          body: Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: FailureWidget(
              errorMessage: StringManager.sthWrong.tr(),
              onPressed: () {
                // context.goNamed(RouteManager.home);
              },
            ),
          ),
        ),
      );
    },
  );
}
