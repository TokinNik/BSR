import 'dart:ui';

import 'package:flutter/material.dart';

class GameSettings {
  final UnitSettings unitSettings;
  final bool isTimerEnabled;
  final Duration timerDuration;

  GameSettings({
    @required this.unitSettings,
    this.isTimerEnabled = false,
    this.timerDuration,
  });

  @override
  String toString() {
    return 'GameSettings{unitSettings: $unitSettings, isTimerEnabled: $isTimerEnabled, timerDuration: $timerDuration}';
  }
}

class UnitSettings {
  final String presetName;
  final List<UnitScheme> unitsScheme;

  const UnitSettings({
    this.presetName,
    this.unitsScheme,
  });

  UnitScheme unitByLocaleIdOrNull(int localId) => localId >= 0 ? unitsScheme[localId] : null;

  factory UnitSettings.defaultUnitSettings() => UnitSettings(
        presetName: "DEFAULT",
        unitsScheme: [
          UnitScheme(
            localId: 0,
            size: 1,
            maxCount: 4,
            isCrossing: false,
            primaryColor: Colors.blueGrey,
          ),
          UnitScheme(
            localId: 1,
            size: 2,
            maxCount: 3,
            isCrossing: false,
            primaryColor: Colors.blue,
          ),
          UnitScheme(
            localId: 2,
            size: 3,
            maxCount: 2,
            isCrossing: false,
            primaryColor: Colors.purple,
          ),
          UnitScheme(
            localId: 3,
            size: 4,
            maxCount: 1,
            isCrossing: false,
            primaryColor: Colors.orange,
          ),
          UnitScheme(
            localId: 4,
            size: 1,
            maxCount: 10,
            isCrossing: true,
            primaryColor: Colors.pink,
          ),
        ],
      );

  @override
  String toString() {
    return 'UnitSettings{presetName: $presetName, unitsScheme: $unitsScheme}';
  }
}

class UnitScheme {
  final int localId;
  final int size;
  final int maxCount;
  final bool isCrossing;
  final Color primaryColor;
  final Color secondaryColor;
  int countOnField = 0;

  bool get isMaxCountOnField => countOnField >= maxCount;

  bool get isNotEmpty => size > 0;

  UnitScheme({
    @required this.localId,
    @required this.size,
    this.maxCount = 1,
    this.isCrossing = false,
    this.primaryColor = Colors.green,
    this.secondaryColor,
  }) : assert(size >= 0);

  factory UnitScheme.emptyScheme() => UnitScheme(localId: -1, size: 0, isCrossing: true);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitScheme &&
          runtimeType == other.runtimeType &&
          size == other.size &&
          maxCount == other.maxCount &&
          isCrossing == other.isCrossing &&
          primaryColor == other.primaryColor &&
          secondaryColor == other.secondaryColor;

  @override
  int get hashCode =>
      size.hashCode ^
      maxCount.hashCode ^
      isCrossing.hashCode ^
      primaryColor.hashCode ^
      secondaryColor.hashCode;

  @override
  String toString() {
    return 'UnitScheme{size: $size, maxCount: $maxCount, isCrossing: $isCrossing, primaryColor: $primaryColor, secondaryColor: $secondaryColor}';
  }
}
