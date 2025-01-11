import 'package:akemha/features/consultation/models/specialization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/dbg_print.dart';
import '../bloc/consultation_bloc.dart';

class SpecializationCard extends StatelessWidget {
  const SpecializationCard({
    super.key,
    required this.specialization,
  });

  final Specialization specialization;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context
            .read<ConsultationBloc>()
            .add(ChangeSpecialization(id: specialization.id));
        dbg('specialization${specialization.id}');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: 80.w,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40.r,
                  backgroundImage:
                      CachedNetworkImageProvider(specialization.image),
                ),
              ),
              Text(
                specialization.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
