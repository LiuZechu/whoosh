import 'dart:math';

import 'package:whoosh/entity/Commons.dart';

class MonsterType {
  int body;
  int eyes;
  int mouth;
  int accessory;
  int color;
  static final numberOfBodies = 7;
  static final numberOfEyes = 8;
  static final numberOfMouths = 15;
  static final numberOfAccessories = 15;
  static List<String> bodyIndices = Iterable<int>
      .generate(numberOfBodies - 1)
      .map((e) => (e + 1).toString())
      .toList();
  static List<String> eyesIndices = Iterable<int>
      .generate(numberOfEyes - 1)
      .map((e) => (e + 1).toString())
      .toList();
  static List<String> mouthIndices = Iterable<int>
      .generate(numberOfMouths - 1)
      .map((e) => (e + 1).toString())
      .toList();
  static List<String> accessoryIndices = Iterable<int>
      .generate(numberOfAccessories - 1)
      .map((e) => (e + 1).toString())
      .toList();
  static List<String> colorIndices = Iterable<int>
      .generate(Commons.monsterColors.length - 1)
      .map((e) => e.toString())
      .toList();
  static int noOfFeatures = 5;

  MonsterType(String monsterType) {
    List<String> pieces = monsterType.split(',');
    body = int.parse(pieces[0]);
    eyes = int.parse(pieces[1]);
    mouth = int.parse(pieces[2]);
    accessory = int.parse(pieces[3]);
    color = int.parse(pieces[4]);
  }

  static String appendBodyTypes(
      String body, String eyes, String mouth, String accessory, String color) {
    return body + ',' + eyes + ',' + mouth + ',' + accessory + ',' + color;
  }

  @override
  String toString() {
    return appendBodyTypes(
        body.toString(),
        eyes.toString(),
        mouth.toString(),
        accessory.toString(),
        color.toString());
  }

  static MonsterType generateRandomType() {
    final _random = new Random();

    String body = bodyIndices[_random.nextInt(bodyIndices.length)];
    String eyes = eyesIndices[_random.nextInt(eyesIndices.length)];
    String mouth = mouthIndices[_random.nextInt(mouthIndices.length)];
    String accessory = accessoryIndices[_random.nextInt(accessoryIndices.length)];
    String color = colorIndices[_random.nextInt(colorIndices.length)];

    return MonsterType(appendBodyTypes(body, eyes, mouth, accessory, color));
  }

  static List<MonsterType> generateMonsterTypes(String monsterTypes) {
    List<MonsterType> types = [];
    List<String> monsterTypesArray = monsterTypes.split(',');
    for (int i = 0; i < monsterTypesArray.length; i = i + noOfFeatures) {
      String body = monsterTypesArray[i];
      String eyes = monsterTypesArray[i + 1];
      String mouth = monsterTypesArray[i + 2];
      String accessory = monsterTypesArray[i + 3];
      String color = monsterTypesArray[i + 4];

      MonsterType type = MonsterType(appendBodyTypes(body, eyes, mouth, accessory, color));
      types.add(type);
    }
    return types;
  }

  static String generateMonsterTypesString(List<MonsterType> monsterTypes) {
    String monsterTypesString = '';
    monsterTypes.forEach((element) {
      monsterTypesString += element.toString() + ',';
    });
    return monsterTypesString.substring(0, monsterTypesString.length - 1);
  }
}