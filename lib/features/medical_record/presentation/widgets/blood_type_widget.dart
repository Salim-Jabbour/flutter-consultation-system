import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/color_manager.dart';
import '../../model/medical_record_model.dart';
import '../bloc/medical_record_bloc.dart';

class BloodTypeWidget extends StatefulWidget {
  const BloodTypeWidget(
      {super.key, required this.selectedBloodType, required this.isGet});
  final String selectedBloodType;
  final bool isGet;

  @override
  State<BloodTypeWidget> createState() => _BloodTypeWidgetState();
}

class _BloodTypeWidgetState extends State<BloodTypeWidget> {
  final List<String> bloodTypes = [
    'AB+',
    'AB-',
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-'
  ];

  void bloodTypeEnumToString(String bloodEnum) {
    switch (bloodEnum) {
      case 'aPositive':
        bloodType = 'A+';
      case 'aNegative':
        bloodType = 'A-';
      case 'bPositive':
        bloodType = 'B+';
      case 'bNegative':
        bloodType = 'B-';
      case 'abPositive':
        bloodType = 'AB+';
      case 'abNegative':
        bloodType = 'AB-';
      case 'oPositive':
        bloodType = 'O+';
      case 'oNegative':
        bloodType = 'O-';
      default:
        bloodType = 'O+';
    }
  }

  BloodType bloodTypeStringToEnum(String bloodEnum) {
    switch (bloodEnum) {
      case 'A+':
        return BloodType.aPositive;
      case 'A-':
        return BloodType.aNegative;
      case 'B+':
        return BloodType.bPositive;
      case 'B-':
        return BloodType.bNegative;
      case 'AB+':
        return BloodType.abPositive;
      case 'AB-':
        return BloodType.abNegative;
      case 'O+':
        return BloodType.oPositive;
      case 'O-':
        return BloodType.oNegative;
      default:
        return BloodType.oPositive;
    }
  }

  late String bloodType;

  @override
  void initState() {
    bloodTypeEnumToString(widget.selectedBloodType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: bloodTypes.map((type) {
        return ChoiceChip(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          selectedColor: ColorManager.c2,
          label: Text(
            type,
            style: const TextStyle(fontSize: 10, color: ColorManager.c1),
          ),
          selected: bloodType == type,
          onSelected: widget.isGet
              ? null
              : (bool selected) {
                  setState(() {
                    bloodType = type;

                    BloodType bloodTypeEnum = bloodTypeStringToEnum(bloodType);
                    context
                        .read<MedicalRecordBloc>()
                        .add(MedicalRecordChangeBloodType(bloodTypeEnum));
                  });
                },
        );
      }).toList(),
    );
  }
}
