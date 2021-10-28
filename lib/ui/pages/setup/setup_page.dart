import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bsr/bloc/setup/setup_cubit.dart';
import 'package:bsr/core/game_logic/game_logic.dart';
import 'package:bsr/core/game_logic/game_module.dart';
import 'package:bsr/core/game_logic/game_settings.dart';
import 'package:bsr/core/game_logic/setup_module/setup_module_impl.dart';
import 'package:bsr/ui/base/base_page.dart';
import 'package:bsr/ui/pages/game/single_game_page.dart';

import 'setup_field_page.dart';

SetupCubit setupCubit(context) => BlocProvider.of<SetupCubit>(context);

class SetupPage extends BasePage<SetupCubit> {
  SetupPage({Key key})
      : super(
          key: key,
          bloc: (context) => SetupCubit(),
          state: _SetupState(),
        );

  static route() {
    return MaterialPageRoute(builder: (context) => SetupPage());
  }
}

class _SetupState extends BaseState<SetupState> {
  GameLogic gameLogic;

  @override
  void blocListener(SetupState state) {
    // TODO: implement blocListener
  }

  @override
  void init() {
    super.initialBlocListener(setupCubit(context).stream);
    var unitSettings = UnitSettings.defaultUnitSettings();
    gameLogic = GameLogic(
      setupModule: SetupModuleImpl(
        maxX: 11,
        maxY: 11,
        unitSettings: unitSettings,
      ),
      gameModule: GameModule(),
      gameSettings: GameSettings(
        unitSettings: unitSettings,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SetupFieldPage(
            gameLogic.setupModule,
          ),
          SizedBox(height: 24),
          TextButton(
            onPressed: () {
              if (!gameLogic.setupModule.isSetupMayDone) {//todo remove "!"
                gameLogic.endSetupMain();
                gameLogic.endSetupEnemy();
                Navigator.of(context).push(SingleGamePage.route(gameLogic));
              } else {
                //todo show hint
              }
            },
            child: Text("Finish setup"),
          ),
        ],
      ),
    );
  }
}
