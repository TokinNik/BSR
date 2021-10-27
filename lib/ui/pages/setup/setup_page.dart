import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:temp_app/bloc/setup/setup_cubit.dart';
import 'package:temp_app/core/game_logic/game_logic.dart';
import 'package:temp_app/core/game_logic/game_module.dart';
import 'package:temp_app/core/game_logic/game_settings.dart';
import 'package:temp_app/core/game_logic/setup_module/setup_module_impl.dart';
import 'package:temp_app/ui/base/base_page.dart';
import 'package:temp_app/ui/pages/draggable_test.dart';

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
    gameLogic = GameLogic(
      setupModule: SetupModuleImpl(maxX: 11, maxY: 11),
      gameModule: GameModule(),
      gameSettings: GameSettings(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SetupFieldPage(gameLogic.setupModule);
  }
}
