class BattleCard {}

abstract class UnitCard {
  String get image;

  String get name => runtimeType.toString();
  int damage = 2;
}

class Peasant extends UnitCard {
  @override
  get image => 'assets/units/скелет.png';
}

class SkeletonWarrior extends UnitCard {
  @override
  get image => 'assets/units/скелет.png';
}

class BattlePlayer {
  final List<UnitCard> unitsInHand;
  final attackingUnits = <UnitCard>[];
  final String image;
  final String name;
  int hp = 10;

  BattlePlayer(this.unitsInHand, this.image, this.name);
}

class Battle {
  final player = BattlePlayer([
    SkeletonWarrior(),
    SkeletonWarrior(),
    SkeletonWarrior(),
  ], 'https://static.wikia.nocookie.net/officialbestiary/images/5/59/Revenant.jpg/revision/latest?cb=20150704015728',
      'Player');
  final enemy = BattlePlayer([
    Peasant(),
    Peasant(),
    Peasant(),
  ], 'https://static.wikia.nocookie.net/officialbestiary/images/5/56/Anouki1.png/revision/latest?cb=20150622175528',
      'Ilkebel');
  bool _attackerIsPlayer = true;

  BattlePlayer get attacker => _attackerIsPlayer ? player : enemy;

  BattlePlayer get defender => _attackerIsPlayer ? enemy : player;

  endRound() {
    attacker.attackingUnits.clear();
    if (defender.hp <= 0) return true;
    _attackerIsPlayer = !_attackerIsPlayer;
    if (attacker == enemy) enemy.attackingUnits.add(enemy.unitsInHand.first);
  }
}
