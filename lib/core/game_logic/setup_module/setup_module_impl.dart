import 'package:flutter/cupertino.dart';
import 'package:temp_app/core/game_logic/setup_module/setup_module.dart';
import 'package:temp_app/utils/extensions.dart';
import 'package:temp_app/utils/logger.dart';

import '../cell.dart';

class SetupModuleImpl extends SetupModule {
  SetupModuleImpl({
    maxX,
    maxY,
  }) : super(
          maxX: maxX,
          maxY: maxY,
        );

  var _counter = 0;
  List<List<Cell>> total = [];

  @override
  initField() {
    for (var i = 0; i < maxX; i++) {
      List<Cell> row = [];
      for (var j = 0; j < maxY; j++) {
        row.add(new Cell(x: i, y: j));
      }
      total.add(row);
    }
  }

  @override
  bool setData(
    int x,
    int y,
    Cell value,
  ) {
    logD("SET_DATA $x $y $value ${total[2][4]}");
    if (value.direction == null || value.direction == Axis.vertical) {
      var anchor = 0;
      if (_checkVertical(x, y, value, value.anchor)) {
        _counter++;
        value.direction = Axis.vertical;
        _setDataVertical(x, y, value, value.anchor);
        return true;
      }
      while (anchor <= maxX) {
        if (_checkVertical(x, y, value, anchor)) {
          _counter++;
          value.direction = Axis.vertical;
          value.anchor = anchor;
          _setDataVertical(x, y, value, anchor);
          return true;
        } else {
          anchor++;
        }
      }
    }
    if (value.direction == null || value.direction == Axis.horizontal) {
      var anchor = 0;
      if (_checkHorizontal(x, y, value, value.anchor)) {
        _counter++;
        value.direction = Axis.horizontal;
        _setDataHorizontal(x, y, value, value.anchor);
        return true;
      }
      while (anchor <= maxY) {
        if (_checkHorizontal(x, y, value, anchor)) {
          _counter++;
          value.direction = Axis.horizontal;
          value.anchor = anchor;
          _setDataHorizontal(x, y, value, anchor);
          return true;
        } else {
          anchor++;
        }
      }
    }
    return false;
  }

  @override
  removeData(Cell value) {
    logD("REMOVE_DATA $value ${total[2][4]}");
    if (value.x >= 0 && value.y >= 0) {
      total.forEach((row) {
        row.forEach((cell) {
          if (cell.id == value.id) {
            total[cell.x][cell.y] = Cell(
              unitsAround: cell.unitsAround,
              x: cell.x,
              y: cell.y,
            );
            _removeDataAround(cell.x, cell.y);
          }
        });
      });
    }
    logD("REMOVE_DATA $value ${total[2][4]}");
  }

  @override
  changeAnchorInCellById(int id, int newAnchor) {
    total.forEach((row) {
      row.forEach((cell) {
        if (cell.id == id) {
          total[cell.x][cell.y].anchor = newAnchor;
        }
      });
    });
  }

  @override
  Cell getCellAtCoord(int x, int y) {
    return total[x][y];
  }

  @override
  bool checkPosition(int x, int y, Cell cell) {
    logD("!@# V ${cell.direction == null || cell.direction == Axis.vertical}");
    if (cell.direction == null || cell.direction == Axis.vertical) {
      var anchor = 0;
      if (_checkVertical(x, y, cell, cell.anchor)) {
        return true;
      }
      logD("!@# V1");
      while (anchor <= maxX) {
        if (_checkVertical(x, y, cell, anchor)) {
          return true;
        } else {
          anchor++;
        }
      }
    }
    logD("!@# V2");
    logD(
        "!@# H ${cell.direction == null || cell.direction == Axis.horizontal}");
    if (cell.direction == null || cell.direction == Axis.horizontal) {
      var anchor = 0;
      if (_checkHorizontal(x, y, cell, cell.anchor)) {
        return true;
      }
      logD("!@# H1");
      while (anchor <= maxY) {
        if (_checkHorizontal(x, y, cell, anchor)) {
          return true;
        } else {
          anchor++;
        }
      }
    }
    logD("!@# H2");
    return false;
  }

  bool _checkVertical(
    int x,
    int y,
    Cell cell,
    int anchor,
  ) {
    return _checkAllEmptyLeft(x, y, anchor + 1, cell) &&
        _checkAllEmptyRight(x, y, cell.cellType.getSize() - anchor, cell);
  }

  bool _checkHorizontal(int x, int y, Cell cell, int anchor) {
    return _checkAllEmptyTop(x, y, anchor + 1, cell) &&
        _checkAllEmptyBottom(x, y, cell.cellType.getSize() - anchor, cell);
  }

  _setDataVertical(int x, int y, Cell value, int anchor) {
    logD("SET_DATA_V $x $y $value");
    _setDataRight(x, y - anchor, value);
  }

  _setDataHorizontal(int x, int y, Cell value, int anchor) {
    logD("SET_DATA_H $x $y $value");
    _setDataBottom(x - anchor, y, value);
  }

