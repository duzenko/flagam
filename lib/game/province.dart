import 'dart:math';

import 'package:flagam/generated/l10n.dart';
import 'package:flutter/material.dart';

class Province {
  static const size = 512;
  final objects = [
    Town(),
    Sawmill(),
  ];
}

abstract class ProvinceObject {
  final x = (Random().nextInt(80) + 3) * Province.size / 100;
  final y = (Random().nextInt(80) + 3) * Province.size / 100;
  Player? owner;

  String get mapName;

  get size => Province.size / 8;
}

class Player {
  final color = Colors.purple;
}

class Town extends ProvinceObject {
  @override
  get size => Province.size / 7;

  Town() {
    owner = World.players.first;
  }

  @override
  get mapName => S.current.ruins;
}

class Sawmill extends ProvinceObject {
  @override
  String get mapName => S.current.sawmill;
}

class World {
  static final player = Player();
  static final players = [player];
  static final provinces = [Province()];
}
