import 'package:akemha/config/theme/color_manager.dart';
import 'package:akemha/core/resource/string_manager.dart';
import 'package:akemha/features/device/presentation/bloc/device_bloc.dart';
import 'package:akemha/features/device/presentation/bloc/reserved_device_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../widgets/all_device_tap.dart';
import '../widgets/reserved_devices_tap.dart';

class DevicesPage extends StatelessWidget {
  const DevicesPage({super.key});

  // final List allDevices = const [
  //   DeviceModel(
  //     id: 0,
  //     reservedCount: 0,
  //     imagePublicId: "",
  //     imageUrl:
  //         "https://d2jx2rerrg6sh3.cloudfront.net/images/Article_Images/ImageForArticle_22588_16539156642301393.jpg",
  //     name: "device 11",
  //     count: 11,
  //   ),
  //   DeviceModel(
  //     id: 0,
  //     reservedCount: 0,
  //     imagePublicId: "",
  //     imageUrl:
  //         "https://www.shutterstock.com/image-photo/automatic-blood-pressure-monitor-on-260nw-1869886099.jpg",
  //     name: "device 22",
  //     count: 5,
  //   ),
  //   DeviceModel(
  //     id: 0,
  //     reservedCount: 0,
  //     imagePublicId: "",
  //     imageUrl: "https://medlineplus.gov/images/MedicalDeviceSafety_share.jpg",
  //     name: "device 33",
  //     count: 7,
  //   ),
  // ];
  // final List reservedDevices = const [
  //   DeviceModel(
  //     id: 0,
  //     reservedCount: 0,
  //     imagePublicId: "",
  //     imageUrl:
  //         "https://d2jx2rerrg6sh3.cloudfront.net/images/Article_Images/ImageForArticle_22588_16539156642301393.jpg",
  //     name: "device 1",
  //     count: 11,
  //   ),
  //   DeviceModel(
  //     id: 0,
  //     reservedCount: 0,
  //     imagePublicId: "",
  //     imageUrl:
  //         "https://www.shutterstock.com/image-photo/automatic-blood-pressure-monitor-on-260nw-1869886099.jpg",
  //     name: "device 2",
  //     count: 5,
  //   ),
  //   DeviceModel(
  //     id: 0,
  //     reservedCount: 0,
  //     imagePublicId: "",
  //     imageUrl: "https://medlineplus.gov/images/MedicalDeviceSafety_share.jpg",
  //     name: "device 3",
  //     count: 7,
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorManager.c3,
          bottom: TabBar(
            tabs: [
              Tab(
                // icon: Icon(Icons.directions_car),
                child: Text(StringManager.all.tr()),
              ),
              Tab(
                // icon: Icon(Icons.directions_transit),
                child: Text(StringManager.reserved.tr()),
              ),
              // Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),
          centerTitle: true,
          title: Text(
            StringManager.devices.tr(),
            style: const TextStyle(
              color: ColorManager.c1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => GetIt.I.get<DeviceBloc>(),
            ),
            BlocProvider(
              create: (context) => GetIt.I.get<ReservedDeviceCubit>(),
            ),
          ],
          child: const TabBarView(
            children: [
              AllDevicesTap(),
              ReservedDevicesTap(),
              // Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}
