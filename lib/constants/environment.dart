import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bsr/bloc/base/bloc_logging.dart';
import 'package:bsr/di/dependencies.dart';

abstract class Environment {
  static const bool _isProd = false;

  //TODO: Your api endpoint
  static const String baseUrl =
      _isProd ? 'https://prod.ru/' : 'https://test.ru/';
  static const bool isBlocLoggingEnabled = !_isProd;
  static const bool isApiLoggingEnabled = !_isProd;

  static Future<void> init() async {
    initDependencies();

    if (isBlocLoggingEnabled) {
      Bloc.observer = LoggingBlocObserver();
    }

    //TODO: Other settings...
  }
}
