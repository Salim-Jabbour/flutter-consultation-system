import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/string_manager.dart';
import '../../../medicine_calendar/models/medicine_model.dart';
import 'supervised_notification_reminder_widget.dart';

class SupervisedMedicineTileWidget extends StatelessWidget {
  const SupervisedMedicineTileWidget({super.key, required this.dailyAlarm, required this.supervisedId});
  final MedicineModelData dailyAlarm;
  final String supervisedId;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 4), // Shadow position
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dailyAlarm.name,
              style: TextStyle(
                  color: ColorManager.c2,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("${StringManager.startDate.tr()}: ${dailyAlarm.startDate}"),
            const SizedBox(height: 10),
            Text("${StringManager.endDate.tr()}: ${dailyAlarm.endDate}"),
            const SizedBox(height: 20),
            Wrap(
              children: dailyAlarm.alarmTimes
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: SupervisedNotficationReminderWidget(
                          supervisedId: supervisedId,
                          name: dailyAlarm.name,
                          time: e.time.substring(0, 5),
                          isTaken: e.taken,
                        ),
                      ))
                  .toList(),
            )

            // Expanded(
            //   child: ListView.builder(
            //       itemCount: dailyAlarm.alarmTimes.length,
            //       itemBuilder: (context, index) {
            //         return Padding(
            //           padding: const EdgeInsets.symmetric(vertical: 5.0),
            //           child: SupervisedNotficationReminderWidget(
            //             time: dailyAlarm.alarmTimes[index].time.substring(0, 5),
            //           ),
            //         );
            //       }),
            // ),
          ],
        ),
      ),
    );
  }
}
