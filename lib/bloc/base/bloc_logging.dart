import 'package:bloc/bloc.dart';
import 'package:bsr/utils/logger.dart';

class LoggingBlocObserver implements BlocObserver {
  LoggingBlocObserver();

  @override
  void onCreate(BlocBase blocBase) {
    logI('[${blocBase.runtimeType}] created.');
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    logI('[${bloc.runtimeType}] ${event.toString()}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    logI('[${bloc.runtimeType}] ${transition.toString()}');
  }

  @override
  void onChange(BlocBase blocBase, Change change) {
    logI('[${blocBase.runtimeType}] ${change.toString()}');
  }

  @override
  void onError(BlocBase blocBase, Object error, StackTrace stacktrace) {
    logE('[${blocBase.runtimeType}]', e: error, stackTrace: stacktrace);
  }

  @override
  void onClose(BlocBase blocBase) {
    logI('[${blocBase.runtimeType}] closed.');
  }
}
