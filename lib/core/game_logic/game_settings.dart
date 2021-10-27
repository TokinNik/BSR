import 'dart:ui';

class GameSettings {
  final UnitSettings unitSettings;
  final bool isTimerEnabled;
  final Duration timerDuration;

  GameSettings({
    this.isTimerEnabled,
    this.timerDuration,
    this.unitSettings,
  });
}

class UnitSettings {
  final String name;
  final List<UnitPreset> unitsPresets;

  UnitSettings({
    this.name,
    this.unitsPresets,
  });
}

class UnitPreset {
  final int presetId;
  final int size;
  final int maxCount;
  final bool isCrossing;
  final Color primaryColor;
  final Color secondaryColor;

  UnitPreset({
    this.presetId,
    this.size,
    this.maxCount,
    this.isCrossing,
    this.primaryColor,
    this.secondaryColor,
  });
}
