import '../core/network/network_info.dart';
import '../features/activity/data/datasource/local/activity_local_data_source.dart';
import '../features/activity/data/datasource/remote/activity_remote_data_source.dart';
import '../features/activity/presentation/bloc/activity_bloc.dart';
import '../features/activity/repository/activity_repository.dart';
import '../features/activity/repository/activity_repository_impl.dart';
import 'main_injection.dart';

Future<void> activityInjection() async {
  //remote data source
  locator.registerLazySingleton<ActivityRemoteDataSource>(
    () => ActivityRemoteDataSourceImpl(locator.get()),
  );  locator.registerLazySingleton<ActivityLocalDataSource>(
    () => ActivityLocalDataSourceImpl(locator.get()),
  );

  //repository
  locator.registerLazySingleton<ActivityRepository>(
    () => ActivityRepositoryImpl(
      locator.get<ActivityRemoteDataSource>(),
      locator.get<ActivityLocalDataSource>(),
      locator.get<NetworkInfo>(),
    ),
  );

  //BLoC
  locator.registerFactory(
    () => ActivityBloc(
      locator.get<ActivityRepository>(),
    ),
  );
}
