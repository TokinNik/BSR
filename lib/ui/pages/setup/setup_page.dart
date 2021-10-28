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
  final int playersCount = 2;
  GameLogic gameLogic;
  int currentPlayer = 1;
  bool isSwitchSetupVisible = false;

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
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Player ${currentPlayer} setup"),
              SizedBox(height: 24),
              SetupFieldPage(
                gameLogic.setupModule,
              ),
              SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  if (true || gameLogic.setupModule.isSetupMayDone) {
                    //todo remove "true"
                    gameLogic.endSetup(currentPlayer - 1);
                    currentPlayer++;
                    if (currentPlayer > playersCount) {
                      Navigator.of(context).pushReplacement(SingleGamePage.route(gameLogic));
                    } else {
                      setState(() {
                        gameLogic.setupModule.clean();
                        isSwitchSetupVisible = true;
                      });
                    }
                    //gameLogic.endSetupEnemy();
                  } else {
                    //todo show hint
                  }
                },
                child: Text("Finish setup"),
              ),
            ],
          ),
          isSwitchSetupVisible ? _buildSwitchSetupWidget() : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildSwitchSetupWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSwitchSetupVisible = false;
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey,
        child: Center(child: Text("Tap to start setup")),
      ),
    );
  }
}
