import 'package:flutter/cupertino.dart';
import 'package:bsr/core/game_logic/setup_module/setup_module.dart';
import 'package:bsr/utils/extensions.dart';
import 'package:bsr/utils/logger.dart';

import '../cell.dart';
import '../game_settings.dart';

class SetupModuleImpl extends SetupModule {
  SetupModuleImpl({
    int maxX = SetupModule.DEF_FIELD_SIZE,
    int maxY = SetupModule.DEF_FIELD_SIZE,
    @required UnitSettings unitSettings,
  }) : super(
          maxX: maxX,
          maxY: maxY,
          unitSettings: unitSettings,
        );

  var _counter = 0;
  List<List<Cell>> _field = [];

  List<List<Cell>> get field => _field;

  bool get isSetupMayDone =>
      unitSettings.unitsScheme.firstWhereOrNull((e) => !e.isMaxCountOnField) ==
      null;

  @override
  initField() {
    for (var i = 0; i < maxX; i++) {
      List<Cell> row = [];
      for (var j = 0; j < maxY; j++) {
        row.add(new Cell(
          x: i,
          y: j,
          unitScheme: UnitScheme.emptyScheme(),
        ));
      }
      _field.add(row);
    }
  }

  @override
  clean() {
    _field.clear();
    _counter = 0;
    unitSettings.unitsScheme.forEach((element) {
      element.countOnField = 0;
    });
    initField();
  }

  @override
  bool setData(
    int x,
    int y,
    Cell value,
  ) {
    logD("SET_DATA $x $y $_counter $value");
    if (value.direction == null || value.direction == Axis.horizontal) {
      var anchor = 0;
      if (_checkHorizontal(x, y, value, value.anchor)) {
        _counter++;
        value.direction = Axis.horizontal;
        _setDataHorizontal(x, y, value, value.anchor);
        unitSettings
            .unitByLocaleIdOrNull(value.unitScheme.localId)
            ?.countOnField++;
        return true;
      }
      while (anchor <= value.unitScheme.size) {
        if (_checkHorizontal(x, y, value, anchor)) {
          _counter++;
          value.direction = Axis.horizontal;
          value.anchor = anchor;
          _setDataHorizontal(x, y, value, anchor);
          unitSettings
              .unitByLocaleIdOrNull(value.unitScheme.localId)
              ?.countOnField++;
          return true;
        } else {
          anchor++;
        }
      }
    }
    if (value.direction == null || value.direction == Axis.vertical) {
      var anchor = 0;
      if (_checkVertical(x, y, value, value.anchor)) {
        _counter++;
        value.direction = Axis.vertical;
        _setDataVertical(x, y, value, value.anchor);
        unitSettings
            .unitByLocaleIdOrNull(value.unitScheme.localId)
            ?.countOnField++;
        return true;
      }
      while (anchor <= value.unitScheme.size) {
        if (_checkVertical(x, y, value, anchor)) {
          _counter++;
          value.direction = Axis.vertical;
          value.anchor = anchor;
          _setDataVertical(x, y, value, anchor);
          unitSettings
              .unitByLocaleIdOrNull(value.unitScheme.localId)
              ?.countOnField++;
          return true;
        } else {
          anchor++;
        }
      }
    }
    return false;
  }

  @override
  bool removeData(Cell value) {
    logD("REMOVE_DATA $_counter $value ");
    var result = false;
    if (value.x >= 0 && value.y >= 0) {
      _field.forEach((row) {
        row.forEach((cell) {
          if (cell.id == value.id) {
            _field[cell.x][cell.y] = Cell(
              unitsAround: cell.unitsAround,
              x: cell.x,
              y: cell.y,
              unitScheme: UnitScheme.emptyScheme(),
            );
            _removeDataAround(cell.x, cell.y);
            result = true;
          }
        });
      });
    }
    logD("REMOVE_DATA $value ${_field[2][4]}");
    if (result) {
      unitSettings
          .unitByLocaleIdOrNull(value.unitScheme.localId)
          ?.countOnField--;
    }
    return result;
  }

