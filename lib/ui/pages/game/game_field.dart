import 'package:flutter/material.dart';
import 'package:bsr/core/game_logic/cell.dart';
import 'package:bsr/core/game_logic/game_logic.dart';
import 'package:bsr/core/game_logic/game_module.dart';
import 'package:bsr/ui/base/base_page.dart';
import 'package:bsr/utils/logger.dart';

class GameField extends BasePage {
  GameField(GameLogic gameLogic, {Key key})
      : super(
          key: key,
          state: _GameFieldState(gameLogic),
        );
}

class _GameFieldState extends State<BaseStatefulWidget> {
  static const double DEF_CELL_SIZE = 30;
  static const double DEF_CELL_PADDING = 0;

  _GameFieldState(this.gameLogic);

  final GameLogic gameLogic;

  var cellSize = DEF_CELL_SIZE; //todo move to GameSettings?

  bool isMainOnFront = false;

  bool isStartVisible = true;
  bool isEndVisible = false;
  bool isSwitchVisible = false;

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
          SizedBox(height: 24),
          Text("Player ${gameLogic.gameModule.currentPlayerId + 1} turn"),
          SizedBox(height: 24),
          _buildCells(!isMainOnFront),
          SizedBox(height: 8),
          _buildCells(isMainOnFront),
          SizedBox(height: 24),
          TextButton(
            onPressed: () {
              setState(() {
                isMainOnFront = !isMainOnFront;
              });
            },
            child: Text("Switch field to ${isMainOnFront ? "Enemy" : "Main"}"),
          ),
        ],
      ),
    );
  }

  Widget _buildCells(bool isMainField) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < gameLogic.setupModule.maxX; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var j = 0; j < gameLogic.setupModule.maxY; j++)
                _buildCell(i, j, isMainField),
            ],
          )
      ],
    );
  }

  Widget _buildCell(int x, int y, bool isMainField) {
    var unit = isMainField
        ? gameLogic.gameModule.currentPlayer.mainField[x][y]
        : gameLogic.gameModule.currentEnemy.mainField[x][y];
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
          decoration: BoxDecoration(
            color: isMainField
                ? (unit.isErrorHighlighted
                    ? (unit.unitScheme.isNotEmpty
                        ? Colors.red
                        : unit.unitScheme.primaryColor)
                    : unit.unitScheme.primaryColor)
                : (unit.isErrorHighlighted && unit.unitScheme.isNotEmpty
                    ? Colors.red
                    : Colors.green),
            border: Border.all(color: Colors.black),
          ),
          //todo move colors in const
          width: isMainField
              ? (isMainOnFront ? cellSize : cellSize * 0.5)
              : (!isMainOnFront ? cellSize : cellSize * 0.5),
          //todo move scale factor in const
          height: isMainField
              ? (isMainOnFront ? cellSize : cellSize * 0.5)
              : (!isMainOnFront ? cellSize : cellSize * 0.5),
          child: Center(
            child: Text(
              "${isMainField ? (unit.isErrorHighlighted ? "*" : "") : ((unit.isErrorHighlighted ? (unit.unitScheme.isNotEmpty ? "*" : unit.unitsAround.toString()) : ""))}",
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
        color: Colors.grey,
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
        color: Colors.grey,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "Result: ${gameLogic.gameModule.lastTurnResult.getFormattedString()}"),
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
        color: Colors.grey,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Player ${gameLogic.gameModule.currentPlayerId + 1} Win!!!"),
            SizedBox(height: 24),
            Text("Tap to end game"),
          ],
        )),
      ),
    );
  }

  Widget _buildCheckWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey,
      child: Center(child: Text("Check in progress")),
    );
  }
}
