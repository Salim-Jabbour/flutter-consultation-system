import 'package:akemha/features/alarm/data/datasource/remote/alarm_remote_datasource.dart';
import 'package:akemha/features/alarm/presentation/bloc/alarm_bloc.dart';
import 'package:akemha/features/alarm/repository/alarm_repository.dart';

import '../core/network/network_info.dart';
import '../features/alarm/presentation/bloc/alarm_ring_bloc/alarm_ring_bloc.dart';
import '../features/alarm/repository/alarm_repository_impl.dart';
import 'main_injection.dart';

Future<void> alarmInjection() async {
  //remote data source
  locator.registerLazySingleton<AlarmRemoteDataSource>(
    () => AlarmRemoteDataSourceImpl(locator.get()),
  );

  //repository
  locator.registerLazySingleton<AlarmRepository>(
    () => AlarmRepositoryImpl(
      locator.get<NetworkInfo>(),
      locator.get<AlarmRemoteDataSource>(),
    ),
  );
  //BLoC
  locator.registerFactory(
    () => AlarmBloc(
      locator.get<AlarmRepository>(),
    ),
  );

  locator.registerFactory(
    () => AlarmRingBloc(),
  );
}
