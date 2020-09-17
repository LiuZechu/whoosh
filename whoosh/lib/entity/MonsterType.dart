import 'dart:math';

class MonsterType {
  int body;
  int eyes;
  int mouth;
  int accessory;
  int color;
  static List<String> bodyIndices = ['1', '2', '3'];
  static List<String> eyesIndices = ['1', '2', '3'];
  static List<String> mouthIndices = ['1', '2', '3'];
  static List<String> accessoryIndices = ['1', '2', '3'];
  static List<String> colorIndices = ['1', '2', '3'];
  static int noOfFeatures = 5;

  MonsterType(String monsterType) {
    body = int.parse(monsterType[0]);
    eyes = int.parse(monsterType[1]);
    mouth = int.parse(monsterType[2]);
    accessory = int.parse(monsterType[3]);
    color = int.parse(monsterType[4]);
  }

  @override
  String toString() {
    return body.toString() + eyes.toString() + mouth.toString() + accessory.toString() + color.toString();
  }

  static MonsterType generateRandomType() {
    final _random = new Random();

    String body = bodyIndices[_random.nextInt(bodyIndices.length)];
    String eyes = eyesIndices[_random.nextInt(eyesIndices.length)];
    String mouth = mouthIndices[_random.nextInt(mouthIndices.length)];
    String accessory = accessoryIndices[_random.nextInt(accessoryIndices.length)];
    String color = colorIndices[_random.nextInt(colorIndices.length)];

    return MonsterType(body + eyes + mouth + accessory + color);
  }

  static List<MonsterType> generateMonsterTypes(String monsterTypes) {
    List<MonsterType> types = [];
    for (int i = 0; i < monsterTypes.length; i = i + noOfFeatures) {
      types.add(MonsterType(monsterTypes.substring(i, i + noOfFeatures)));
    }
    return types;
  }
}