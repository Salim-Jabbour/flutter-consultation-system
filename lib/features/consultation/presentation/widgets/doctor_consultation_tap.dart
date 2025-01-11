import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/utils/global_snackbar.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../models/Consultation.dart';
import '../bloc/doctor_consultation_bloc.dart';
import 'consultation_card.dart';

class DoctorConsultationTap extends StatelessWidget {
  const DoctorConsultationTap({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I.get<DoctorConsultationBloc>(),
      child: BlocConsumer<DoctorConsultationBloc, DoctorConsultationState>(
        listener: (context, state) {
          if (state is DoctorConsultationsFailure) {
            gShowErrorSnackBar(
              context: context,
              message: state.errMessage,
            );
          }
        },
        builder: (context, state) {
          DoctorConsultationBloc bloc = context.read<DoctorConsultationBloc>();
          if (state is DoctorConsultationInitial) {
            bloc.add(GetDoctorConsultationsPage());
          }
          if (state is DoctorConsultationsLoading) {
            return const LoadingWidget(fullScreen: true);
          }
          if (state is DoctorConsultationsFailure) {
            return FailureWidget(
              errorMessage: state.errMessage,
              onPressed: () {
                bloc.add(GetDoctorConsultationsPage());
              },
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              bloc.add(GetDoctorConsultationsPage());
              await bloc.refreshCompleter.future;
            },
            child: ListView.builder(
                itemCount: bloc.doctorConsultations.length +
                    ((state is DoctorConsultationsLoaded)
                        ? 2
                        : ((state is DoctorConsultationInitial) ? 10 : 0)),
                itemBuilder: (context, index) {
                  if (index < bloc.doctorConsultations.length) {
                    return ConsultationCard(
                      consultationModel: bloc.doctorConsultations[index],
                      canAnswered: true,
                    );
                  } else {
                    if (state is DoctorConsultationsLoaded) {
                      bloc.add(
                          GetDoctorConsultationsPage(page: state.nextPage));
                    }
                    return  Skeletonizer(
                      child: ConsultationCard(
                        consultationModel: loadingConsultation,
                      ),
                    );
                  }
                }),
          );
        },
      ),
    );
  }
}
