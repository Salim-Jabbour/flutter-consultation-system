import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/router/route_manager.dart';
import '../../../../config/theme/color_manager.dart';
import '../../../../core/resource/asset_manager.dart';
import '../../../../core/resource/string_manager.dart';
import '../../model/medical_record_model.dart';

class AddMedicalRecordButton extends StatelessWidget {
  const AddMedicalRecordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 200.h),
          SizedBox(
            height: 200.h,
            width: 150.h,
            child: Image.asset(AssetImageManager.noMedicalRecord),
          ),
          const SizedBox(height: 20),
          Text(
            StringManager.noMedicalRecord.tr(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              context.pushNamed(
                RouteManager.addMedicalRecord,
                extra:  MedicalRecordModelData(
                    id: 0,
                    coffee: false,
                    alcohol: false,
                    married: false,
                    smoker: false,
                    covidVaccine: false,
                    height: 80,
                    weight: 50,
                    bloodType: BloodType.oPositive,
                    previousSurgeries: [],
                    previousIllnesses: [],
                    allergies: [],
                    familyHistoryOfIllnesses: []),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.c2,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              // textStyle: const TextStyle(fontSize: 18),
            ),
            child: Text(
              StringManager.add.tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorManager.c3,
                fontSize: 18.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
