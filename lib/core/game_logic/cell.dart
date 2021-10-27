import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

enum CellType {
  EMPTY,
  FILL_1,
  FILL_2,
  FILL_3,
  FILL_4,
  FILL_M,
}

extension CellTypeExtension on CellType {
  int getSize() {
    var size = 0;
    switch (this) {
      case CellType.EMPTY:
        size = 0;
        break;
      case CellType.FILL_1:
        size = 1;
        break;
      case CellType.FILL_2:
        size = 2;
        break;
      case CellType.FILL_3:
        size = 3;
        break;
      case CellType.FILL_4:
        size = 4;
        break;
      case CellType.FILL_M:
        size = 1;
        break;
    }
    return size;
  }

  Color getColor() {
    var color = Colors.amber;
    switch (this) {
      case CellType.EMPTY:
        color = Colors.green;
        break;
      case CellType.FILL_1:
        color = Colors.blueGrey;
        break;
      case CellType.FILL_2:
        color = Colors.blue;
        break;
      case CellType.FILL_3:
        color = Colors.deepPurple;
        break;
      case CellType.FILL_4:
        color = Colors.orange;
        break;
      case CellType.FILL_M:
        color = Colors.pink;
        break;
    }
    return color;
  }
}

class Cell {
  int x;
  int y;
  int unitsAround;
  int id;
  Axis direction;
  int anchor;
  int subId;
  CellType cellType;
  bool isErrorHighlighted = false;

  Cell({
    this.x = -1,
    this.y = -1,
    this.unitsAround = 0,
    this.id = -1,
    this.direction,
    this.anchor = 0,
    this.subId = 0,
    this.cellType = CellType.EMPTY,
  });

  switchDirection() {
    if (direction != null) {
      direction = direction == Axis.vertical ? Axis.horizontal : Axis.vertical;
    }
  }

  Cell copyWith({
    int x,
    int y,
    int unitsAround,
    int id,
    int direction,
    int anchor,
    int subId,
    int cellType,
  }) {
    return Cell(
      x: x ?? this.x,
      y: y ?? this.y,
      unitsAround: unitsAround ?? this.unitsAround,
      id: id ?? this.id,
      direction: direction ?? this.direction,
      anchor: anchor ?? this.anchor,
      subId: subId ?? this.subId,
      cellType: cellType ?? this.cellType,
    );
  }

  @override
  String toString() {
    return 'Cell{cellType: $cellType, x: $x, y: $y, data: $unitsAround, id: $id, direction: $direction, anchor: $anchor, subId: $subId}';
  }
}
