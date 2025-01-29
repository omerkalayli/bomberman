import 'dart:math';

import 'package:bomberman/entities/block.dart';
import 'package:bomberman/entities/power_up.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class BlockController extends GetxController {
  final RxList<List<Block?>> blocks = RxList.generate(
      9,
      (x) => List.generate(
          9,
          (y) => (y % 2 != 0 && x % 2 != 0)
              ? Block(isDestructible: false)
              : null));

  List<int> initEmptyBlockIndexes = [0, 1, 7, 8, 9, 17, 63, 71, 72, 73, 79, 80];

  void initBlocks() {
    for (int x = 0; x < 9; x++) {
      for (int y = 0; y < 9; y++) {
        if (blocks[x][y] != null) {
          continue;
        }
        if (initEmptyBlockIndexes.contains(y + x * 9)) {
          continue;
        }
        bool hasPowerUp = Random().nextBool();
        if (hasPowerUp) {
          String powerUpType = ['bomb', 'fire'][Random().nextInt(2)];
          blocks[x][y] =
              Block(powerUp: PowerUp(type: powerUpType), isDestructible: true);
        }
        blocks[x][y] = Block(isDestructible: true);
      }
    }
  }
}
