import 'package:flutter/cupertino.dart';

import '../cell.dart';
import '../game_settings.dart';

abstract class SetupModule {
  static const List<int> CELLS_AROUND_X = [-1, -1, -1, 0, 0, 0, 1, 1, 1];
  static const List<int> CELLS_AROUND_Y = [-1, 0, 1, -1, 0, 1, -1, 0, 1];
  static const int DEF_FIELD_SIZE = 5;
  final int maxX;
  final int maxY;
  final UnitSettings unitSettings;

  const SetupModule({
    this.maxX = DEF_FIELD_SIZE,
    this.maxY = DEF_FIELD_SIZE,
    @required this.unitSettings,
  });

  List<List<Cell>> get field;

  bool get isSetupMayDone;

  initField();

  clean();

  bool setData(
    int x,
    int y,
    Cell value,
  );

  bool removeData(Cell value);

  changeAnchorInCellById(int id, int newAnchor);

  Cell getCellAtCoord(int x, int y);

  bool checkPosition(int x, int y, Cell cell);

}
