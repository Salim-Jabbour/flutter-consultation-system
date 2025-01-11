import 'package:akemha/features/consultation/presentation/bloc/answer_consultation_cubit.dart';
import 'package:akemha/features/consultation/presentation/bloc/consultation_search_cubit.dart';
import 'package:akemha/features/consultation/presentation/bloc/doctor_consultation_bloc.dart';

import '../core/network/network_info.dart';
import '../features/consultation/data/datasource/local/consultation_local_data_source.dart';
import '../features/consultation/data/datasource/remote/consultation_remote_data_source.dart';
import '../features/consultation/presentation/bloc/consultation_bloc.dart';
import '../features/consultation/repository/consultation_repository_impl.dart';
import 'main_injection.dart';

Future<void> consultationInjection() async {
  //remote data source
  locator.registerLazySingleton<ConsultationRemoteDataSource>(
    () => ConsultationRemoteDataSourceImpl(locator.get()),
  );
  locator.registerLazySingleton<ConsultationLocalDataSource>(
    () => ConsultationLocalDataSourceImpl(locator.get()),
  );

  //repository
  locator.registerLazySingleton<ConsultationRepository>(
    () => ConsultationRepositoryImpl(
      locator.get<ConsultationRemoteDataSource>(),
      locator.get<ConsultationLocalDataSource>(),
      locator.get<NetworkInfo>(),
    ),
  );

  //BLoC
  locator.registerFactory(
    () => ConsultationBloc(
      locator.get<ConsultationRepository>(),
    ),
  );
  locator.registerFactory(
    () => DoctorConsultationBloc(
      locator.get<ConsultationRepository>(),
    ),
  );
  locator.registerFactory(
    () => AnswerConsultationCubit(
      locator.get<ConsultationRepository>(),
    ),
  );
  locator.registerFactory(
    () => ConsultationSearchCubit(
      locator.get<ConsultationRepository>(),
    ),
  );
}
