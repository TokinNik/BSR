import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:temp_app/app.dart';
import 'package:temp_app/bloc/global/global_bloc.dart';
import 'package:temp_app/ui/base/base_page.dart';
import 'package:temp_app/ui/pages/temp_next_rout_page.dart';

class TempLoginPage extends BasePage {
  TempLoginPage({Key key})
      : super(
          key: key,
          state: _TempLoginPageState(),
        );
}

class _TempLoginPageState extends State<BaseStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Temp Login Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                globalBloc(context).add(LogOutEvent());
              },
              child: Text("LogOut"),
            ),
            SizedBox(height: 24),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(TempNextRoutPage.route(1));
              },
              child: Text("NextPage"),
            ),
          ],
        ),
      ),
    );
  }
}
