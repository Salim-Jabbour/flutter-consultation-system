import 'package:akemha/features/alarm/models/alarm_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/resource/string_manager.dart';

class AlarmTile extends StatelessWidget {
  const AlarmTile({
    required this.dailyAlarm,
    super.key,
    this.onDismissed,
  });

  final MedicamentAlarmData dailyAlarm;
  final void Function()? onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: onDismissed != null
          ? DismissDirection.endToStart
          : DismissDirection.none,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Icon(
                Icons.delete,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) {
        onDismissed?.call();
        // context
        //     .read<AlarmBloc>()
        //     .add(AlarmDeleteEvent(alarmLocalId: dailyAlarm.id));
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          title: Text(
            dailyAlarm.medicamentName,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "${StringManager.startDate.tr()}: ${DateFormat('yyyy-MM-dd').format(dailyAlarm.startDate)}"),
              Text(
                  "${StringManager.endDate.tr()}: ${dailyAlarm.endDate != null ? DateFormat('yyyy-MM-dd').format(dailyAlarm.endDate!) : "OPEN"}"),
              const SizedBox(height: 5),
              Wrap(
                spacing: 5,
                children: dailyAlarm.alarmTimes
                    .map((time) => Chip(
                          label: Text(DateFormat('HH:mm').format(time)),
                          backgroundColor:
                              Theme.of(context).chipTheme.backgroundColor,
                        ))
                    .toList(),
              ),
            ],
          ),
          trailing: const Icon(
            Icons.medication_liquid,
            size: 32,
          ),
        ),
      ),
    );
  }
}
