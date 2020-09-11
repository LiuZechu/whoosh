import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whoosh/MonsterFactory.dart';

class Group {
  int id;
  String name;
  int groupSize;
  DateTime timeOfArrival;

  Group(int id, String name, int groupSize, DateTime timeOfArrival) {
    this.id = id;
    this.name = name;
    this.groupSize = groupSize;
    this.timeOfArrival = timeOfArrival;
  }

  Widget createGroupImage(bool isEndOfQueue) {
    return Container(
        height: 400,
        width: 400,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent)
        ),
        alignment: Alignment.center,
        child: Stack(
            children: createStackElements(isEndOfQueue)
        )
    );
  }

  List<Widget> createStackElements(bool isEndOfQueue) {
    List<Widget> stackElements = [];
    stackElements.add(
        Align(
          alignment: Alignment.bottomCenter,
          child: Image(
            alignment: Alignment.bottomCenter,
            image: AssetImage('images/queue_line.png'),
            width: 13,
            height: 400,
          ),
        )
    );
    if (isEndOfQueue) {
      stackElements.add(generateLineMask());
    }
    List<Widget> monsterWidgets = [];
    List<Monster> monsters = [];
    for (int i = 0; i < groupSize; i++) {
      monsters.add(MonsterFactory.getMonsterById(i));
    }
    while (monsters.isNotEmpty && monsters.last.id > 2) {
      Monster last = monsters.removeLast();
      monsters.insert(0, last);
    }
    for (int i = 0; i < groupSize; i++) {
      Monster monster = monsters[i];
      monsterWidgets.add(
        Align(
          alignment: monster.alignment,
          child: Image(
            alignment: monster.alignment,
            image: monster.asset,
          )
        )
      );
    }
    stackElements.add(
      Align(
        alignment: Alignment.center,
        child: Container(
          width: 200,
          height: 200,
          child: Stack(
            children: monsterWidgets,
          ),
        )
      )
    );
    return stackElements;
  }

  Widget generateLineMask() {
    return Align(
      alignment: Alignment.topCenter,
      child: Image(
        image: AssetImage('images/queue_line_mask.png'),
        width: 400,
        height: 200,
      ),
    );
  }
}