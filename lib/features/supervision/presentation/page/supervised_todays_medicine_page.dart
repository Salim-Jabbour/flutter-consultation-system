import 'package:akemha/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/utils/services/api_service.dart';
import '../../../../core/widgets/empty_widget.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../medicine_calendar/models/medicine_model.dart';
import '../bloc/first_page_bloc/first_page_bloc.dart';
import '../widget/supervised_medicine_tile_widget.dart';

class SupervisedTodaysMedicinePage extends StatefulWidget {
  const SupervisedTodaysMedicinePage(
      {super.key, required this.supervisedId, required this.supervisedName});
  final String supervisedId;
  final String supervisedName;

  @override
  State<SupervisedTodaysMedicinePage> createState() =>
      _SupervisedTodaysMedicinePageState();
}

class _SupervisedTodaysMedicinePageState
    extends State<SupervisedTodaysMedicinePage> {
  List<MedicineModelData>? medicines;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        left: true,
        title: widget.supervisedName,
      ),
      body: BlocProvider(
        create: (context) => GetIt.I.get<FirstPageBlocBloc>(),
        child: SingleChildScrollView(
          child: BlocConsumer<FirstPageBlocBloc, FirstPageBlocState>(
            listener: (context, state) {
              if (state is TodaysMedicineSupervisedSuccess) {
                medicines = state.medicineModel.data;
              }
              // two states for success and failure
            },
            builder: (context, state) {
              if (state is FirstPageBlocInitial) {
                context.read<FirstPageBlocBloc>().add(TodaysMedicineEvent(
                    context.read<AuthBloc>().token ?? ApiService.token ?? "",
                    widget.supervisedId));
              }
              if (state is TodaysMedicineSupervisedFailure) {
                return FailureWidget(
                  errorMessage: state.failure.message,
                  onPressed: () {
                    context.read<FirstPageBlocBloc>().add(TodaysMedicineEvent(
                        context.read<AuthBloc>().token ??
                            ApiService.token ??
                            "",
                        widget.supervisedId));
                  },
                );
              }

              return Stack(
                children: [
                  SizedBox(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 0.85.sh,
                            child: ListView.separated(
                              itemCount: medicines?.length ?? 0,
                              separatorBuilder: (context, index) =>
                                  const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Divider(height: 1),
                              ),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SupervisedMedicineTileWidget(
                                    dailyAlarm: medicines![index],
                                    supervisedId: widget.supervisedId,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (state is FirstPageLoading)
                    const LoadingWidget(fullScreen: true),
                  if (state is TodaysMedicineSupervisedSuccess &&
                      medicines!.isEmpty)
                    EmptyWidget(height: 0.7.sh)
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
