class BattleCard {}

abstract class UnitCard {
  String get image;

  String get name => runtimeType.toString();
}

class Peasant extends UnitCard {
  @override
  get image =>
      'https://static.wikia.nocookie.net/officialbestiary/images/8/89/Kobold1.jpg/revision/latest?cb=20150611153254';
}

class SkeletonWarrior extends UnitCard {
  @override
  get image =>
      'https://static.wikia.nocookie.net/officialbestiary/images/f/fb/SkeletalWarrior1.jpg/revision/latest?cb=20150622155622';
}

class BattlePlayer {
  final List<UnitCard> unitsInHand;
  final attackingUnits = <UnitCard>[];
  final String image;
  final String name;

  BattlePlayer(this.unitsInHand, this.image, this.name);
}

abstract class Battle {
  static final player = BattlePlayer([
    SkeletonWarrior(),
    SkeletonWarrior(),
    SkeletonWarrior(),
  ], 'https://static.wikia.nocookie.net/officialbestiary/images/5/59/Revenant.jpg/revision/latest?cb=20150704015728',
      'Player');
  static final enemy = BattlePlayer([
    Peasant(),
    Peasant(),
    Peasant(),
  ], 'https://static.wikia.nocookie.net/officialbestiary/images/5/56/Anouki1.png/revision/latest?cb=20150622175528',
      'Ilkebel');
}
