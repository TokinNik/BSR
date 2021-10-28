import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bsr/bloc/single_game/single_game_cubit.dart';
import 'package:bsr/core/game_logic/game_logic.dart';
import 'package:bsr/ui/base/base_page.dart';
import 'package:bsr/ui/pages/game/game_field.dart';

SingleGameCubit singleGameCubit(context) =>
    BlocProvider.of<SingleGameCubit>(context);

class SingleGamePage extends BasePage<SingleGameCubit> {
  SingleGamePage(GameLogic gameLogic, {Key key})
      : super(
          key: key,
          bloc: (context) => SingleGameCubit(),
          state: _SingleGameState(gameLogic),
        );

  static route(GameLogic gameLogic) {
    return MaterialPageRoute(builder: (context) => SingleGamePage(gameLogic));
  }
}

class _SingleGameState extends BaseState<SingleGameState> {
  _SingleGameState(this.gameLogic);

  final GameLogic gameLogic;

  @override
  void blocListener(SingleGameState state) {
    // TODO: implement blocListener
  }

  @override
  void init() {
    super.initialBlocListener(singleGameCubit(context).stream);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
          child: GameField(gameLogic),
        ),
      ),
    );
  }
}