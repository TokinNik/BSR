import 'package:flutter/material.dart';
import 'package:temp_app/core/game_logic/cell.dart';
import 'package:temp_app/core/game_logic/game_logic.dart';
import 'package:temp_app/core/game_logic/game_module.dart';
import 'package:temp_app/ui/base/base_page.dart';
import 'package:temp_app/utils/logger.dart';

class GameField extends BasePage {
  GameField(GameLogic gameLogic, {Key key})
      : super(
          key: key,
          state: _GameFieldState(gameLogic),
        );
}

class _GameFieldState extends State<BaseStatefulWidget> {
  static const double DEF_CELL_SIZE = 30;
  static const double DEF_CELL_PADDING = 1;

  _GameFieldState(this.gameLogic);

  final GameLogic gameLogic;

  var cellSize = DEF_CELL_SIZE; //todo move to GameSettings?

  bool isMainField = true;

  bool isStartVisible = true;
  bool isEndVisible = false;
  bool isSwitchVisible = false;

  List<List<Cell>> get getSourceField => isMainField
      ? gameLogic.gameModule.currentPlayer.mainField
      : gameLogic.gameModule.currentEnemy.mainField;

  onGameGsateChangedListener(GameState gameState) {
    logD(
        "NEW_STATE: $gameState  ${gameLogic.gameModule.currentPlayerId}  ${gameLogic.gameModule.currentEnemyId}");
    setState(() {
      switch (gameState) {
        case GameState.START:
          // TODO: Handle this case.
          break;
        case GameState.TURN:
          // TODO: Handle this case.
          break;
        case GameState.CHECK:
          isStartVisible = false;
          isEndVisible = false;
          isSwitchVisible = false;
          break;
        case GameState.TURN_RESULT:
          // TODO: Handle this case.
          break;
        case GameState.SWITCH:
          isSwitchVisible = true;
          break;
        case GameState.END:
          isStartVisible = false;
          isEndVisible = true;
          isSwitchVisible = false;
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    gameLogic.gameModule.onGameStateChanged = onGameGsateChangedListener;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildField(),
        isStartVisible ? _buildStartWidget() : SizedBox.shrink(),
        isSwitchVisible ? _buildSwitchWidget() : SizedBox.shrink(),
        isEndVisible ? _buildEndWidget() : SizedBox.shrink(),
        gameLogic.gameModule.gameState == GameState.CHECK
            ? _buildCheckWidget()
            : SizedBox.shrink(),
      ],
    );
  }

  Widget _buildField() {
    cellSize = MediaQuery.of(context).size.width * 0.07; //todo add resizer
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCells(),
          SizedBox(height: 24),
          TextButton(
            onPressed: () {
              setState(() {
                isMainField = !isMainField;
              });
            },
            child: Text("Switch field to ${isMainField ? "Enemy" : "Main"}"),
          ),
        ],
      ),
    );
  }

  Widget _buildCells() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < gameLogic.setupModule.maxX; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var j = 0; j < gameLogic.setupModule.maxY; j++)
                _buildCell(i, j),
            ],
          )
      ],
    );
  }

  Widget _buildCell(int x, int y) {
    var unit = getSourceField[x][y];
    return Padding(
      padding: const EdgeInsets.all(DEF_CELL_PADDING),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isMainField) {
              //todo
            } else {
              gameLogic.gameModule.attackOnCell(x, y);
            }
          });
        },
        child: Container(
          color: isMainField
              ? unit.unitScheme.primaryColor
              : (unit.isErrorHighlighted && unit.unitScheme.isNotEmpty
                  ? Colors.red
                  : Colors.green), //todo move colors in const
          width: cellSize,
          height: cellSize,
          child: Center(
            child: Text(
              "${isMainField ? unit.unitsAround.toString() : ((unit.isErrorHighlighted ? unit.unitsAround.toString() : ""))}",
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartWidget() {
    return GestureDetector(
      onTap: () {
        gameLogic.gameModule.startGame();
        setState(() {
          isStartVisible = false;
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey.withAlpha(150),
        child: Center(child: Text("Tap to Start")),
      ),
    );
  }

  Widget _buildSwitchWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSwitchVisible = false;
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey.withAlpha(150),
        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Result: ${gameLogic.gameModule.lastTurnResult.getFormattedString()}"),
            SizedBox(height: 24),
            Text("Tap to Switch"),
          ],
        )),
      ),
    );
  }

  Widget _buildEndWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isEndVisible = false;
          Navigator.of(context).pop(); //todo navigate to menu or game result
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey.withAlpha(150),
        child: Center(child: Text("Tap to End")),
      ),
    );
  }

  Widget _buildCheckWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey.withAlpha(150),
      child: Center(child: Text("Check in progress")),
    );
  }
}
