import 'package:bsr/core/data/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bsr/bloc/global/global_bloc.dart';
import 'package:bsr/ui/pages/login_page.dart';
import 'package:bsr/ui/pages/main_menu_page.dart';

import 'di/dependencies.dart';
import 'generated/l10n.dart';

GlobalBloc globalBloc(context) => BlocProvider.of<GlobalBloc>(context);

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  GlobalBloc _globalBloc;

  @override
  void initState() {
    super.initState();
    _globalBloc = GlobalBloc(getIt.get());
    _globalBloc.add(GetPreferencesEvent());
  }

  @override
  void dispose() {
    _globalBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GlobalBloc>(
      create: (BuildContext context) => _globalBloc,
      child: BlocBuilder<GlobalBloc, GlobalState>(
        bloc: _globalBloc,
        builder: (context, state) {
          return state.appState == AppState.SPLASH
              ? Container(
                  child: CircularProgressIndicator(),
                )
              : MaterialApp(
                  theme: ThemeData.dark(),
                  localizationsDelegates: [
                    S.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: S.delegate.supportedLocales,
                  locale: Locale.fromSubtags(
                    languageCode:
                        state.preferences?.locale ?? "en",
                  ),
                  home: _buildPage(state),
                );
        },
      ),
    );
  }

  Widget _buildPage(GlobalState state) {
    switch (state.appState) {
      case AppState.LOG_IN:
        return MainMenuPage();
        break;
      case AppState.LOG_OUT:
        return LoginPage();
        break;
      case AppState.SPLASH:
        return Container(
          child: CircularProgressIndicator(),
        );
        break;
    }
    return Center(
      child: Text("Unknown app state"),
    );
  }
}
