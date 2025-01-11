import '../core/network/network_info.dart';
import '../features/consultation_log/data/datasource/local/consultation_local_data_source.dart';
import '../features/consultation_log/data/datasource/remote/consultation_remote_data_source.dart';

import 'package:akemha/features/consultation_log/presentation/bloc/consultation_log_bloc.dart';
import '../features/consultation_log/repository/consultation_repository.dart';
import '../features/consultation_log/repository/consultation_repository_impl.dart';
import 'main_injection.dart';

Future<void> consultationLogInjection() async {
  //remote data source
  locator.registerLazySingleton<ConsultationLogRemoteDataSource>(
    () => ConsultationLogRemoteDataSourceImpl(locator.get()),
  );  locator.registerLazySingleton<ConsultationLogLocalDataSource>(
    () => ConsultationLogLocalDataSourceImpl(locator.get()),
  );

  //repository
  locator.registerLazySingleton<ConsultationLogRepository>(
    () => ConsultationLogRepositoryImpl(
      locator.get<ConsultationLogRemoteDataSource>(),
      locator.get<ConsultationLogLocalDataSource>(),
      locator.get<NetworkInfo>(),
    ),
  );

  //BLoC
  locator.registerFactory(
    () {
      return ConsultationLogBloc(
        locator.get<ConsultationLogRepository>(),
      )
      ;
    }
  );
}
