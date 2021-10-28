import 'package:bloc/bloc.dart';
import 'package:bsr/bloc/base/base_api_calls.dart';
import 'package:bsr/bloc/base/base_state.dart';
import 'package:bsr/core/servises/session_service.dart';
import 'package:bsr/utils/logger.dart';

part 'temp_logout_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.sessionService) : super(LoginState());

  final SessionService sessionService;

  logIn() async {
    simpleApiCall<LoginState>(
      this,
      sessionService.refreshToken,
      onSuccess: (result) {
        var newToken = result;
        logD(newToken);
      },
      onError: () {
        //TODO: do on error
      },
      showSuccess: true,
    );
  }
}
