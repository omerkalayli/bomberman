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

  List<List<List<DateTime>>> blocksBlowTimes =
      List.generate(9, (_) => List.generate(9, (_) => <DateTime>[]));

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
  Future<void> initExplosionIndexHandling() async {
    while (true) {
      await Future.delayed(Duration(milliseconds: 200));
      final now = DateTime.now();
      for (int i = 0; i < blocksBlowTimes.length; i++) {
        for (int j = 0; j < blocksBlowTimes[i].length; j++) {
          blocksBlowTimes[i][j].removeWhere((time) => now.isAfter(time));
        }
      }
    }
  }

  void addExplosion(int x, int y, Duration duration) {
    final now = DateTime.now();
    final expiry = now.add(duration);

    if (blocksBlowTimes[x][y].isEmpty) {
      blocksBlowTimes[x][y] = [];
    }
    blocksBlowTimes[x][y].add(expiry);
  }

  void explode(int y, int x, int bomberID, int fireRange) {
    PlayerController playerController = Get.find();
    blocks[y][x] = Block(haveBomb: false);

    List<List<int>> explosionIndexes =
        handleExplosion(playerController, x, fireRange, y, true, bomberID);

    for (var index in explosionIndexes) {
      droppedBombs.removeWhere((bomb) => bomb.x == x && bomb.y == y);

      if (blocks[index[0]][index[1]] == null) {
        blocks[index[0]][index[1]] =
            Block(hasExplosion: true, bomberID: bomberID);
      } else {
        blocks[index[0]][index[1]]?.hasExplosion.value = true;
        blocks[index[0]][index[1]]?.bomberID = bomberID;
      }
      for (Player p in playerController.players.value) {
        if (p.y.value == index[0] && p.x.value == index[1]) {
          if (!p.isDead) {
            if (p.id != bomberID) {
              playerController.getPlayerByID(bomberID)?.score.value += 10;
            }
            p.kill(bomberID);
          }
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

  Future<void> dropBomb(int y, int x, int bomberID, int fireRange) async {
    PlayerController playerController = Get.find();
    Player? p = playerController.getPlayerByID(bomberID);
    if ((p?.bombBuffCount.value ?? 0) <= 0) {
      return;
    }
    blocks[y][x] = Block(haveBomb: true, bomberID: bomberID);
    droppedBombs.add(Bomb(bomberID: p!.id, x: p.x.value, y: p.y.value));
    p.bombBuffCount.value--;

    handleExplosion(playerController, x, fireRange, y, false, bomberID);

    Future.delayed(Duration(seconds: 2), () {
      explode(y, x, bomberID, fireRange);
    });
  }

  List<List<int>> handleExplosion(PlayerController playerController, int x,
      int range, int y, bool applyAction, int bomberID) {
    List<List<int>> explosionIndexes = List.empty(growable: true);

    bool? applyExplosion(int y, int x, int i, bool isVertical) {
      if (i < 0 || i > 8) {
        return false;
      }
      if (isVertical) {
        if (blocks[y][i]?.isDestructible ?? true == true) {
          applyAction && (blocks.value != null)
              ? destruct(y, i, bomberID)
              : null;
          explosionIndexes.add([y, i]);
          if (!applyAction) {
            // blocksBlowTimes[y][i].add(DateTime.now().add(Duration(seconds: 2)));
            addExplosion(y, i, Duration(seconds: 2));
          }
        } else {
          return true;
        }
      } else if (blocks[i][x]?.isDestructible ?? true == true) {
        applyAction ? destruct(i, x, bomberID) : null;
        explosionIndexes.add([i, x]);
        if (!applyAction) {
          addExplosion(i, x, Duration(seconds: 2));
        }
      } else if (blocks[i][x]?.isDestructible ?? true == false) {
        return true;
      } else if (blocks[i][x]?.isDestructible == false) {
        return true;
      } else if (playerController.returnPlayer(y, x) != null) {
        playerController.returnPlayer(y, x)!.kill(blocks[y][x]!.bomberID!);
        explosionIndexes.add([y, x]);
        if (!applyAction) {
          addExplosion(y, x, Duration(seconds: 2));
        }
      } else {
        explosionIndexes.add([y, x]);
        if (!applyAction) {
          addExplosion(y, x, Duration(seconds: 2));
        }
      }
      return null;
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

    return explosionIndexes;
  }

  void destruct(int y, int x, int bomberID) {
    if (blocks[y][x]?.powerUp != null) {
      PlayerController playerController = Get.find();
      blocks[y][x]?.showPowerUp = true;
      blocks[y][x]?.isDestructible = null;
      playerController.getPlayerByID(bomberID)!.score.value += 1;
    }
  }

  void initBlocks() {
    droppedBombs.value = <Bomb>[].obs;
    blocks = RxList.generate(
        9,
        (y) => List.generate(
            9,
            (x) => (y % 2 != 0 && x % 2 != 0)
                ? Block(isDestructible: false)
                : null));
    droppedBombs.value = <Bomb>[].obs;

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

  void takePowerUp(int y, int x, int id) {
    PlayerController playerController = Get.find();
    playerController.getPlayerByID(id)!.score.value += 2;

    blocks[y][x] = null;
    update();
  }

  List<List<int>> getExplosionIndexes(int x, int range, int y) {
    List<List<int>> explosionIndexes = List.empty(growable: true);

    bool? applyExplosion(int y, int x, int i, bool isVertical) {
      if (i < 0 || i > 8) {
        return false;
      }
      if (isVertical) {
        if (blocks[y][i]?.isDestructible ?? true == true) {
          explosionIndexes.add([y, i]);
        } else {
          return true;
        }
      } else if (blocks[i][x]?.isDestructible ?? true == true) {
        explosionIndexes.add([i, x]);
      } else if (blocks[i][x]?.isDestructible ?? true == false) {
        return true;
      } else if (blocks[i][x]?.isDestructible == false) {
        return true;
      } else {
        explosionIndexes.add([y, x]);
      }
      return null;
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

    return explosionIndexes;
  }
}
