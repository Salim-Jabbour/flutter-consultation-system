import '../core/network/network_info.dart';
import '../features/medicine_calendar/data/datasource/local/medicine_calendar_local_data_source.dart';
import '../features/medicine_calendar/data/datasource/remote/medicine_calendar_remote_data_source.dart';
import '../features/medicine_calendar/presentation/bloc/medicine_calendar_bloc.dart';
import '../features/medicine_calendar/repository/medicine_calendar_repository.dart';
import '../features/medicine_calendar/repository/medicine_calendar_repository_impl.dart';
import 'main_injection.dart';

Future<void> medicineCalendarInjection() async {
  //remote data source
  locator.registerLazySingleton<MedicineCalendarRemoteDataSource>(
    () => MedicineCalendarRemoteDataSourceImpl(locator.get()),
  );  locator.registerLazySingleton<MedicineCalendarLocalDataSource>(
    () => MedicineCalendarLocalDataSourceImpl(locator.get()),
  );

  //repository
  locator.registerLazySingleton<MedicineCalendarRepository>(
    () => MedicineCalendarRepositoryImpl(
      locator.get<MedicineCalendarRemoteDataSource>(),
      locator.get<MedicineCalendarLocalDataSource>(),
      locator.get<NetworkInfo>(),
    ),
  );

  //BLoC
  locator.registerFactory(
    () => MedicineCalendarBloc(
      locator.get<MedicineCalendarRepository>(),
    ),
  );
}
