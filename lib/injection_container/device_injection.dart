// ignore_for_file: unused_import

import 'package:akemha/features/device/data/datasource/local/device_local_data_source.dart';
import 'package:akemha/features/device/presentation/bloc/device_reservation_cubit.dart';
import 'package:akemha/features/device/presentation/bloc/reserved_device_cubit.dart';

import '../core/network/network_info.dart';
import '../features/device/data/datasource/remote/device_remote_data_source.dart';
import '../features/device/presentation/bloc/device_bloc.dart';
import '../features/device/repository/device_repository.dart';
import '../features/device/repository/device_repository_impl.dart';
import '../features/doctor/data/datasource/remote/doctor_remote_data_source.dart';
import '../features/doctor/presentation/bloc/doctor_bloc.dart';
import '../features/doctor/repository/doctor_repository.dart';
import '../features/doctor/repository/doctor_repository_impl.dart';
import 'main_injection.dart';

Future<void> deviceInjection() async {
  //remote data source
  locator.registerLazySingleton<DeviceRemoteDataSource>(
    () => DeviceRemoteDataSourceImpl(locator.get()),
  );
  locator.registerLazySingleton<DeviceLocalDataSource>(
    () => DeviceLocalDataSourceImpl(locator.get()),
  );

  //repository
  locator.registerLazySingleton<DeviceRepository>(
    () => DeviceRepositoryImpl(
      locator.get<DeviceRemoteDataSource>(),
      locator.get<DeviceLocalDataSource>(),
      locator.get<NetworkInfo>(),
    ),
  );

  //BLoC
  locator.registerFactory(
    () => DeviceBloc(
      locator.get<DeviceRepository>(),
    ),
  );  locator.registerFactory(
    () => ReservedDeviceCubit(
      locator.get<DeviceRepository>(),
    ),
  );
  locator.registerFactory(
    () => DeviceReservationCubit(
      locator.get<DeviceRepository>(),
    ),
  );
}
