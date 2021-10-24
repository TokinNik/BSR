import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temp_app/core/dio/errors/dio_errors.dart';
import 'package:temp_app/utils/check_connection.dart';

import 'base_state.dart';

simpleApiCall<STATE extends BlocState>(
  BlocBase blocBaseOwner,
  Function apiCall, {
  Function(dynamic) onSuccess,
  Function onError,
  bool showSuccess = true,
}) async {
  blocBaseOwner.emit((blocBaseOwner.state as STATE).copyWith(
    isLoading: true,
    error: null,
  ));
  var check = await checkConnection();
  if (check) {
    try {
      var result = await apiCall.call();
      onSuccess?.call(result);
      blocBaseOwner.emit((blocBaseOwner.state as STATE).copyWith(
        isSuccessful: showSuccess,
        isLoading: false,
      ));
      blocBaseOwner
          .emit((blocBaseOwner.state as STATE).copyWith(isSuccessful: false));
    } catch (e) {
      onError?.call();
      blocBaseOwner.emit((blocBaseOwner.state as STATE).copyWith(
        error: e,
        isLoading: false,
      ));
      blocBaseOwner.emit((blocBaseOwner.state as STATE).copyWith(error: null));
    }
  } else {
    blocBaseOwner.emit((blocBaseOwner.state as STATE).copyWith(
      error: ConnectionLostException(),
      isLoading: false,
    ));
  }
}
