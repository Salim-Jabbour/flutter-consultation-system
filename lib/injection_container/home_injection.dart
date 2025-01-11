import 'package:akemha/features/home/data/datasource/local/home_local_data_source.dart';
import 'package:akemha/features/home/data/datasource/remote/home_remote_data_source.dart';
import 'package:akemha/features/home/presentation/bloc/comment_cubit.dart';
import 'package:akemha/features/home/presentation/bloc/doctor_cubit.dart';
import 'package:akemha/features/home/presentation/bloc/home_bloc.dart';
import 'package:akemha/features/home/repository/home_repository.dart';
import 'package:akemha/features/home/repository/home_repository_impl.dart';

import '../core/network/network_info.dart';
import '../features/home/presentation/bloc/add_post_bloc/add_post_bloc.dart';
import '../features/home/presentation/bloc/slider_cubit.dart';
import 'main_injection.dart';

Future<void> homeInjection() async {
  //remote data source
  locator.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(locator.get()),
  );
  locator.registerLazySingleton<HomeLocalDataSource>(
      () => HomeLocalDataSourceImpl(locator.get()));

  //repository
  locator.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      locator.get<HomeRemoteDataSource>(),
      locator.get<HomeLocalDataSource>(),
      locator.get<NetworkInfo>(),
    ),
  );

  //BLoC
  locator.registerFactory(
    () => HomeBloc(
      locator.get<HomeRepository>(),
    ),
  );
  locator.registerFactory(
    () => DoctorCubit(
      locator.get<HomeRepository>(),
    ),
  );
  locator.registerFactory(
    () => SliderCubit(
      locator.get<HomeRepository>(),
    ),
  );
  locator.registerFactoryParam<CommentCubit, int, int?>(
    (id, i) => CommentCubit(locator.get<HomeRepository>(), id),
  );
  // add post Bloc
  locator.registerFactory(
    () => AddPostBloc(
      locator.get<HomeRepository>(),
    ),
  );
}
