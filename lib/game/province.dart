import 'dart:math';

import 'package:flagam/generated/l10n.dart';
import 'package:flutter/material.dart';

class Province {
  static const size = 512;

  List<ProvinceObject> objects = [
    Town(),
    Sawmill(),
    OrePit(),
  ];

  Province() {
    for (final obj in objects) {
      bool ok = true;
      do {
        obj.x = (Random().nextInt(80) + 10) * Province.size / 100;
        obj.y = (Random().nextInt(80) + 10) * Province.size / 100;
        ok = true;
        for (final obj2 in objects) {
          if (obj2 == obj) continue;
          if ((obj2.x - obj.x).abs() < 44) ok = false;
          if ((obj2.y - obj.y).abs() < 44) ok = false;
        }
      } while (!ok);
    }
  }
}

abstract class ProvinceObject {
  double x = 0;
  double y = 0;
  Player? owner;

  String get mapName;

  get size => Province.size / 8;

  String get popupImage;

  String get popupText;
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

  @override
  String get popupImage => 'assets/arena/52246834659_2628252ee8_b.jpg';

  @override
  String get popupText => S.current.ruinsDesc;
}

class Sawmill extends ProvinceObject {
  @override
  String get mapName => S.current.sawmill;

  @override
  String get popupImage => 'assets/arena/Woodshed_I.webp';

  @override
  String get popupText => S.current.sawmillDesc;
}

class OrePit extends ProvinceObject {
  @override
  String get mapName => S.current.orePit;

  @override
  String get popupImage => 'assets/arena/Woodshed_I.webp';

  @override
  String get popupText => S.current.orePitDesc;
}

class World {
  static final player = Player();
  static final players = [player];
  static final provinces = [Province()];
}
