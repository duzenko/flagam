import 'dart:ui';

import 'package:flagam/game/province.dart';
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

class Zombie extends UnitCard {
  @override
  get image => 'assets/units/4b7877538ac3cb30fa2b68ddea9b2007c7d975f6_2000x2000.webp';

  @override
  int get attack => 3;

  @override
  int get defence => 3;

  @override
  String get name => S.current.zombie;
}

class BattlePlayer {
  final List<UnitCard> unitsInHand = [];
  final activeUnits = <UnitCard>[];

  String get image => _player.image;

  String get name => _player.name;
  int hp = 10;
  late Battle _battle;
  Player _player;

  BattlePlayer(this._player) {
    // this.unitsInHand, this.image, this.name
    unitsInHand.addAll(_player.army);
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
  final player = BattlePlayer(World.player);
  late BattlePlayer enemy;
  bool _attackerIsPlayer = true;

  late VoidCallback onChangeNotifier;
  ProvinceObject grounds;

  BattlePlayer get attacker => _attackerIsPlayer ? player : enemy;

  BattlePlayer get defender => _attackerIsPlayer ? enemy : player;

  BattleActiveStage? stage;

  Battle(this.grounds) {
    enemy = BattlePlayer(grounds.owner!);
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
