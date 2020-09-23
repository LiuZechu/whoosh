import 'dart:math';

import 'package:flare_flutter/flare_controls.dart';

class EffectManager {
  final FlareControls moveOneController = FlareControls();
  final FlareControls moveTwoController = FlareControls();
  final FlareControls moveThreeController = FlareControls();
  final FlareControls poofController = FlareControls();
  List<FlareControls> allMoveControllers;

  EffectManager() {
    allMoveControllers = [moveOneController, moveTwoController, moveThreeController];
  }

  FlareControls getRandomController() {
    final _random = new Random();
    return allMoveControllers[_random.nextInt(allMoveControllers.length)];
  }

  void playPoof() {
    poofController.play('poof');
  }

  void playRandomEffect() {
    getRandomController().play('move');
  }
}