  _setDataAround(int x, int y) {
    SetupModule.CELLS_AROUND_X.forEachIndexed((px, i) {
      var posX = x + px;
      var posY = y + SetupModule.CELLS_AROUND_Y[i];
      var isPositionInBounds =
          posX < maxX && posY < maxY && posX >= 0 && posY >= 0;
      if (isPositionInBounds) {
        total[posX][posY].unitsAround++;
      }
    });
  }

  _removeDataAround(int x, int y) {
    SetupModule.CELLS_AROUND_X.forEachIndexed((px, i) {
      var posX = x + px;
      var posY = y + SetupModule.CELLS_AROUND_Y[i];
      var isPositionInBounds =
          posX < maxX && posY < maxY && posX >= 0 && posY >= 0;
      if (isPositionInBounds) {
        if (total[posX][posY].unitsAround > 0) {
          total[posX][posY].unitsAround--;
        }
      }
    });
  }

  _setDataRight(int x, int y, Cell value) {
    logD("SET_DATA_V_R $x $y $value ${total[2][4]}");
    for (var i = 0; i < value.cellType.getSize(); i++) {
      var posY = y + i;
      if (posY < maxY) {
        total[x][posY] = value.copyWith(
          x: x,
          y: posY,
          id: _counter,
          subId: i,
          unitsAround: total[x][posY].unitsAround,
        );
        _setDataAround(x, posY);
      }
    }
  }

  _setDataLeft(int x, int y, Cell value) {
    for (var i = 0; i < value.cellType.getSize(); i++) {
      var posY = y - i;
      if (posY >= 0) {
        total[x][posY] = value.copyWith(
          x: x,
          y: posY,
          id: _counter,
          subId: i,
          unitsAround: total[x][posY].unitsAround,
        );
        _setDataAround(x, posY);
      }
    }
  }

  _setDataTop(int x, int y, Cell value) {
    for (var i = 0; i < value.cellType.getSize(); i++) {
      var posX = x - i;
      if (posX >= 0) {
        total[posX][y] = value.copyWith(
          x: posX,
          y: y,
          id: _counter,
          subId: i,
          unitsAround: total[posX][y].unitsAround,
        );
        _setDataAround(posX, y);
      }
    }
  }

  _setDataBottom(int x, int y, Cell value) {
    for (var i = 0; i < value.cellType.getSize(); i++) {
      var posX = x + i;
      if (posX < maxX) {
        total[posX][y] = value.copyWith(
          x: posX,
          y: y,
          id: _counter,
          subId: i,
          unitsAround: total[posX][y].unitsAround,
        );
        _setDataAround(posX, y);
      }
    }
  }

  bool _checkAllEmptyAround(int x, int y, int id, Cell cell) {
    if (cell.cellType == CellType.FILL_M) {
      return true;
    }
    var result = true;
    logD("CHECK_ID ${total.map((e) => e.map((e) => "${e.x}:${e.y} = ${e.id}").toList()).toList()}");
    SetupModule.CELLS_AROUND_X.forEachIndexed((px, i) {
      var posX = x + px;
      var posY = y + SetupModule.CELLS_AROUND_Y[i];
      var isPositionInBounds =
          posX < maxX && posY < maxY && posX >= 0 && posY >= 0;
      if (isPositionInBounds) {
        logD("CHECK_ID ${cell.id} == ${total[posX][posY].id}");
        var isClearCell = total[posX][posY].cellType == CellType.EMPTY ||
            total[posX][posY].cellType == CellType.FILL_M ||
            total[posX][posY].id == cell.id;
        if (!isClearCell) {
          result = false;
        }
      }
    });
    return result;
  }

  bool _checkAllEmptyRight(int x, int y, int length, Cell cell) {
    if (y + length > maxY) {
      return false;
    }
    for (var i = y; i < y + length; i++) {
      if (total[x][i].cellType != CellType.EMPTY ||
          !_checkAllEmptyAround(
            x,
            i,
            total[x][i].id,
            cell,
          )) {
        return false;
      }
    }
    return true;
  }

  bool _checkAllEmptyLeft(int x, int y, int length, Cell cell) {
    if (y - length + 1 < 0) {
      return false;
    }
    for (var i = y; i > y - length; i--) {
      if (total[x][i].cellType != CellType.EMPTY ||
          !_checkAllEmptyAround(
            x,
            i,
            total[x][i].id,
            cell,
          )) {
        return false;
      }
    }
    return true;
  }

  bool _checkAllEmptyTop(int x, int y, int length, Cell cell) {
    if (x - length + 1 < 0) {
      return false;
    }
    for (var i = x; i > x - length; i--) {
      if (total[x][i].cellType != CellType.EMPTY ||
          !_checkAllEmptyAround(
            i,
            y,
            total[i][y].id,
            cell,
          )) {
        return false;
      }
    }
    return true;
  }

  bool _checkAllEmptyBottom(int x, int y, int lenght, Cell cell) {
    if (x + lenght > maxY) {
      return false;
    }
    for (var i = x; i < x + lenght; i++) {
      if (total[x][i].cellType != CellType.EMPTY ||
          !_checkAllEmptyAround(
            i,
            y,
            total[i][y].id,
            cell,
          )) {
        return false;
      }
    }
    return true;
  }
}
