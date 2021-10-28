import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:bsr/core/game_logic/game_settings.dart';

class Cell {
  int x;
  int y;
  int unitsAround;
  int id;
  Axis direction;
  int anchor;
  int subId;
  UnitScheme unitScheme;
  bool isErrorHighlighted = false;

  Cell({
    this.x = -1,
    this.y = -1,
    this.unitsAround = 0,
    this.id = -1,
    this.direction,
    this.anchor = 0,
    this.subId = 0,
    @required this.unitScheme,
  });

  bool get canSkipCheck => unitScheme.isCrossing && unitScheme.isNotEmpty;

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
      unitScheme: cellType ?? this.unitScheme,
    );
  }

  @override
  String toString() {
    return 'Cell{x: $x, y: $y, unitsAround: $unitsAround, id: $id, direction: $direction, anchor: $anchor, subId: $subId, unitScheme: $unitScheme, isErrorHighlighted: $isErrorHighlighted}';
  }
}
