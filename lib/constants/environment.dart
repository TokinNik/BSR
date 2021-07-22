import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temp_app/bloc/base/bloc_logging.dart';
import 'package:temp_app/di/dependencies.dart';

abstract class Environment {
  static const bool _isProd = false;

  //TODO: Your api endpoint
  static const String baseUrl =
      _isProd ? 'https://test.ru/' : 'https://prod.ru/';
  static const bool isBlocLoggingEnabled = !_isProd;

  static Future<void> init() async {
    initDependencies();

    if (isBlocLoggingEnabled) {
      Bloc.observer = LoggingBlocObserver();
    }

    //TODO: Other settings...
  }
}
