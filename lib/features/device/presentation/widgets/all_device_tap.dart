import 'package:akemha/config/theme/color_manager.dart';
import 'package:akemha/core/resource/string_manager.dart';
import 'package:akemha/features/device/presentation/bloc/device_bloc.dart';
import 'package:akemha/features/device/presentation/bloc/device_reservation_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/utils/global_snackbar.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../models/device_model.dart';
import 'device_card.dart';

class AllDevicesTap extends StatelessWidget {
  const AllDevicesTap({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeviceBloc, DeviceState>(
      listener: (context, state) {
        if (state is DevicesFailure) {
          gShowErrorSnackBar(
            context: context,
            message: state.errMessage,
          );
        }
      },
      builder: (context, state) {
        DeviceBloc bloc = context.read<DeviceBloc>();
        if (state is DeviceInitial) {
          bloc.add(GetDevicesPage());
        }
        if (state is DevicesLoading) {
          return const LoadingWidget(fullScreen: true);
        }

        return RefreshIndicator(
          onRefresh: () async {
            bloc.add(GetDevicesPage());
            await bloc.refreshCompleter.future;
          },
          child: ListView.builder(
              itemCount: bloc.devices.length +
                  ((state is DevicesLoaded)
                      ? 2
                      : ((state is DeviceInitial) ? 10 : 0)),
              itemBuilder: (context, index) {
                if (index < bloc.devices.length) {
                  return DeviceCard(
                    onTap: () {
                      _showDeviceDialog(context, bloc.devices[index].id);
                    },
                    height: 100,
                    deviceModel: bloc.devices[index],
                  );
                } else {
                  if (state is DevicesLoaded) {
                    bloc.add(GetDevicesPage(page: state.nextPage));
                  }
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

void _showDeviceDialog(context, int id) async {
  // final selectedOption =
  await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return DeviceDialog(
        id: id,
      );
    },
  );
}

class DeviceDialog extends StatefulWidget {
  const DeviceDialog({
    super.key,
    required this.id,
  });

  final int id;

  @override
  DeviceDialogState createState() => DeviceDialogState();
}

class DeviceDialogState extends State<DeviceDialog> {
  int selected = 1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I.get<DeviceReservationCubit>(),
      child: BlocConsumer<DeviceReservationCubit, DeviceReservationState>(
          listener: (context, state) {
        if (state is DeviceReserved) {
          gShowSuccessSnackBar(context: context, message: state.message);
          context.pop();
        }
        if (state is DeviceReservationFailure) {
          gShowErrorSnackBar(context: context, message: state.errMessage);
          context.pop();
        }
      }, builder: (context, state) {
        if (state is DeviceReservationLoading) {
          return const LoadingWidget(fullScreen: false);
        }
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: Center(child: Text(StringManager.devices.tr())),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selected = 1;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  decoration: selected == 1
                      ? BoxDecoration(
                          color: ColorManager.c2,
                          borderRadius: BorderRadius.circular(8),
                          // border: Border.all(color: Colors.blueAccent, width: 2),
                          boxShadow: const [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(2, 2))
                            ])
                      : BoxDecoration(
                          color: ColorManager.c3,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(-2, -2))
                            ]),
                  height: 45,
                  width: 45,
                  child: Center(
                      child: Text(
                    "1",
                    style: selected == 1
                        ? const TextStyle(color: ColorManager.c3, fontSize: 20)
                        : const TextStyle(color: ColorManager.c1, fontSize: 20),
                  )),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selected = 2;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  decoration: selected == 2
                      ? BoxDecoration(
                          color: ColorManager.c2,
                          borderRadius: BorderRadius.circular(8),
                          // border: Border.all(color: Colors.blueAccent, width: 2),
                          boxShadow: const [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(2, 2))
                            ])
                      : BoxDecoration(
                          color: ColorManager.c3,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(-2, -2))
                            ]),
                  height: 45,
                  width: 45,
                  child: Center(
                      child: Text(
                    "2",
                    style: selected == 2
                        ? const TextStyle(color: ColorManager.c3, fontSize: 20)
                        : const TextStyle(color: ColorManager.c1, fontSize: 20),
                  )),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                StringManager.cancel.tr(),
                style: const TextStyle(color: ColorManager.red),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context
                    .read<DeviceReservationCubit>()
                    .reserveDevice(count: selected, id: widget.id);
              },
              child: Text(StringManager.reserve.tr()),
            ),
          ],
        );
      }),
    );
  }
}
