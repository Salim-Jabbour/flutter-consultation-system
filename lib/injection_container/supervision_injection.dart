import '../core/network/network_info.dart';
import '../features/supervision/data/datasource/remote/supervision_remote_data_source.dart';
import '../features/supervision/presentation/bloc/bell_bloc/bell_bloc.dart';
import '../features/supervision/presentation/bloc/first_page_bloc/first_page_bloc.dart';
import '../features/supervision/presentation/bloc/floating_button/floating_bloc.dart';
import '../features/supervision/presentation/bloc/second_page_bloc/second_page_bloc.dart';
import '../features/supervision/repository/supervision_repository.dart';
import '../features/supervision/repository/supervision_repository_impl.dart';
import 'main_injection.dart';

Future<void> supervisionInjection() async {
  //remote data source
  locator.registerLazySingleton<SupervisionRemoteDataSource>(
    () => SupervisionRemoteDataSourceImpl(locator.get()),
  );

  //repository
  locator.registerLazySingleton<SupervisionRepository>(
    () => SupervisionRepositoryImpl(
      locator.get<SupervisionRemoteDataSource>(),
      locator.get<NetworkInfo>(),
    ),
  );

  //BLoC
  locator.registerFactory(
    () => FirstPageBlocBloc(
      locator.get<SupervisionRepository>(),
    ),
  );

  locator.registerFactory(
    () => SecondPageBloc(
      locator.get<SupervisionRepository>(),
    ),
  );

  locator.registerFactory(
    () => BellBloc(
      locator.get<SupervisionRepository>(),
    ),
  );
  locator.registerFactory(
    () => FloatingBloc(
      locator.get<SupervisionRepository>(),
    ),
  );
}
