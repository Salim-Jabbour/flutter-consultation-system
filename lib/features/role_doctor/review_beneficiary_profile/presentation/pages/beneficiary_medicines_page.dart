import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/resource/string_manager.dart';
import '../../../../../core/utils/services/api_service.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/empty_widget.dart';
import '../../../../../core/widgets/failure_widget.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../medicine_calendar/models/medicine_model.dart';
import '../../../../medicine_calendar/presentation/widgets/alarm_tile_widget.dart';
import '../manager/medicines_bloc/medicines_bloc_bloc.dart';

class BeneficiaryMedicinesPage extends StatelessWidget {
   const BeneficiaryMedicinesPage({super.key, required this.beneficiaryId});

  final String beneficiaryId;

  @override
  Widget build(BuildContext context) {
    // FIXME it may hit an error
    List<MedicineModelData>? medicines;
    return Scaffold(
      appBar: CustomAppBar(
        left: true,
        title: StringManager.allMedicines.tr(),
      ),
      body: BlocProvider(
        create: (context) => GetIt.I.get<MedicinesBlocBloc>(),
        child: BlocConsumer<MedicinesBlocBloc, MedicinesBlocState>(
          listener: (context, state) {
            if (state is MedicinesSuccess) {
              medicines = state.model.data;
            }
          },
          builder: (context, state) {
            if (state is MedicinesBlocInitial) {
              context.read<MedicinesBlocBloc>().add(
                    GetMedicinesEvent(
                      context.read<AuthBloc>().token ?? ApiService.token ?? "",
                      beneficiaryId,
                    ),
                  );
            }

            if (state is MedicinesFailure) {
              return FailureWidget(
                errorMessage: state.failure.message,
                onPressed: () {
                  context.read<MedicinesBlocBloc>().add(
                        GetMedicinesEvent(
                          context.read<AuthBloc>().token ??
                              ApiService.token ??
                              "",
                          beneficiaryId,
                        ),
                      );
                },
              );
            }

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
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
                ),
                if (state is MedicinesBlocLoading)
                  const LoadingWidget(fullScreen: true),
                if (state is MedicinesSuccess && medicines!.isEmpty)
                  EmptyWidget(height: 1.sh)
              ],
            );
          },
        ),
      ),
    );
  }
}