  @override
  changeAnchorInCellById(int id, int newAnchor) {
    _field.forEach((row) {
      row.forEach((cell) {
        if (cell.id == id) {
          _field[cell.x][cell.y].anchor = newAnchor;
        }
      });
    });
  }

  @override
  Cell getCellAtCoord(int x, int y) {
    return _field[x][y];
  }

  @override
  bool checkPosition(int x, int y, Cell cell) {
    logD(
        "!@# H ${cell.direction == null || cell.direction == Axis.horizontal}");
    var saveDirection = cell.direction;
    cell.direction = Axis.horizontal;
    var anchor = 0;
    if (_checkHorizontal(x, y, cell, cell.anchor)) {
      cell.direction = saveDirection;
      return true;
    }
    logD("!@# H1");
    while (anchor <= cell.unitScheme.size) {
      if (_checkHorizontal(x, y, cell, anchor)) {
        cell.direction = saveDirection;
        return true;
      } else {
        anchor++;
      }
    }
    logD("!@# H2");
    logD("!@# V ${cell.direction == null || cell.direction == Axis.vertical}");
    cell.switchDirection();
    anchor = 0;
    if (_checkVertical(x, y, cell, cell.anchor)) {
      cell.direction = saveDirection;
      return true;
    }
    logD("!@# V1");
    while (anchor <= cell.unitScheme.size) {
      if (_checkVertical(x, y, cell, anchor)) {
        cell.direction = saveDirection;
        return true;
      } else {
        anchor++;
      }
    }
    logD("!@# V2");
    cell.direction = saveDirection;
    return false;
  }

  bool _checkVertical(
    int x,
    int y,
    Cell cell,
    int anchor,
  ) {
    var top = _checkAllEmptyTop(x, y, anchor + 1, cell);
    var bottom =
        _checkAllEmptyBottom(x, y, cell.unitScheme.size - anchor, cell);
    logD("CHECK_VERT $top $bottom");
    return top && bottom;
  }

  bool _checkHorizontal(int x, int y, Cell cell, int anchor) {
    var left = _checkAllEmptyLeft(x, y, anchor + 1, cell);
    var right = _checkAllEmptyRight(x, y, cell.unitScheme.size - anchor, cell);
    logD("CHECK_HORI $left $right");
    return left && right;
  }

  _setDataVertical(int x, int y, Cell value, int anchor) {
    logD("SET_DATA_V $x $y $value");
    _setDataBottom(x - anchor, y, value);
  }

  _setDataHorizontal(int x, int y, Cell value, int anchor) {
    logD("SET_DATA_H $x $y $value");
    _setDataRight(x, y - anchor, value);
  }

  _setDataAround(int x, int y) {
    SetupModule.CELLS_AROUND_X.forEachIndexed((px, i) {
      var posX = x + px;
      var posY = y + SetupModule.CELLS_AROUND_Y[i];
      var isPositionInBounds =
          posX < maxX && posY < maxY && posX >= 0 && posY >= 0;
      if (isPositionInBounds) {
        _field[posX][posY].unitsAround++;
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
        if (_field[posX][posY].unitsAround > 0) {
          _field[posX][posY].unitsAround--;
        }
      }
    });
  }

  _setDataRight(int x, int y, Cell value) {
    logD("SET_DATA_H_R $x $y $_counter");
    for (var i = 0; i < value.unitScheme.size; i++) {
      var posY = y + i;
      if (posY < maxY) {
        _field[x][posY] = value.copyWith(
          x: x,
          y: posY,
          id: _counter,
          subId: i,
          unitsAround: _field[x][posY].unitsAround,
        );
        _setDataAround(x, posY);
      }
    }
  }

  _setDataLeft(int x, int y, Cell value) {
    for (var i = 0; i < value.unitScheme.size; i++) {
      var posY = y - i;
      if (posY >= 0) {
        _field[x][posY] = value.copyWith(
          x: x,
          y: posY,
          id: _counter,
          subId: i,
          unitsAround: _field[x][posY].unitsAround,
        );
        _setDataAround(x, posY);
      }
    }
  }

