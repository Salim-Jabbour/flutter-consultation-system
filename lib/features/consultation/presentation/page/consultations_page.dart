import 'package:akemha/config/router/route_manager.dart';
import 'package:akemha/core/resource/string_manager.dart';
import 'package:akemha/core/widgets/custom_app_bar.dart';
import 'package:akemha/features/consultation/presentation/widgets/consultation_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../config/theme/color_manager.dart';
import '../../../../core/utils/dbg_print.dart';
import '../../../../core/utils/global_snackbar.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../models/Consultation.dart';
import '../../models/specialization.dart';
import '../bloc/consultation_bloc.dart';
import '../widgets/specialization_card.dart';

class ConsultationsPage extends StatelessWidget {
  const ConsultationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Specialization> specializations = [];
    return BlocProvider(
      create: (context) => GetIt.I.get<ConsultationBloc>(),
      child: Scaffold(
          appBar: CustomAppBar(
            title: StringManager.consultations.tr(),
            actions: [
              IconButton(
                onPressed: () {
                  context.pushNamed(RouteManager.consultationSearch);
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          backgroundColor: ColorManager.c3,
          body: BlocConsumer<ConsultationBloc, ConsultationState>(
            listener: (context, state) {
              if (state is ConsultationsFailure) {
                gShowErrorSnackBar(
                  context: context,
                  message: state.errMessage,
                );
              }
              if (state is ConsultationsLoaded &&
                  state.consultations
                      .consultationsMap[state.currentSpecialization]!.isError) {
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
                specializations = state.consultations.specializations;
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
                    child: Text("No Consultaions"),
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
                                    state
                                        .consultations.specializations[index].id
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
                          context
                              .read<ConsultationBloc>()
                              .add(GetConsultationsPage(
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
                                  .consultationsMap[
                                      state.currentSpecialization]!
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
                                    .consultationsMap[
                                        state.currentSpecialization]!
                                    .consultations
                                    .length) {
                              return ConsultationCard(
                                consultationModel: state
                                    .consultations
                                    .consultationsMap[
                                        state.currentSpecialization]!
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
                                        id: state.currentSpecialization,page: state
                                      .consultations
                                      .consultationsMap[state.currentSpecialization]?.currentPage??0
                                      ),
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
                return const LoadingWidget();
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.pushNamed(
                RouteManager.requestConsultation,
                extra: specializations,
              );
            },
            backgroundColor: ColorManager.c3,
            child: Icon(
              Icons.add,
              size: 40.r,
              color: ColorManager.c2,
            ),
          )),
    );
  }
}
