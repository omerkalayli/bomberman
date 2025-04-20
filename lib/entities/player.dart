import 'package:bomberman/controllers/block_controller.dart';
import 'package:bomberman/controllers/player_controller.dart';
import 'package:bomberman/entities/block.dart';
import 'package:get/get.dart';

class Player {
  final int id;
  RxInt score = 0.obs;
  RxInt x;
  RxInt y;
  RxInt bombBuffCount = 1.obs;
  RxInt fireBuffCount = 1.obs;
  bool isDead = false;

  Player({required this.id, required RxInt x, required RxInt y})
      : x = x.obs.value,
        y = y.obs.value;

  void moveTo(List<List<int>> path) {
    BlockController blockController = Get.find();
    for (var turn in path) {
      if (turn[0] > y.value) {
        moveUp(blockController.blocks);
      }
      if (turn[0] < y.value) {
        moveDown(blockController.blocks);
      }
      if (turn[1] > x.value) {
        moveRight(blockController.blocks);
      }
      if (turn[1] > x.value) {
        moveLeft(blockController.blocks);
      }
    }
  }

  void moveLeft(RxList<List<Block?>> blocks) {
    bool powerUpTaken = false;
    if (isDead) {
      return;
    }

    if (y.value == 0) return;
    Block? b = blocks[y.value - 1][x.value];
    if (y.value != 0 && b != null) {
      if (b.hasExplosion.value) {
        (b.bomberID!);
      }
      if (b.showPowerUp ?? false) {
        BlockController blockController = Get.find();
        if (b.powerUp?.type == "bomb") {
          bombBuffCount++;
        } else {
          takeFireBuff();
        }
        blockController.takePowerUp(y.value - 1, x.value, id);
        powerUpTaken = true;
      }
    }
    if (b == null || b.hasExplosion.value || powerUpTaken) y.value--;
  }

  void moveRight(RxList<List<Block?>> blocks) {
    bool powerUpTaken = false;
    if (isDead) {
      return;
    }

    if (y.value == 8) return;
    Block? b = blocks[y.value + 1][x.value];
    if (y.value != 8 && b != null) {
      if (b.hasExplosion.value) {
        kill(b.bomberID!);
      }
      if (b.showPowerUp ?? false) {
        BlockController blockController = Get.find();
        if (b.powerUp?.type == "bomb") {
          bombBuffCount++;
        } else {
          takeFireBuff();
        }
        blockController.takePowerUp(y.value + 1, x.value, id);
        powerUpTaken = true;
      }
    }
    if (b == null || b.hasExplosion.value || powerUpTaken) y.value++;
  }

  void moveUp(RxList<List<Block?>> blocks) {
    bool powerUpTaken = false;
    if (isDead) {
      return;
    }

    if (x.value == 0) return;
    Block? b = blocks[y.value][x.value - 1];
    if (x.value != 0 && b != null) {
      if (b.hasExplosion.value) {
        kill(b.bomberID!);
      }
      if (b.showPowerUp ?? false) {
        BlockController blockController = Get.find();
        if (b.powerUp?.type == "bomb") {
          bombBuffCount++;
        } else {
          takeFireBuff();
        }
        blockController.takePowerUp(y.value, x.value - 1, id);
        powerUpTaken = true;
      }
    }
    if (b == null || b.hasExplosion.value || powerUpTaken) x.value--;
  }

  void moveDown(RxList<List<Block?>> blocks) {
    bool powerUpTaken = false;
    if (isDead) {
      return;
    }

    if (x.value == 8) return;
    Block? b = blocks[y.value][x.value + 1];
    if (x.value != 8 && b != null) {
      if (b.hasExplosion.value) {
        kill(b.bomberID!);
      }
      if (b.showPowerUp ?? false) {
        BlockController blockController = Get.find();
        if (b.powerUp?.type == "bomb") {
          bombBuffCount++;
        } else {
          takeFireBuff();
        }
        blockController.takePowerUp(y.value, x.value + 1, id);
        powerUpTaken = true;
      }
    }
    if (b == null || b.hasExplosion.value || powerUpTaken) x.value++;
  }

  void dropBomb() {
    if (isDead) {
      return;
    }
    BlockController blockController = Get.find();
    blockController.dropBomb(y.value, x.value, id, fireBuffCount.value);
  }

  void kill(int bomberID) {
    isDead = true;
    PlayerController playerController = Get.find();
    if (bomberID != id) {
      playerController.getPlayerByID(bomberID)?.score.value += 10;
    }
  }

  void takeFireBuff() {
    if (fireBuffCount.value < 8) fireBuffCount.value++;
  }
}
