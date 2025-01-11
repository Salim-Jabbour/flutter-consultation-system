import '../core/network/network_info.dart';
import '../features/doctor/data/datasource/remote/doctor_remote_data_source.dart';
import '../features/doctor/presentation/bloc/doctor_bloc.dart';
import '../features/doctor/repository/doctor_repository.dart';
import '../features/doctor/repository/doctor_repository_impl.dart';
import 'main_injection.dart';

Future<void> doctorInjection() async {
  //remote data source
  locator.registerLazySingleton<DoctorRemoteDataSource>(
    () => DoctorRemoteDataSourceImpl(locator.get()),
  );

  //repository
  locator.registerLazySingleton<DoctorRepository>(
    () => DoctorRepositoryImpl(
      locator.get<DoctorRemoteDataSource>(),
      locator.get<NetworkInfo>(),
    ),
  );

  //BLoC
  locator.registerFactory(
    () => DoctorBloc(
      locator.get<DoctorRepository>(),
    ),
  );
}
