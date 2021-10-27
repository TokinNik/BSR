import 'cell.dart';

class GameModule {
  List<List<Cell>> mainField;
  List<List<Cell>> enemyField;

  GameModule({
    this.mainField,
    this.enemyField,
  });

  bool attackOnCell(
    int x,
    int y, {
    bool isMain = true,
  }) {
    if (isMain) {
      var unit = enemyField[x][y];
      //if(unit.unitScheme.isNotEmpty && !unit.isErrorHighlighted){
        unit.isErrorHighlighted = true;
      //} else {
      //  return false;
      //}
    } else {
      //todo
    }
    return true;
  }
}
