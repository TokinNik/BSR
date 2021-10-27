import 'package:flutter/material.dart';
import 'package:temp_app/core/game_logic/cell.dart';
import 'package:temp_app/core/game_logic/game_logic.dart';
import 'package:temp_app/ui/base/base_page.dart';

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

  List<List<Cell>> get getSourceField => isMainField
      ? gameLogic.gameModule.mainField
      : gameLogic.gameModule.enemyField;

  @override
  Widget build(BuildContext context) {
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
}
