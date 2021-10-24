part of 'temp_logout_cubit.dart';

class TempLogoutState implements BlocState {
  bool isSuccessful;
  bool isLoading;
  Exception error;
  bool someVar;

  TempLogoutState({
    this.isSuccessful = false,
    this.isLoading = false,
    this.error,
    this.someVar,
  });

  @override
  TempLogoutState copyWith({
    bool isSuccessful,
    bool isLoading,
    Exception error,
    bool someVar,
  }) {
    return new TempLogoutState(
      isSuccessful: isSuccessful ?? this.isSuccessful,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      someVar: someVar,
    );
  }

  @override
  String toString() {
    return 'TempLogoutState{isSuccessful: $isSuccessful, isLoading: $isLoading, error: $error, someVar: $someVar}';
  }
}
