import 'package:bsr/core/servises/impl/preferences_service_impl.dart';
import 'package:bsr/core/servises/preferences_service.dart';
import 'package:get_it/get_it.dart';
import 'package:bsr/core/dio/dio.dart';
import 'package:bsr/core/servises/impl/session_service_impl.dart';
import 'package:bsr/core/servises/session_service.dart';

GetIt getIt = GetIt.instance;

void initDependencies() {
  getIt.registerSingleton<Dio>(
    DioFactory.buildAuthClient(),
    instanceName: "AuthClient",
  );
  getIt.registerSingleton<SessionService>(
    SessionServiceImpl(
      getIt.get(
        instanceName: "AuthClient",
      ),
    ),
  );
  getIt.registerSingleton<PreferencesService>(PreferencesServiceImpl());
  getIt.registerSingleton<Dio>(DioFactory.buildMainClient(getIt.get()));
}
