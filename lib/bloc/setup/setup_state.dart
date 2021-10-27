part of 'setup_cubit.dart';

class SetupState extends BlocState {
  bool isSuccessful;
  bool isLoading;
  Exception error;
  bool someVar;

  SetupState({
    this.isSuccessful = false,
    this.isLoading = false,
    this.error,
    this.someVar,
  });

  @override
  SetupState copyWith({
    bool isSuccessful,
    bool isLoading,
    Exception error,
    bool someVar,
  }) {
    return new SetupState(
      isSuccessful: isSuccessful ?? this.isSuccessful,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      someVar: someVar,
    );
  }
}
