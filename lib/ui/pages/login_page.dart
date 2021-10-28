import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bsr/app.dart';
import 'package:bsr/bloc/global/global_bloc.dart';
import 'package:bsr/bloc/temp_logout/temp_logout_cubit.dart';
import 'package:bsr/di/dependencies.dart';
import 'package:bsr/generated/l10n.dart';
import 'package:bsr/ui/base/base_page.dart';
import 'package:bsr/utils/logger.dart';

LoginCubit logInCubit(context) =>
    BlocProvider.of<LoginCubit>(context);

class LoginPage extends BasePage<LoginCubit> {
  static route() {
    return MaterialPageRoute(builder: (context) => LoginPage());
  }

  LoginPage({Key key})
      : super(
          key: key,
          bloc: (context) => LoginCubit(getIt.get()),
          state: LoginPageState(),
        );
}

class LoginPageState extends BaseState<LoginState> {
  @override
  void blocListener(LoginState state) {
    logD(state);
    _errorText = "";
    if (state.isSuccessful != null && state.isSuccessful) {
      globalBloc(context).add(LogInEvent());
      //TODO: show success
    } else if (state.error != null) {
      _errorText = state.error.toString();
      //TODO: handle errors
    }
  }

  String _errorText = "";

  @override
  void init() {
    super.initialBlocListener(logInCubit(context).stream);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text(S.current.log_in),
        ),
        body: Column(
          children: [
            Text(_errorText),
            Expanded(
              child: Center(
                child: state.isLoading
                    ? CircularProgressIndicator()
                    : TextButton(
                        onPressed: () {
                          logInCubit(context).logIn();
                        },
                        child: Text(S.current.log_in),
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
