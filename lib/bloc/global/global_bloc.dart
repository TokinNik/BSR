import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bsr/core/data/preferences.dart';
import 'package:bsr/core/servises/preferences_service.dart';
import 'package:equatable/equatable.dart';

part 'global_event.dart';

part 'global_state.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  GlobalBloc(this._preferencesService) : super(GlobalState());

  final PreferencesService _preferencesService;

  @override
  Stream<GlobalState> mapEventToState(
    GlobalEvent event,
  ) async* {
    if (event is LogInEvent) {
      yield state.copyWith(
        appState: AppState.LOG_IN,
      );
    } else if (event is LogOutEvent) {
      yield state.copyWith(
        appState: AppState.LOG_OUT,
      );
    } else if (event is GetPreferencesEvent) {
      var prefs = await _preferencesService.getPreferences();
      yield state.copyWith(
        preferences: prefs,
        appState: state.appState == AppState.SPLASH
            ? AppState.LOG_OUT
            : state.appState,
      );
    } else if (event is SetPreferencesEvent) {
      await _preferencesService.setPreferences(event.preferences);
      yield state.copyWith(
        preferences: event.preferences,
      );
    }
  }
}
