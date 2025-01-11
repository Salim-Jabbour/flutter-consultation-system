import 'package:akemha/features/consultation/presentation/widgets/specialization_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/utils/dbg_print.dart';
import '../../../../core/utils/global_snackbar.dart';
import '../../models/Consultation.dart';
import '../bloc/consultation_bloc.dart';
import 'consultation_card.dart';

class ConsultationTap extends StatelessWidget {
  const ConsultationTap({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I.get<ConsultationBloc>(),
      child: BlocConsumer<ConsultationBloc, ConsultationState>(
        listener: (context, state) {
          if (state is ConsultationsFailure) {
            gShowErrorSnackBar(
              context: context,
              message: state.errMessage,
            );
          }
          if (state is ConsultationsLoaded &&
              state.consultations.consultationsMap[state.currentSpecialization]!
                  .isError) {
            gShowErrorSnackBar(
              context: context,
              message: "consultations error",
            );
          }
        },
        builder: (context, state) {
          if (state is ConsultationInitial) {
            context.read<ConsultationBloc>().add(GetSpecializations());
          }
          if (state is ConsultationsLoaded) {
            if (state.firstGet) {
              context.read<ConsultationBloc>().add(
                GetConsultationsPage(
                  id: state.currentSpecialization,
                ),
              );
            }
            if (state.consultations
                .consultationsMap[state.currentSpecialization]!.isEmpty) {
              return const Center(
                child: Text("No Consultations"),
              );
            }
            return Column(
              children: [
                SizedBox(
                  height: 125.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.consultations.specializations.length,
                    itemBuilder: (context, index) {
                      return Container(
                        color: state.currentSpecialization ==
                            state.consultations.specializations[index].id
                            ? const Color(0x22000000)
                            : null,
                        child: SpecializationCard(
                          specialization:
                          state.consultations.specializations[index],
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<ConsultationBloc>().add(GetConsultationsPage(
                        id: state.currentSpecialization,
                      ));
                      await context
                          .read<ConsultationBloc>()
                          .refreshCompleter
                          .future;
                    },
                    child: ListView.builder(
                      itemCount: state
                          .consultations
                          .consultationsMap[state.currentSpecialization]!
                          .consultations
                          .length +
                          ((state
                              .consultations
                              .consultationsMap[
                          state.currentSpecialization]!
                              .reachMax)
                              ? 0
                              : (state.isInitialLoading ? 10 : 2)),
                      itemBuilder: (context, index) {
                        dbg('reachMax ${state.consultations.consultationsMap[state.currentSpecialization]!.reachMax} $index');
                        dbg('reachMax ${state.consultations.consultationsMap[state.currentSpecialization]!.consultations.length} $index');
                        if (index <
                            state
                                .consultations
                                .consultationsMap[state.currentSpecialization]!
                                .consultations
                                .length) {
                          return ConsultationCard(
                            consultationModel: state
                                .consultations
                                .consultationsMap[state.currentSpecialization]!
                                .consultations[index],
                          );
                        } else {
                          if (!state.isLoading &&
                              !state
                                  .consultations
                                  .consultationsMap[
                              state.currentSpecialization]!
                                  .reachMax &&
                              !state.isInitialLoading) {
                            dbg("Looooodiiiiing......");
                            dbg("currentSpecialization ${state.currentSpecialization}");
                            context.read<ConsultationBloc>().add(
                              GetConsultationsPage(
                                id: state.currentSpecialization,
                              ),
                            );
                          }
                          return  Skeletonizer(
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
          } else if (state is ConsultationsInitialLoading) {
            return Column(
              children: [
                SizedBox(
                  height: 125.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return const Skeletonizer(
                        enabled: true,
                        child: SpecializationCard(
                          specialization: loadingSpecialization,
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return  Skeletonizer(
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
        },
      ),
    );
  }
}