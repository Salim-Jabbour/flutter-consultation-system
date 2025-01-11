import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/utils/dbg_print.dart';
import '../../../../core/utils/global_snackbar.dart';
import '../../../doctor/model/doctor_model.dart';
import '../bloc/doctor_cubit.dart';
import '../page/home_page.dart';
import 'doctor_card.dart';

class DoctorsList extends StatelessWidget {
  const DoctorsList({
    super.key, required this.cubit,
  });

  final DoctorCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocConsumer<DoctorCubit, DoctorState>(
        listener: (context, state) {
          if (state is DoctorsFailure) {
            gShowErrorSnackBar(
              context: context,
              message: state.errMessage,
            );
          }
        },
        builder: (context, state) {
          // DoctorCubit cubit = context.read<DoctorCubit>();
          if (state is DoctorInitial) {
            cubit.getDoctorsPage();
            dbg("initial");
          }
          return SizedBox(
            width: 1.sw,
            height: 220.h,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cubit.doctors.length +
                    ((state is DoctorsLoaded)
                        ? 2
                        : ((state is DoctorInitial) ? 10 : 0)),
                itemBuilder: (context, index) {
                  if (index < cubit.doctors.length) {
                    return DoctorCard(
                      doctor: cubit.doctors[index],
                    );
                  } else {
                    if (state is DoctorsLoaded) {
                      dbg("Looooodiiiiing......");
                      cubit.getDoctorsPage(
                        state.nextPage,
                      );
                    }
                    return const Skeletonizer(
                      enabled: true,
                      child: DoctorCard(
                        doctor: loadingDoctor,
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
