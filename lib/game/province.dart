import 'dart:math';

import 'package:flagam/game/battle.dart';
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
        obj.x = (Random().nextInt(77) + 10) * Province.size / 100;
        obj.y = (Random().nextInt(77) + 10) * Province.size / 100;
        ok = true;
        for (final obj2 in objects) {
          if (obj2 == obj) continue;
          if ((obj2.x - obj.x).abs() < 44) ok = false;
          if ((obj2.y - obj.y).abs() < 55) ok = false;
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

  Sawmill() {
    owner = Ilkebel();
  }
}

class OrePit extends ProvinceObject {
  @override
  String get mapName => S.current.orePit;

  @override
  String get popupImage => 'assets/arena/433734_f7a1b4c7a4504e5faf10382c05ac1dc4_mv2.webp';

  @override
  String get popupText => S.current.orePitDesc;

  OrePit() {
    owner = Karandesh();
  }
}

abstract class Player {
  var color = Colors.grey;
  List<UnitCard> army = [];

  String get image;

  String get name;
}

class ThePlayer extends Player {
  String get image => 'assets/arena/739bce5e7c8e11ee9fd7aaafe6635749_upscaled.jfif';

  String get name => 'Player';

  ThePlayer() {
    color = Colors.purple;
    army = [
      Skeleton(),
      // Zombie(),
      Skeleton(),
    ];
  }
}

class Karandesh extends Player {
  @override
  String get image => 'assets/arena/7a43c7facc5c416ef20311f68d1dc0a5.jpg';

  @override
  String get name => 'Karandesh';

  Karandesh() {
    army = [
      Peasant(),
    ];
  }
}

class Ilkebel extends Player {
  String get image => 'assets/arena/хазяин лісопилки-01.png';

  String get name => 'Ilkebel';

  Ilkebel() {
    army = [
      Peasant(),
      Peasant(),
      Peasant(),
    ];
  }
}

class World {
  static final player = ThePlayer();
  static final players = [player];
  static final provinces = [Province()];
}
