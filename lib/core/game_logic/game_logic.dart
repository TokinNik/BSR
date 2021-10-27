import 'package:temp_app/core/game_logic/setup_module/setup_module.dart';
import 'package:temp_app/core/game_logic/setup_module/setup_module_impl.dart';

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

  endSetupMain(){
    gameModule.mainField = setupModule.field;
  }

  endSetupEnemy(){
    //todo
    var tempSetup = SetupModuleImpl(maxX: 11, maxY: 11, unitSettings: gameSettings.unitSettings,);


    tempSetup.initField();
    tempSetup.setData(0, 0, Cell(unitScheme: gameSettings.unitSettings.unitsScheme[0]));
    tempSetup.setData(2, 2, Cell(unitScheme: gameSettings.unitSettings.unitsScheme[0]));
    tempSetup.setData(0, 2, Cell(unitScheme: gameSettings.unitSettings.unitsScheme[0]));
    tempSetup.setData(4, 2, Cell(unitScheme: gameSettings.unitSettings.unitsScheme[0]));

    gameModule.enemyField = tempSetup.field;
  }
}