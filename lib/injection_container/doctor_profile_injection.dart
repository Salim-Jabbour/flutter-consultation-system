import '../core/network/network_info.dart';

import '../features/role_doctor/doctor_profile/data/datasource/remote/doctor_profile_remote_data_source.dart';
import '../features/role_doctor/doctor_profile/presentation/manager/doctor_profile/doctor_profile_bloc.dart';
import '../features/role_doctor/doctor_profile/repository/doctor_profile_repository.dart';
import '../features/role_doctor/doctor_profile/repository/doctor_profile_repository_impl.dart';
import 'main_injection.dart';

Future<void> doctorProfileInjection() async {
  //remote data source
  locator.registerLazySingleton<DoctorProfileRemoteDataSource>(
    () => DoctorProfileRemoteDataSourceImpl(locator.get()),
  );
  //repository
  locator.registerLazySingleton<DoctorProfileRepository>(
    () => DoctorProfileRepositoryImpl(
      locator.get<DoctorProfileRemoteDataSource>(),
      locator.get<NetworkInfo>(),
    ),
  );

  //profile BLoC
  locator.registerFactory(
    () => DoctorProfileBloc(
      locator.get<DoctorProfileRepository>(),
    ),
  );

  
}
