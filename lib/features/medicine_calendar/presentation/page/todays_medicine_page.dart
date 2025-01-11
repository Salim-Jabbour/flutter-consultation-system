import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/utils/services/api_service.dart';
import '../../../../core/widgets/empty_widget.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../models/medicine_model.dart';
import '../bloc/medicine_calendar_bloc.dart';
import '../widgets/alarm_tile_widget.dart';

class TodaysMedicinesPage extends StatefulWidget {
  const TodaysMedicinesPage({super.key, required this.supervisedId});
  final String supervisedId;

  @override
  State<TodaysMedicinesPage> createState() => _TodaysMedicinesPage();
}

class _TodaysMedicinesPage extends State<TodaysMedicinesPage> {
  List<MedicineModelData>? medicines;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I.get<MedicineCalendarBloc>(),
      child: SingleChildScrollView(
        child: BlocConsumer<MedicineCalendarBloc, MedicineCalendarState>(
          listener: (context, state) {
            if (state is MedicineTodayCalendarSuccess) {
              medicines = state.model.data;
            }
          },
          builder: (context, state) {
            if (state is MedicineCalendarInitial) {
              context.read<MedicineCalendarBloc>().add(
                    GetTodaysMedicinesEvent(
                      context.read<AuthBloc>().token ?? ApiService.token ?? "",
                      widget.supervisedId,
                    ),
                  );
            }

            if (state is MedicineTodayCalendarFailure) {
              return FailureWidget(
                errorMessage: state.failure.message,
                onPressed: () {
                  context.read<MedicineCalendarBloc>().add(
                        GetTodaysMedicinesEvent(
                          context.read<AuthBloc>().token ??
                              ApiService.token ??
                              "",
                          widget.supervisedId,
                        ),
                      );
                },
              );
            }
            return Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 1.sh,
                        child: ListView.separated(
                          itemCount: medicines?.length ?? 0,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                          itemBuilder: (context, index) {
                            return AlarmTileWidget(
                              // key: Key(alarms[index]),
                              key: Key(medicines![index].id.toString()),
                              dailyAlarm: medicines![index],
                              onDismissed: null,
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
                if (state is MedicineTodayCalendarLoading)
                  const LoadingWidget(fullScreen: true),
                if (state is MedicineTodayCalendarSuccess && medicines!.isEmpty)
                  EmptyWidget(height: 0.65.sh)
              ],
            );
          },
        ),
      ),
    );
  }
}
