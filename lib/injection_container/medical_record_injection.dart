import '../core/network/network_info.dart';
// import '../features/medical_record/data/datasource/local/medical_record_local_data_source.dart';
import '../features/medical_record/data/datasource/remote/medical_record_remote_data_source.dart';
import '../features/medical_record/presentation/bloc/medical_record_bloc.dart';
import '../features/medical_record/repository/medical_record_repository.dart';
import '../features/medical_record/repository/medical_record_repository_impl.dart';
import 'main_injection.dart';

Future<void> medicalRecordInjection() async {
  //remote data source
  locator.registerLazySingleton<MedicalRecordRemoteDataSource>(
    () => MedicalRecordRemoteDataSourceImpl(locator.get()),
  );
  // locator.registerLazySingleton<MedicalRecordLocalDataSource>(
  //   () => MedicalRecordLocalDataSourceImpl(locator.get()),
  // );

  //repository
  locator.registerLazySingleton<MedicalRecordRepository>(
    () => MedicalRecordRepositoryImpl(
      locator.get<MedicalRecordRemoteDataSource>(),
      locator.get<NetworkInfo>(),
    ),
  );

  //BLoC
  locator.registerFactory(
    () => MedicalRecordBloc(
      locator.get<MedicalRecordRepository>(),
    ),
  );
}
