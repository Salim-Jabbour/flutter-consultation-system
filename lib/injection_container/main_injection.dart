import 'package:akemha/injection_container/activity_injection.dart';
import 'package:akemha/injection_container/chat_injection.dart';
import 'package:akemha/injection_container/consultation_injection.dart';
import 'package:akemha/injection_container/home_injection.dart';
import 'package:akemha/injection_container/medical_record_injection.dart';
import 'package:akemha/injection_container/medicine_calendar_injection.dart';
import 'package:akemha/injection_container/personal_info_injection.dart';
import 'package:akemha/injection_container/supervision_injection.dart';
import 'package:get_it/get_it.dart';
import 'alarm_injection.dart';
import 'auth_injection.dart';
import 'consultation_log_injection.dart';
import 'device_injection.dart';
import 'dio_init_client.dart';
import 'doctor_injection.dart';
import 'doctor_profile_injection.dart';
import 'global_injection.dart';
import 'new_doctor_request_injection.dart';
import 'profile_injection.dart';
import 'review_beneficiary_profile_injection.dart';

GetIt locator = GetIt.instance;

Future<void> initInjection() async {
  await dioInjection();
  await globalInjection();
  await authInjection();
  await homeInjection();
  await profileInjection();
  await doctorInjection();
  await deviceInjection();
  await consultationInjection();
  await consultationLogInjection();
  await activityInjection();
  await medicalRecordInjection();
  await medicineCalendarInjection();
  await personalInfoInjection();
  await supervisionInjection();
  await alarmInjection();
  await chatInjection();
  await reviewBeneficiaryProfileInjection();
  await doctorProfileInjection();
  await newDoctorRequestInjection();
}
