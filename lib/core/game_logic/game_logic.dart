import 'package:temp_app/core/game_logic/setup_module/setup_module.dart';

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
}
