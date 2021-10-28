import 'package:bsr/utils/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bsr/app.dart';
import 'package:bsr/bloc/global/global_bloc.dart';
import 'package:bsr/generated/l10n.dart';
import 'package:bsr/ui/base/base_page.dart';
import 'package:bsr/ui/pages/setup/setup_page.dart';
import 'package:bsr/ui/pages/temp_next_rout_page.dart';
import 'package:bsr/utils/extensions.dart';

class MainMenuPage extends BasePage {
  MainMenuPage({Key key})
      : super(
          key: key,
          state: _MainMenuPageState(),
        );
}

class _MainMenuPageState extends State<BaseStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    var s = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("BSR Main Menu"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                globalBloc(context).add(LogOutEvent());
              },
              child: Text(s.log_out),
            ),
            // SizedBox(height: 24),
            // TextButton(
            //   onPressed: () {
            //     Navigator.of(context).push(TempNextRoutPage.route(1));
            //   },
            //   child: Text(s.next_page),
            // ),
            SizedBox(height: 24),
            TextButton(
              onPressed: () {
                S.delegate.supportedLocales.printAll();
                var newLocale = Intl.defaultLocale ==
                        S.delegate.supportedLocales.first.languageCode
                    ? S.delegate.supportedLocales.last
                    : S.delegate.supportedLocales.first;
                S.delegate.load(newLocale).then(
                      (value) => setState(
                        () {
                          globalBloc(context).add(
                            SetPreferencesEvent(
                              globalBloc(context)
                                  .state
                                  .preferences
                                  .copyWith(locale: newLocale.languageCode),
                            ),
                          );
                        },
                      ),
                    );
              },
              child: Text(s.change_locale),
            ),
            SizedBox(height: 24),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(SetupPage.route());
              },
              child: Text(s.new_game),
            ),
          ],
        ),
      ),
    );
  }
}
