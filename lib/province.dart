import 'dart:math';

class Province {
  static const SIZE = 512;
  final objects = [
    Town(),
    Sawmill(),
  ];
}

class ProvinceObject {
  get mapName => runtimeType.toString();
  final x = (Random().nextInt(80) + 10) * Province.SIZE / 100;
  final y = (Random().nextInt(80) + 10) * Province.SIZE / 100;

  get size => Province.SIZE / 8;
}

class Town extends ProvinceObject {
  @override
  get size => Province.SIZE / 7;
}

class Sawmill extends ProvinceObject {}

class World {
  static final provinces = [Province()];
}
