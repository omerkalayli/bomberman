import 'dart:math';

import 'package:bomberman/controllers/player_controller.dart';
import 'package:bomberman/entities/block.dart';
import 'package:bomberman/entities/bomb.dart';
import 'package:bomberman/entities/player.dart';
import 'package:bomberman/entities/power_up.dart';

import 'package:get/get.dart';

class BlockController extends GetxController {
  RxList<List<Block?>> blocks = RxList.generate(
      9,
      (y) => List.generate(
          9,
          (x) => (y % 2 != 0 && x % 2 != 0)
              ? Block(isDestructible: false)
              : null));

  RxList<Bomb> droppedBombs = <Bomb>[].obs;

  List<int> initEmptyBlockIndexes = [
    0,
    1,
    2,
    6,
    7,
    8,
    9,
    17,
    18,
    26,
    62,
    63,
    54,
    71,
    72,
    73,
    74,
    78,
    79,
    80
  ];

  void dropBomb(int y, int x, int bomberID) {
    PlayerController playerController = Get.find();
    Player? p = playerController.getPlayerByID(bomberID);
    if ((p?.bombBuffCount.value ?? 0) <= 0) {
      return;
    }
    blocks[y][x] = Block(haveBomb: true, bomberID: bomberID);
    droppedBombs.add(Bomb(bomberID: p!.id, x: p.x.value, y: p.y.value));
    p.bombBuffCount.value--;
    Future.delayed(Duration(seconds: 2), () {
      explode(y, x, bomberID);
    });
  }

  void explode(int y, int x, int bomberID) {
    PlayerController playerController = Get.find();
    blocks[y][x] = Block(haveBomb: false);
    List<List<int>> explosionIndexes = List.empty(growable: true);
    int range = playerController.getPlayerByID(bomberID)!.fireBuffCount.value;

    bool? applyExplosion(int y, int x, int i, bool isVertical) {
      if (i < 0 || i > 8) {
        return false;
      }
      if (isVertical) {
        if (blocks[y][i]?.isDestructible ?? true == true) {
          destruct(y, i);
          explosionIndexes.add([y, i]);
        } else {
          return true;
        }
      } else if (blocks[i][x]?.isDestructible ?? true == true) {
        destruct(i, x);
        explosionIndexes.add([i, x]);
      } else if (blocks[i][x]?.isDestructible ?? true == false) {
        return true;
      } else if (blocks[i][x]?.isDestructible == false) {
        return true;
      } else if (playerController.returnPlayer(y, x) != null) {
        playerController.returnPlayer(y, x)!.kill();
        explosionIndexes.add([y, x]);
      } else {
        explosionIndexes.add([y, x]);
      }
    }

    // X pozisyonunda artan yönde
    for (int i = x; i <= x + range; i++) {
      if (applyExplosion(y, x, i, true) ?? false) {
        break;
      }
    }

// X pozisyonunda azalan yönde
    for (int i = x; i >= x - range; i--) {
      if (applyExplosion(y, x, i, true) ?? false) {
        break;
      }
    }

// Y pozisyonunda artan yönde
    for (int i = y; i <= y + range; i++) {
      if (applyExplosion(y, x, i, false) ?? false) {
        break;
      }
    }

// Y pozisyonunda azalan yönde
    for (int i = y; i >= y - range; i--) {
      if (applyExplosion(y, x, i, false) ?? false) {
        break;
      }
    }

    for (var index in explosionIndexes) {
      droppedBombs.removeWhere((bomb) => bomb.x == x && bomb.y == y);

      if (blocks[index[0]][index[1]] == null) {
        blocks[index[0]][index[1]] = Block(hasExplosion: true);
      } else {
        blocks[index[0]][index[1]]?.hasExplosion.value = true;
      }
      for (Player p in playerController.players.value) {
        if (p.y.value == index[0] && p.x.value == index[1]) {
          p.isDead = true;
        }
      }
    }
    playerController.getPlayerByID(bomberID)?.bombBuffCount.value++;

    Future.delayed(Duration(seconds: 1), () {
      for (var index in explosionIndexes) {
        blocks[index[0]][index[1]]?.powerUp == null
            ? blocks[index[0]][index[1]] = null
            : blocks[index[0]][index[1]]?.hasExplosion.value = false;
      }
      playerController.getPlayerByID(bomberID)?.bombBuffCount.refresh();
    });
  }

  void destruct(int y, int x) {
    if (blocks[y][x]?.powerUp != null) blocks[y][x]?.showPowerUp = true;
  }

  void initBlocks() {
    blocks = RxList.generate(
        9,
        (y) => List.generate(
            9,
            (x) => (y % 2 != 0 && x % 2 != 0)
                ? Block(isDestructible: false)
                : null));
    for (int y = 0; y < 9; y++) {
      for (int x = 0; x < 9; x++) {
        if (blocks[y][x] != null) {
          continue;
        }
        if (initEmptyBlockIndexes.contains(x + y * 9)) {
          continue;
        }
        bool hasPowerUp = Random().nextBool();
        if (hasPowerUp) {
          String powerUpType = ['bomb', 'fire'][Random().nextInt(2)];
          blocks[y][x] =
              Block(powerUp: PowerUp(type: powerUpType), isDestructible: true);
        } else {
          blocks[y][x] = Block(isDestructible: true);
        }
      }
    }
  }

  void takePowerUp(int y, int x) {
    blocks[y][x] = null;
  }
}
