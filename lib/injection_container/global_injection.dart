import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/network_info.dart';
import 'main_injection.dart';

Future<void> globalInjection() async {
  // core
  locator
      .registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator.get()));

  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);
  // locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => Connectivity());
}
