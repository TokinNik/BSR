import '../cell.dart';

abstract class SetupModule {
  static const List<int> CELLS_AROUND_X = [-1, -1, -1, 0, 0, 0, 1, 1, 1];
  static const List<int> CELLS_AROUND_Y = [-1, 0, 1, -1, 0, 1, -1, 0, 1];
  static const int DEF_FIELD_SIZE = 5;
  final int maxX;
  final int maxY;

  const SetupModule({
    this.maxX = DEF_FIELD_SIZE,
    this.maxY = DEF_FIELD_SIZE,
  });

  initField() {}

  bool setData(
    int x,
    int y,
    Cell value,
  );

  removeData(Cell value);

  changeAnchorInCellById(int id, int newAnchor);

  Cell getCellAtCoord(int x, int y);

  bool checkPosition(int x, int y, Cell cell);

}
