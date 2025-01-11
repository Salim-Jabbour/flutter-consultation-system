import '../core/network/network_info.dart';
import '../features/auth/data/datasource/local/auth_local_data_source.dart';
import '../features/auth/data/datasource/remote/auth_remote_data_source.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/repository/auth_repository.dart';
import '../features/auth/repository/auth_repository_impl.dart';
import 'main_injection.dart';

Future<void> authInjection() async {
  //BLoC
  locator.registerFactory(
    () => AuthBloc(
      locator.get<AuthRepository>(),
    ),
  );

  //repository
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      locator.get<AuthRemoteDataSource>(),
      locator.get<AuthLocalDataSource>(),
      locator.get<NetworkInfo>(),
    ),
  );

  //data sources
  locator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(locator.get()),
  );
  
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(locator.get()),
  );
}
