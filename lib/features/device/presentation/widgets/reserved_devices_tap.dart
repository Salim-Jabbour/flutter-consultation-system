import 'package:akemha/features/device/presentation/bloc/reserved_device_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/utils/global_snackbar.dart';
import '../../models/device_model.dart';
import 'device_card.dart';
import 'device_log_card.dart';

class ReservedDevicesTap extends StatelessWidget {
  const ReservedDevicesTap({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReservedDeviceCubit, ReservedDeviceState>(
      listener: (context, state) {
        if (state is ReservedDevicesFailure) {
          gShowErrorSnackBar(
            context: context,
            message: state.errMessage,
          );
        }
      },
      builder: (context, state) {
        ReservedDeviceCubit bloc = context.read<ReservedDeviceCubit>();
        if (state is ReservedDeviceInitial) {
          bloc.getReservedDevices();
        }
        return RefreshIndicator(
          onRefresh: () async {
            await bloc.getReservedDevices();
          },
          child: ListView.builder(
              itemCount: bloc.devices.length +
                  ((state is ReservedDeviceInitial) ? 10 : 0),
              itemBuilder: (context, index) {
                if (index < bloc.devices.length) {
                  return DeviceLogCard(
                    onTap: () {},
                    height: 100,
                    deviceLogModel: bloc.devices[index],
                  );
                } else {
                  return const Skeletonizer(
                    child: DeviceCard(
                      deviceModel: loadingDevice,
                    ),
                  );
                }
              }),
        );
      },
    );
  }
}
