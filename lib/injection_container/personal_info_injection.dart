import '../core/network/network_info.dart';
import '../features/personal_info/data/datasource/local/personal_info_local_data_source.dart';
import '../features/personal_info/data/datasource/remote/personal_info_remote_data_source.dart';
import '../features/personal_info/presentation/bloc/personal_info_bloc.dart';
import '../features/personal_info/repository/personal_info_repository.dart';
import '../features/personal_info/repository/personal_info_repository_impl.dart';
import 'main_injection.dart';

Future<void> personalInfoInjection() async {
  //remote data source
  locator.registerLazySingleton<PersonalInfoRemoteDataSource>(
    () => PersonalInfoRemoteDataSourceImpl(locator.get()),
  );  locator.registerLazySingleton<PersonalInfoLocalDataSource>(
    () => PersonalInfoLocalDataSourceImpl(locator.get()),
  );

  //repository
  locator.registerLazySingleton<PersonalInfoRepository>(
    () => PersonalInfoRepositoryImpl(
      locator.get<PersonalInfoRemoteDataSource>(),
      locator.get<PersonalInfoLocalDataSource>(),
      locator.get<NetworkInfo>(),
    ),
  );

  //BLoC
  locator.registerFactory(
    () => PersonalInfoBloc(
      locator.get<PersonalInfoRepository>(),
    ),
  );
}
