class BattleCard {}

abstract class UnitCard {
  late BattlePlayer _player;

  int? attackIndex;

  String get image;

  String get name => runtimeType.toString();

  BattlePlayer get player => _player;

  int get damage;
}

class Peasant extends UnitCard {
  @override
  get image => 'assets/units/medieval-peasant-cartoon-composition-vector-41944465.jpg';

  @override
  int get damage => 1;
}

class Skeleton extends UnitCard {
  @override
  get image => 'assets/units/скелет.png';

  @override
  int get damage => 2;
}

class BattlePlayer {
  final List<UnitCard> unitsInHand;
  final attackingUnits = <UnitCard>[];
  final String image;
  final String name;
  int hp = 10;

  BattlePlayer(this.unitsInHand, this.image, this.name) {
    for (final unit in unitsInHand) unit._player = this;
  }
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

  BattlePlayer get attacker => _attackerIsPlayer ? player : enemy;

  BattlePlayer get defender => _attackerIsPlayer ? enemy : player;

  endRound() {
    // attacker.unitsInHand.addAll(attacker.attackingUnits);
    attacker.attackingUnits.clear();
    if (defender.hp <= 0) return true;
    _attackerIsPlayer = !_attackerIsPlayer;
    if (attacker == enemy) enemy.attackingUnits.add(enemy.unitsInHand.first);
  }
}
