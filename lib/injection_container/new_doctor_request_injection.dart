import '../core/network/network_info.dart';
import '../features/new_doctor_request/data/datasource/remote/new_doctor_request_remote_data_source.dart';
import '../features/new_doctor_request/presentation/bloc/new_doctor_request_bloc.dart';
import '../features/new_doctor_request/repository/new_doctor_request_repository.dart';
import '../features/new_doctor_request/repository/new_doctor_request_repository_impl.dart';
import 'main_injection.dart';

Future<void> newDoctorRequestInjection() async {
  //remote data source
  locator.registerLazySingleton<NewDoctorRequestRemoteDataSource>(
    () => NewDoctorRequestRemoteDataSourceImpl(locator.get()),
  );

  //repository
  locator.registerLazySingleton<NewDoctorRequestRepository>(
    () => NewDoctorRequestRepositoryImpl(
      locator.get<NewDoctorRequestRemoteDataSource>(),
      locator.get<NetworkInfo>(),
    ),
  );

  //BLoC
  locator.registerFactory(
    () => NewDoctorRequestBloc(
      locator.get<NewDoctorRequestRepository>(),
    ),
  );
}