  _setDataTop(int x, int y, Cell value) {
    for (var i = 0; i < value.unitScheme.size; i++) {
      var posX = x - i;
      if (posX >= 0) {
        _field[posX][y] = value.copyWith(
          x: posX,
          y: y,
          id: _counter,
          subId: i,
          unitsAround: _field[posX][y].unitsAround,
        );
        _setDataAround(posX, y);
      }
    }
  }

  _setDataBottom(int x, int y, Cell value) {
    for (var i = 0; i < value.unitScheme.size; i++) {
      var posX = x + i;
      if (posX < maxX) {
        _field[posX][y] = value.copyWith(
          x: posX,
          y: y,
          id: _counter,
          subId: i,
          unitsAround: _field[posX][y].unitsAround,
        );
        _setDataAround(posX, y);
      }
    }
  }

  bool _checkAllEmptyAround(int x, int y, int id, Cell cell) {
    if (cell.unitScheme.isCrossing && cell.unitScheme.isNotEmpty) {
      return true;
    }
    logD(
        "CHECK_ID ${_field.map((e) => e.map((e) => "${e.x}:${e.y} = ${e.id}").toList()).toList()}");
    for (var i = 0; i < SetupModule.CELLS_AROUND_X.length; i++) {
      var px = SetupModule.CELLS_AROUND_X[i];
      var posX = x + px;
      var posY = y + SetupModule.CELLS_AROUND_Y[i];
      var isPositionInBounds =
          posX < maxX && posY < maxY && posX >= 0 && posY >= 0;
      if (isPositionInBounds) {
        logD("CHECK_ID ${cell.id} == ${_field[posX][posY].id}");
        var isClearCell = _field[posX][posY].unitScheme.isCrossing ||
            _field[posX][posY].id == cell.id;
        if (!isClearCell) {
          return false;
        }
      }
    }
    logD("CHECK_ID_R true");
    return true;
  }

  bool _checkAllEmptyRight(int x, int y, int length, Cell cell) {
    logD("CHECK_R $x $y $length ${y + length} > $maxY");
    if (y + length > maxY) {
      logD("CHECK_R_1");
      return false;
    }
    for (var i = y; i < y + length; i++) {
      if (_field[x][i].canSkipCheck ||
          !_checkAllEmptyAround(
            x,
            i,
            _field[x][i].id,
            cell,
          )) {
        logD("CHECK_R_2");
        return false;
      }
    }
    logD("CHECK_R_3");
    return true;
  }

  bool _checkAllEmptyLeft(int x, int y, int length, Cell cell) {
    logD("CHECK_L $x $y $length ${y - length + 1}");
    if (y - length + 1 < 0) {
      return false;
    }
    for (var i = y; i > y - length; i--) {
      if (_field[x][i].canSkipCheck ||
          !_checkAllEmptyAround(
            x,
            i,
            _field[x][i].id,
            cell,
          )) {
        return false;
      }
    }
    return true;
  }

  bool _checkAllEmptyTop(int x, int y, int length, Cell cell) {
    logD("CHECK_T $x $y $length ${x - length + 1}");
    if (x - length + 1 < 0) {
      logD("CHECK_T_1");
      return false;
    }
    for (var i = x; i > x - length; i--) {
      if (_field[i][y].canSkipCheck ||
          !_checkAllEmptyAround(
            i,
            y,
            _field[i][y].id,
            cell,
          )) {
        logD("CHECK_T_2");
        return false;
      }
    }
    logD("CHECK_T_3");
    return true;
  }

  bool _checkAllEmptyBottom(int x, int y, int lenght, Cell cell) {
    if (x + lenght > maxY) {
      return false;
    }
    for (var i = x; i < x + lenght; i++) {
      if (_field[i][y].canSkipCheck ||
          !_checkAllEmptyAround(
            i,
            y,
            _field[i][y].id,
            cell,
          )) {
        return false;
      }
    }
    return true;
  }
}
