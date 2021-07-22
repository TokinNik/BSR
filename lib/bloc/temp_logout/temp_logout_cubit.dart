import 'package:bloc/bloc.dart';
import 'package:temp_app/core/servises/session_service.dart';
import 'package:temp_app/utils/logger.dart';

part 'temp_logout_state.dart';

class TempLogoutCubit extends Cubit<TempLogoutState> {
  TempLogoutCubit(this.sessionService) : super(TempLogoutState());

  final SessionService sessionService;

  logIn() async {
    emit(state.copyWith(isLoading: true));
    var newToken = await sessionService.refreshToken();
    logD(newToken);
    emit(state.copyWith(
      isLoading: false,
      isSuccessful: true,
    ));
    emit(state.copyWith(isSuccessful: false));
  }

}
