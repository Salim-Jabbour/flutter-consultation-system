// ignore_for_file: must_be_immutable

import 'package:akemha/core/widgets/custom_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/resource/string_manager.dart';
import '../../../../core/widgets/empty_widget.dart';
import '../../models/activity_model.dart';
import '../bloc/activity_bloc.dart';
import '../widgets/activity_card.dart';

class ActivitiesPage extends StatelessWidget {
  ActivitiesPage({super.key});
  List<ActivityModel> activities = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: StringManager.activities.tr(),
      ),
      body: BlocProvider(
        create: (context) => GetIt.I.get<ActivityBloc>(),
        child: BlocConsumer<ActivityBloc, ActivityState>(
            listener: (context, state) {
          if (state is ActivityLoaded) {
            activities = state.activities;
          }
        }, builder: (context, state) {
          if (state is ActivityInitial) {
            context.read<ActivityBloc>().add(GetActivitiesPage());
          }
          if (state is ActivityLoaded) {
            if (activities.isEmpty) {
              return EmptyWidget(height: 0.7.sh);
            } else {
              return ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    return ActivityCard(
                      activity: activities[index],
                    );
                  });
            }
          }

          if (state is ActivityLoading) {
            final ActivityModel activity = ActivityModel(
              id: 0,
              title: "جائحة كورونا",
              description:
                  "أثناء حدوث الجائحة الأولى قمنا بتنشيط عدة مناطق وإجراء فحوصات مجانية لأكثر من 2500 شخص كما تم الإعتناء دوائيا وطبيا بالمرضى التي ظهرت لديهم نتيجة الفحص إيجابية",
              imageUrl:
                  "https://media.istockphoto.com/id/1346124900/photo/confident-successful-mature-doctor-at-hospital.jpg?s=612x612&w=0&k=20&c=S93n5iTDVG3_kJ9euNNUKVl9pgXTOdVQcI_oDGG-QlE=",
            );
            return ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Skeletonizer(
                    enabled: true,
                    child: ActivityCard(
                      activity: activity,
                    ),
                  );
                });
          }
          return const Center(child: Text("No Data Found"));
        }),
      ),
    );
  }
}
