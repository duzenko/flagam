import 'dart:math';

import 'package:flutter/material.dart';

class Province {
  static const size = 512;
  final objects = [
    Town(),
    Sawmill(),
  ];
}

class ProvinceObject {
  final x = (Random().nextInt(80) + 3) * Province.size / 100;
  final y = (Random().nextInt(80) + 3) * Province.size / 100;
  Player? owner;

  get mapName => runtimeType.toString();

  get size => Province.size / 8;
}

class ProvinceAsset extends ProvinceObject {}

class Player {
  final color = Colors.purple;
}

class Town extends ProvinceAsset {
  @override
  get size => Province.size / 7;

  Town() {
    owner = World.players.first;
  }

  @override
  get mapName => 'Ancient Ruins';
}

class Sawmill extends ProvinceObject {}

class World {
  static final player = Player();
  static final players = [player];
  static final provinces = [Province()];
}
