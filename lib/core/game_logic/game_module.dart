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
                  (e) => e.playerId != currentPlayerId && !e.isLoose) !=
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
    var newPlayerId =
        _currentPlayerId >= players.length - 1 ? 0 : _currentPlayerId + 1;
    if (players[newPlayerId].isLoose) {
      switchTurn(); //todo test loop problems
    } else {
      _currentPlayerId = newPlayerId;
    }
  }

  _switchEnemy() {
    var newEnemyId =
        _currentEnemyId >= players.length - 1 ? 0 : _currentEnemyId + 1;
    if (players[newEnemyId].isLoose) {
      switchTurn(); //todo test loop problems
    } else {
      _currentEnemyId = newEnemyId;
    }
  }
}

enum GameState {
  START,
  TURN,
  CHECK,
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
    var result = true;
    mainField.forEach((row) {
      row.forEach((cell) {
        if (cell.unitScheme.isNotEmpty &&
            !cell.unitScheme.isCrossing &&
            !cell.isErrorHighlighted) {
          return false;
        }
      });
    });
    return result;
  }
}

class AttackResult {
  final ResultType resultType;
  final int resultValue;

  AttackResult({
    this.resultType,
    this.resultValue,
  });

  @override
  String toString() {
    return 'AttackResult{resultType: $resultType, resultValue: $resultValue}';
  }
}

enum ResultType {
  EMPTY,
  UNIT,
}
