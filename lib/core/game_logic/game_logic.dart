import 'package:bsr/core/game_logic/setup_module/setup_module.dart';
import 'package:bsr/core/game_logic/setup_module/setup_module_impl.dart';

import 'cell.dart';
import 'game_module.dart';
import 'game_settings.dart';

class GameLogic {
  final SetupModule setupModule;
  final GameModule gameModule;
  final GameSettings gameSettings;

  GameLogic({
    this.setupModule,
    this.gameModule,
    this.gameSettings,
  });

  endSetup(int id) {
    List<List<Cell>> copyField = [];
    copyField.addAll(setupModule.field);
    gameModule.players.add(Player(
      mainField: copyField,
      playerId: id,
    ));
  }

  endSetupTest() {
    //todo
    var tempSetup = SetupModuleImpl(
      maxX: 11,
      maxY: 11,
      unitSettings: gameSettings.unitSettings,
    );

    tempSetup.initField();
    tempSetup.setData(
        0, 0, Cell(unitScheme: gameSettings.unitSettings.unitsScheme[0]));
    tempSetup.setData(
        2, 2, Cell(unitScheme: gameSettings.unitSettings.unitsScheme[0]));
    tempSetup.setData(
        0, 2, Cell(unitScheme: gameSettings.unitSettings.unitsScheme[0]));
    tempSetup.setData(
        4, 2, Cell(unitScheme: gameSettings.unitSettings.unitsScheme[0]));
    tempSetup.setData(
        6, 2, Cell(unitScheme: gameSettings.unitSettings.unitsScheme[4]));

    gameModule.players.add(Player(
      mainField: tempSetup.field,
      playerId: 1,
    ));
  }
}
