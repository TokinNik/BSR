part of 'single_game_cubit.dart';

class SingleGameState extends BlocState {
  bool isSuccessful;
  bool isLoading;
  Exception error;
  bool someVar;

  SingleGameState({
    this.isSuccessful = false,
    this.isLoading = false,
    this.error,
    this.someVar,
  });

  @override
  SingleGameState copyWith({
    bool isSuccessful,
    bool isLoading,
    Exception error,
    bool someVar,
  }) {
    return new SingleGameState(
      isSuccessful: isSuccessful ?? this.isSuccessful,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      someVar: someVar,
    );
  }

  @override
  String toString() {
    return 'SingleGameState{isSuccessful: $isSuccessful, isLoading: $isLoading, error: $error, someVar: $someVar}';
  }
}
