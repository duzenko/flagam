import 'dart:ui';

import 'package:flagam/generated/l10n.dart';

class BattleCard {}

abstract class UnitCard {
  late BattlePlayer _player;

  String get image;

  String get name;

  BattlePlayer get player => _player;

  int get attack;

  int get defence;
}

class Peasant extends UnitCard {
  @override
  get image => 'assets/units/фермер.png';

  @override
  int get attack => 1;

  @override
  int get defence => 1;

  @override
  String get name => S.current.peasant;
}

class Skeleton extends UnitCard {
  @override
  get image => 'assets/units/скелет.png';

  @override
  int get attack => 2;

  @override
  int get defence => 1;

  @override
  String get name => S.current.skeleton;
}

class BattlePlayer {
  final List<UnitCard> unitsInHand;
  final activeUnits = <UnitCard>[];
  final String image;
  final String name;
  int hp = 10;
  late Battle _battle;

  BattlePlayer(this.unitsInHand, this.image, this.name) {
    for (final unit in unitsInHand) {
      unit._player = this;
    }
  }

  Battle get battle => _battle;
}

class BattleActiveStage {
  UnitCard? attackingUnit;
  UnitCard? lastAttacker;
}

class Battle {
  final player = BattlePlayer([
    Skeleton(),
    Skeleton(),
    Skeleton(),
  ], 'https://masterpiecer-images.s3.yandex.net/739bce5e7c8e11ee9fd7aaafe6635749:upscaled', 'Player');
  final enemy = BattlePlayer([
    Peasant(),
    Peasant(),
    Peasant(),
  ], 'https://static.wikia.nocookie.net/officialbestiary/images/5/56/Anouki1.png/revision/latest?cb=20150622175528',
      'Ilkebel');
  bool _attackerIsPlayer = true;

  VoidCallback onChangeNotifier;

  BattlePlayer get attacker => _attackerIsPlayer ? player : enemy;

  BattlePlayer get defender => _attackerIsPlayer ? enemy : player;

  BattleActiveStage? stage;

  Battle(this.onChangeNotifier) {
    player._battle = this;
    enemy._battle = this;
  }

  playTurn() async {
    stage = BattleActiveStage();
    for (final unit in attacker.activeUnits) {
      stage!.attackingUnit = unit;
      stage!.lastAttacker = unit;
      onChangeNotifier();
      await Future.delayed(const Duration(seconds: 1));
      if (!isAttackerBlocked(unit)) defender.hp -= unit.attack;
      stage!.attackingUnit = null;
      onChangeNotifier();
      if (defender.hp < -0) break;
      await Future.delayed(const Duration(seconds: 1));
    }
    stage = null;
    endRound();
    onChangeNotifier();
  }

  endRound() {
    attacker.activeUnits.clear();
    defender.activeUnits.clear();
    if (defender.hp <= 0) return true;
    _attackerIsPlayer = !_attackerIsPlayer;
    if (attacker == enemy && enemy.unitsInHand.isNotEmpty) enemy.activeUnits.add(enemy.unitsInHand.first);
  }

  bool isAttackerBlocked(UnitCard attackingUnit) {
    final index = attacker.activeUnits.indexOf(attackingUnit);
    return defender.activeUnits.length > index;
  }

  toggleUnitActive(UnitCard unit) {
    if ((unit.player.activeUnits.contains(unit))) {
      unit.player.activeUnits.remove(unit);
    } else {
      unit.player.activeUnits.add(unit);
      if (unit.player == defender && unit.player.activeUnits.length > attacker.activeUnits.length) {
        Future.delayed(const Duration(milliseconds: 99)).then((_) {
          unit.player.activeUnits.remove(unit);
          onChangeNotifier();
        });
      }
    }
    onChangeNotifier();
  }
}
