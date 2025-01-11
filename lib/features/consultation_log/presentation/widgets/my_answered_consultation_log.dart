import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/utils/dbg_print.dart';
import '../../../../core/utils/global_snackbar.dart';
import '../../../consultation/models/Consultation.dart';
import '../../../consultation/presentation/widgets/consultation_card.dart';
import '../bloc/consultation_log_bloc.dart';

class MyAnsweredConsultationLog extends StatelessWidget {
  const MyAnsweredConsultationLog({super.key});

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
      if (state is ConsultationsLogLoaded &&
          state.myAnsweredConsultations.isError) {
        gShowErrorSnackBar(
          context: context,
          message: "consultations error",
        );
      }
    }, builder: (context, state) {
      //TODo: uncomment
      if (state is ConsultationLogInitial) {
        context
            .read<ConsultationLogBloc>()
            .add(GetMyAnsweredConsultationsLogPage());
      }
      if (state is ConsultationsLogLoaded) {
        if (!state.myAnsweredConsultations.isLoading &&
            !state.myAnsweredConsultations.reachMax &&
            !state.myAnsweredConsultations.isInitialLoading &&
            state.myAnsweredConsultations.currentPage == 0) {
          context
              .read<ConsultationLogBloc>()
              .add(GetMyAnsweredConsultationsLogPage());
        }
        if (state.myAnsweredConsultations.isEmpty) {
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
                      .add(GetMyAnsweredConsultationsLogPage());
                  await context
                      .read<ConsultationLogBloc>()
                      .refreshCompleter
                      .future;
                },
                child: ListView.builder(
                  itemCount:
                      state.myAnsweredConsultations.consultations.length +
                          ((state.myAnsweredConsultations.reachMax)
                              ? 0
                              : (state.myAnsweredConsultations.isInitialLoading
                                  ? 10
                                  : 2)),
                  itemBuilder: (context, index) {
                    dbg('reachMax ${state.myAnsweredConsultations.reachMax} $index');
                    dbg('reachMax My ${state.myAnsweredConsultations.consultations.length} $index');
                    if (index <
                        state.myAnsweredConsultations.consultations.length) {
                      return ConsultationCard(
                        isMyLog: true,
                        canRate: true,
                        consultationModel:
                            state.myAnsweredConsultations.consultations[index],
                      );
                    } else {
                      if (!state.myAnsweredConsultations.isLoading &&
                          !state.myAnsweredConsultations.reachMax &&
                          !state.myAnsweredConsultations.isInitialLoading) {
                        dbg("Looooodiiiiing......");
                        context.read<ConsultationLogBloc>().add(
                              GetMyAnsweredConsultationsLogPage(
                                  page: state
                                      .myAnsweredConsultations.currentPage),
                            );
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
                      isMyLog: true,
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
