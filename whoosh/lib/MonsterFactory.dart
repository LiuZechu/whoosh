

import 'package:flutter/cupertino.dart';

class MonsterFactory {
  static List<AssetImage> allMonsterAssets = [
    AssetImage('images/monster_1.png'),
    AssetImage('images/monster_2.png'),
    AssetImage('images/monster_3.png'),
    AssetImage('images/monster_5.png'),
    AssetImage('images/monster_4.png'),
  ];

  static List<Alignment> allMonsterAlignments = [
    Alignment.center,
    Alignment(-0.5, 1.0),
    Alignment(0.6, 1.0),
    Alignment.topLeft,
    Alignment.topRight,
  ];

  static Monster getMonsterById(int id) {
    return Monster(id, allMonsterAssets[id], allMonsterAlignments[id]);
  }
}

class Monster {
  int id;
  AssetImage asset;
  Alignment alignment;

  Monster(id, asset, alignment) {
    this.id = id;
    this.asset = asset;
    this.alignment = alignment;
  }
}