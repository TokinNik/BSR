part of 'global_bloc.dart';

class GlobalState {
  final AppState appState;
  final Preferences preferences;

  GlobalState({
    this.appState = AppState.SPLASH,
    this.preferences,
  });


  @override
  String toString() {
    return 'GlobalState{appState: $appState, preferences: $preferences}';
  }

  GlobalState copyWith({
    AppState appState,
    Preferences preferences,
  }) {
    return GlobalState(
      appState: appState ?? this.appState,
      preferences: preferences ?? this.preferences,
    );
  }
}

enum AppState {
  LOG_IN,
  LOG_OUT,
  SPLASH,
  //TODO: Other state
}
