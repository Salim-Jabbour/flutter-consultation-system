import 'package:akemha/core/network/network_info.dart';
import 'package:akemha/features/chat/data/datasource/remote/chat_remote_data_source.dart';
import 'package:akemha/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:akemha/features/chat/repository/chat_repository.dart';
import 'package:akemha/features/chat/repository/chat_repository_impl.dart';
import 'package:akemha/injection_container/main_injection.dart';

Future<void> chatInjection() async {
  //remote data source
  locator.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(locator.get()),
  );

  //repository
  locator.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      locator.get<ChatRemoteDataSource>(),
      locator.get<NetworkInfo>(),
    ),
  );

  //BLoC
  locator.registerFactory(
    () => ChatBloc(
      locator.get<ChatRepository>(),
    ),
  );
}
