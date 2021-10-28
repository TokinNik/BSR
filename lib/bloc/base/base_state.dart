import 'package:bsr/core/dio/errors/dio_errors.dart';

abstract class BlocState {
  bool isLoading;
  bool isSuccessful;
  Exception error;

  BlocState copyWith({
    bool isSuccessful,
    bool isLoading,
    ApiErrorException error,
  });
}
