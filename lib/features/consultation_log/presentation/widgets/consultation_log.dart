import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/utils/dbg_print.dart';
import '../../../../core/utils/global_snackbar.dart';
import '../../../consultation/models/Consultation.dart';
import '../../../consultation/presentation/widgets/consultation_card.dart';
import '../bloc/consultation_log_bloc.dart';

class ConsultationLog extends StatelessWidget {
  const ConsultationLog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConsultationLogBloc, ConsultationLogState>(
        listener: (context, state) {
      if (state is ConsultationsLogFailure) {
        gShowErrorSnackBar(
          context: context,
          message: state.errMessage,
        );
      }
      if (state is ConsultationsLogLoaded && state.consultationsLog.isError) {
        gShowErrorSnackBar(
          context: context,
          message: "consultations error",
        );
      }
    }, builder: (context, state) {
      //TODo: uncomment
      if (state is ConsultationLogInitial) {
        context.read<ConsultationLogBloc>().add(GetConsultationsLogPage());
      }
      if (state is ConsultationsLogLoaded) {
        if (!state.consultationsLog.isLoading &&
            !state.consultationsLog.reachMax &&
            !state.consultationsLog.isInitialLoading &&
            state.consultationsLog.currentPage == 0) {
          context.read<ConsultationLogBloc>().add(GetConsultationsLogPage());
        }
        if (state.consultationsLog.isEmpty) {
          return const Center(
            child: Text("No Consultaions"),
          );
        }
        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<ConsultationLogBloc>()
                      .add(GetConsultationsLogPage());
                  await context
                      .read<ConsultationLogBloc>()
                      .refreshCompleter
                      .future;
                },
                child: ListView.builder(
                  itemCount: state.consultationsLog.consultations.length +
                      ((state.consultationsLog.reachMax)
                          ? 0
                          : (state.consultationsLog.isInitialLoading ? 10 : 2)),
                  itemBuilder: (context, index) {
                    dbg('reachMax ${state.consultationsLog.reachMax} $index');
                    dbg('reachMax Log ${state.consultationsLog.consultations.length} $index');
                    if (index < state.consultationsLog.consultations.length) {
                      return ConsultationCard(
                        isMyLog: true,
                        consultationModel:
                            state.consultationsLog.consultations[index],
                      );
                    } else {
                      if (!state.consultationsLog.isLoading &&
                          !state.consultationsLog.reachMax &&
                          !state.consultationsLog.isInitialLoading &&
                          index ==
                              state.consultationsLog.consultations.length) {
                        dbg("Looooodiiiiing......");
                        context
                            .read<ConsultationLogBloc>()
                            .add(GetConsultationsLogPage(page: state.consultationsLog.currentPage));
                      }
                      return Skeletonizer(
                        enabled: true,
                        child: ConsultationCard(
                          consultationModel: loadingConsultation,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        );
      } else if (state is ConsultationsLogLoading) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Skeletonizer(
                    enabled: true,
                    child: ConsultationCard(
                      consultationModel: loadingConsultation,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      } else {
        return const Center(
          child: Text('Error here'),
        );
      }
    });
  }
}
