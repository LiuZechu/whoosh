import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whoosh/entity/MonsterType.dart';

class MonsterFactory {
  static final FlareControls controls = FlareControls();
  static List<Color> colors = [Colors.black, Colors.green, Colors.cyan, Colors.deepOrange];

  static Widget createMonsterActor(int id, MonsterType type, double monsterSize) {
    return Container(
      width: monsterSize,
      height: monsterSize,
      child: Stack(
        children: [
          FlareActor(
            'images/actors/bodies.flr',
            color: colors[type.color],
            isPaused: false,
            animation: 'fidget',
            artboard: type.body.toString(),
            controller: controls,
          ),
          FlareActor(
            'images/actors/eyes.flr',
            isPaused: false,
            animation: 'blink',
            artboard: type.eyes.toString(),
            controller: controls,
          ),
          FlareActor(
            'images/actors/mouths.flr',
            artboard: type.mouth.toString(),
            controller: controls,
          ),
          FlareActor(
            'images/actors/accessories.flr',
            artboard: type.accessory.toString(),
            controller: controls,
          ),
        ],
      )
    );
  }

  static List<Alignment> allMonsterAlignments = [
    Alignment.center,
    Alignment(-0.5, 1.0),
    Alignment(0.5, 1.0),
    Alignment.topLeft,
    Alignment.topRight,
  ];

  static Monster getMonsterById(int id, MonsterType type, double monsterSize) {
    return Monster(
        id,
        createMonsterActor(id, type, monsterSize),
        allMonsterAlignments[id],
    );
  }
}

class Monster {
  int id;
  Widget actor;
  Alignment alignment;

  Monster(id, actor, alignment) {
    this.id = id;
    this.actor = actor;
    this.alignment = alignment;
  }
}