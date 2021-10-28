import 'package:flutter/cupertino.dart';
import 'package:temp_app/utils/extensions.dart';
import 'package:temp_app/utils/logger.dart';

import 'cell.dart';

class GameModule {
  List<Player> _players = [];

  List<Player> get players => _players;

  int _currentPlayerId = 0;

  int get currentPlayerId => _currentPlayerId;

  int _currentEnemyId = 1;

  int get currentEnemyId => _currentEnemyId;

  GameState _gameState = GameState.START;

  GameState get gameState => _gameState;

  Function(GameState) onGameStateChanged;

  AttackResult lastTurnResult;

  Player get currentPlayer => players[_currentPlayerId];

  Player get currentEnemy => players[_currentEnemyId];

  bool startGame() {
    if (players.length < 2) {
      return false;
    }
    currentPlayer.turnCount++;
    onGameStateChanged?.call(GameState.TURN);
    return true;
  }

  endGame() {
    //todo
  }

  AttackResult attackOnCell(
    int x,
    int y,
  ) {
    onGameStateChanged?.call(GameState.CHECK);
    var result = currentEnemy.attackOnCell(x, y);
    lastTurnResult = result;
    onGameStateChanged?.call(GameState.TURN_RESULT);
    logD("ATTACK_RESULT: $result");
    if (result.resultType == ResultType.EMPTY) {
      currentPlayer.turnCount--;
      if (currentPlayer.turnCount > 0) {
        _gameState = GameState.TURN;
        onGameStateChanged?.call(GameState.TURN);
      } else {
        onGameStateChanged?.call(GameState.SWITCH);
        switchTurn();
        currentPlayer.turnCount++;
        onGameStateChanged?.call(GameState.TURN);
      }
    } else if (result.resultType == ResultType.UNIT) {
      if (result.resultValue > 0) {
        if (currentEnemy.checkPlayerLoose()) {
          var hasAlivePlayers = players.firstWhereOrNull(
                  (e) {
                    logD("|${e.playerId}  ${e.isLoose}|");
                    return e.playerId != currentPlayerId && !e.isLoose;
                  }) !=
              null;
          if (hasAlivePlayers) {
            onGameStateChanged?.call(GameState.TURN);
          } else {
            endGame();
            onGameStateChanged?.call(GameState.END);
          }
        } else {
          onGameStateChanged?.call(GameState.TURN);
        }
        onGameStateChanged?.call(GameState.TURN);
      } else {
        currentPlayer.turnCount--;
        onGameStateChanged?.call(GameState.SWITCH);
        switchTurn();
        currentPlayer.turnCount += 2;
        onGameStateChanged?.call(GameState.TURN);
      }
    }
    return result;
  }

  switchTurn() {
    _switchPlayer();
    _switchEnemy();
  }

  _switchPlayer() {
    var maxLoops = players.length;
    var newPlayerId = _currentPlayerId;
    while(maxLoops > 0){
       newPlayerId =
       newPlayerId >= players.length - 1 ? 0 : newPlayerId + 1;
      logD("P: ${players[newPlayerId].isLoose} ${players[newPlayerId].playerId}");
      if (players[newPlayerId].isLoose) {
        maxLoops--;
      } else {
        maxLoops = 0;
        _currentPlayerId = newPlayerId;
      }
    }
  }

  _switchEnemy() {
    var maxLoops = players.length;
    var newEnemyId = _currentEnemyId;
    while(maxLoops > 0){
      newEnemyId =
      newEnemyId >= players.length - 1 ? 0 : newEnemyId + 1;
      logD("E: ${players[newEnemyId].isLoose} ${players[newEnemyId].playerId}");
      if (players[newEnemyId].isLoose) {
        maxLoops--;
      } else {
        maxLoops = 0;
        _currentEnemyId = newEnemyId;
      }
    }
  }
}

enum GameState {
  START,
  TURN,
  CHECK,
  TURN_RESULT,
  SWITCH,
  END,
}

class Player {
  final List<List<Cell>> mainField;
  final int playerId;
  int turnCount = 0;
  bool isLoose = false;

  Player({
    @required this.mainField,
    @required this.playerId,
  });

  AttackResult attackOnCell(
    int x,
    int y,
  ) {
    Cell unit = mainField[x][y];
    unit.isErrorHighlighted = true;

    return AttackResult(
      resultType:
          unit.unitScheme.isNotEmpty ? ResultType.UNIT : ResultType.EMPTY,
      resultValue: unit.unitScheme.isNotEmpty
          ? (unit.unitScheme.isCrossing ? -1 : 1)
          : unit.unitsAround,
    );
  }

  bool checkPlayerLoose() {
    for (var row in mainField) {
      logD("-----\n");
      for (var cell in row) {
        logD(
            "${cell.x} ${cell.y} ${cell.unitScheme.isNotEmpty && !cell.unitScheme.isCrossing && !cell.isErrorHighlighted}");
        if (cell.unitScheme.isNotEmpty &&
            !cell.unitScheme.isCrossing &&
            !cell.isErrorHighlighted) {
          return false;
        }
      }
    }
    isLoose = true;
    return true;
  }
}

class AttackResult {
  final ResultType resultType;
  final int resultValue;

  AttackResult({
    this.resultType,
    this.resultValue,
  });

  String getFormattedString(){
    return "${resultType == ResultType.EMPTY ? "Miss ($resultValue)" : (resultValue > 0 ? "Hit" : "Mine")}";
  }

  @override
  String toString() {
    return 'AttackResult{resultType: $resultType, resultValue: $resultValue}';
  }
}

enum ResultType {
  EMPTY,
  UNIT,
}
