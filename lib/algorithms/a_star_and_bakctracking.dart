import 'package:bomberman/controllers/block_controller.dart';
import 'package:bomberman/controllers/player_controller.dart';
import 'package:bomberman/entities/block.dart';
import 'package:bomberman/entities/player.dart';
import 'package:get/get.dart';

class AStarAndBakctracking {
  // Version 2
  static List<int>? findBestBlock1(
      Map<List<int>, List<List<int>>?> accessibleBlocks,
      int fireRange,
      int playerID) {
    BlockController blockController = Get.find();
    blockController.update();
    List<List<Block?>> blocks = blockController.blocks;
    List<List<List<DateTime>>> blocksBlowTimes =
        blockController.blocksBlowTimes;
    PlayerController playerController = Get.find();
    List<int>? maxScoreIndex;
    double maxScore = double.minPositive; // Negatif skorlardan kaçınmak için
    for (var blockIndexes in accessibleBlocks.keys) {
      List<DateTime> blockBlowTimeRemainingList =
          blocksBlowTimes[blockIndexes[1]][blockIndexes[0]];

      if ((blockBlowTimeRemainingList.isNotEmpty &&
          blockBlowTimeRemainingList
              .any((val) => val.difference(DateTime.now()).inSeconds <= 1))) {
        continue;
      }

      bool hasPowerUp =
          blocks[blockIndexes[1]][blockIndexes[0]]?.powerUp != null;
      double score = hasPowerUp ? 5 : 0;
      int destructableBlockCount = 0;

      int enemyDamageScore = 0;

      for (int i = 0; i <= fireRange; i++) {
        if (blockIndexes[0] + i > 8) break;
        Block? b = blocks[blockIndexes[1]][blockIndexes[0] + i];
        for (int j = 0; j < playerController.players.length; j++) {
          Player p = playerController.players[j];
          if (p.id != playerID && !p.isDead) {
            if (((p.x.value >= blockIndexes[0] - 1 &&
                        p.x.value <= blockIndexes[0] + 1) &&
                    (p.y.value >= blockIndexes[1] - 1 &&
                        p.y.value <= blockIndexes[1] + 1)) ||
                ((p.x.value == blockIndexes[0] &&
                        p.y.value == blockIndexes[1]) ||
                    (p.x.value == blockIndexes[0] + i &&
                        p.y.value == blockIndexes[1]))) {
              enemyDamageScore += 5;
            }
          }
        }
        if (((b?.hasExplosion.value ?? false) == false) &&
            ((b?.isDestructible ?? false) == true)) {
          destructableBlockCount++;
        }
        if (blockIndexes[0] - i < 0) break;
        b = blocks[blockIndexes[1]][blockIndexes[0] - i];
        if (((b?.hasExplosion.value ?? false) == false) &&
            ((b?.isDestructible ?? false) == true)) {
          destructableBlockCount++;
        }
      }
      for (int i = 0; i <= fireRange; i++) {
        if (blockIndexes[1] + i > 8) break;
        Block? b = blocks[blockIndexes[1] + i][blockIndexes[0]];
        if (((b?.hasExplosion.value ?? false) == false) &&
            ((b?.isDestructible ?? false) == true)) {
          destructableBlockCount++;
        }
        if (blockIndexes[1] - i < 0) break;
        b = blocks[blockIndexes[1] - i][blockIndexes[0]];
        if (((b?.hasExplosion.value ?? false) == false) &&
            ((b?.isDestructible ?? false) == true)) {
          destructableBlockCount++;
        }
      }

      bool gonnaBlow = false;

      for (int i = 0; i < accessibleBlocks[blockIndexes]!.length; i++) {
        List<int> path = accessibleBlocks[blockIndexes]![i];
        bool pass = false;

        if (path.isNotEmpty) {
          List<DateTime> blowStartTimes = blocksBlowTimes[path[1]][path[0]];

          for (var blowTime in blowStartTimes) {
            Duration? timePassed = blowStartTimes.isNotEmpty
                ? blowTime.difference(DateTime.now())
                : null;

            if (timePassed == null) {
              continue;
            }

            DateTime blowStartTime = blowTime.add(Duration(seconds: 0));
            DateTime blowEndTime = blowTime.add(Duration(seconds: 1));
            DateTime timeEnteredBlock =
                DateTime.now().add(Duration(milliseconds: i * 200));
            DateTime timeExitedBlock =
                DateTime.now().add(Duration(milliseconds: (i + 1) * 200));

            bool isHitByBlow = !(timeExitedBlock.isBefore(blowStartTime) ||
                timeEnteredBlock.isAfter(blowEndTime));

            if (isHitByBlow) {
              gonnaBlow = true;
            }

            if (blowStartTimes.isEmpty) {
              pass = true;
            }
          }
          if (pass) {
            continue;
          }
        }
      }

      if (gonnaBlow) {
        continue;
      }

      score += destructableBlockCount + enemyDamageScore;

      if (score > maxScore) {
        maxScore = score;
        maxScoreIndex = blockIndexes;
      }
    }

    if (maxScoreIndex == null) {
      return null;
    }

    return maxScoreIndex;
  }

// Yok edilen block sayisinin agirligi artirildi, uzaklık negatif agirlik olarak heuristik'e eklendi
// Version 1
  static List<int>? findBestBlock2(
      Map<List<int>, List<List<int>>?> accessibleBlocks,
      int fireRange,
      int playerID) {
    BlockController blockController = Get.find();
    blockController.update();
    List<List<Block?>> blocks = blockController.blocks;
    List<List<List<DateTime>>> blocksBlowTimes =
        blockController.blocksBlowTimes;
    PlayerController playerController = Get.find();
    List<int>? maxScoreIndex;
    double maxScore = double.minPositive; // Negatif skorlardan kaçınmak için

    for (var blockIndexes in accessibleBlocks.keys) {
      List<DateTime> blockBlowTimeRemainingList =
          blocksBlowTimes[blockIndexes[1]][blockIndexes[0]];

      if ((blockBlowTimeRemainingList.isNotEmpty &&
          blockBlowTimeRemainingList
              .any((val) => val.difference(DateTime.now()).inSeconds <= 1))) {
        continue;
      }

      bool hasPowerUp =
          blocks[blockIndexes[1]][blockIndexes[0]]?.powerUp != null;
      double score = hasPowerUp ? 5 : 0;
      int destructableBlockCount = 0;

      int enemyDamageScore = 0;

      for (int i = 0; i <= fireRange; i++) {
        if (blockIndexes[0] + i > 8) break;
        Block? b = blocks[blockIndexes[1]][blockIndexes[0] + i];
        for (int j = 0; j < playerController.players.length; j++) {
          Player p = playerController.players[j];
          if (p.id != playerID && !p.isDead) {
            if (((p.x.value >= blockIndexes[0] - 1 &&
                        p.x.value <= blockIndexes[0] + 1) &&
                    (p.y.value >= blockIndexes[1] - 1 &&
                        p.y.value <= blockIndexes[1] + 1)) ||
                ((p.x.value == blockIndexes[0] &&
                        p.y.value == blockIndexes[1]) ||
                    (p.x.value == blockIndexes[0] + i &&
                        p.y.value == blockIndexes[1]))) {
              enemyDamageScore += 5;
            }
          }
        }
        if (((b?.hasExplosion.value ?? false) == false) &&
            ((b?.isDestructible ?? false) == true)) {
          destructableBlockCount++;
        }
        if (blockIndexes[0] - i < 0) break;
        b = blocks[blockIndexes[1]][blockIndexes[0] - i];
        if (((b?.hasExplosion.value ?? false) == false) &&
            ((b?.isDestructible ?? false) == true)) {
          destructableBlockCount++;
        }
      }
      for (int i = 0; i <= fireRange; i++) {
        if (blockIndexes[1] + i > 8) break;
        Block? b = blocks[blockIndexes[1] + i][blockIndexes[0]];
        if (((b?.hasExplosion.value ?? false) == false) &&
            ((b?.isDestructible ?? false) == true)) {
          destructableBlockCount++;
        }
        if (blockIndexes[1] - i < 0) break;
        b = blocks[blockIndexes[1] - i][blockIndexes[0]];
        if (((b?.hasExplosion.value ?? false) == false) &&
            ((b?.isDestructible ?? false) == true)) {
          destructableBlockCount++;
        }
      }

      bool gonnaBlow = false;

      for (int i = 0; i < accessibleBlocks[blockIndexes]!.length; i++) {
        List<int> path = accessibleBlocks[blockIndexes]![i];
        bool pass = false;

        if (path.isNotEmpty) {
          List<DateTime> blowStartTimes = blocksBlowTimes[path[1]][path[0]];

          for (var blowTime in blowStartTimes) {
            Duration? timePassed = blowStartTimes.isNotEmpty
                ? blowTime.difference(DateTime.now())
                : null;

            if (timePassed == null) {
              continue;
            }

            DateTime blowStartTime = blowTime.add(Duration(seconds: 0));
            DateTime blowEndTime =
                blowTime.add(Duration(seconds: 1)); // 2 fitil, 1 patlama
            DateTime timeEnteredBlock =
                DateTime.now().add(Duration(milliseconds: i * 200));
            DateTime timeExitedBlock =
                DateTime.now().add(Duration(milliseconds: (i + 1) * 200));

            bool isHitByBlow = !(timeExitedBlock.isBefore(blowStartTime) ||
                timeEnteredBlock.isAfter(blowEndTime));

            if (isHitByBlow) {
              gonnaBlow = true;
            }

            if (blowStartTimes.isEmpty) {
              pass = true;
            }
          }
          if (pass) {
            continue;
          }
        }
      }

      if (gonnaBlow) {
        continue;
      }

      score += (destructableBlockCount * 2) + enemyDamageScore;
      -accessibleBlocks[blockIndexes]!.length / 2;

      if (score > maxScore) {
        maxScore = score;
        maxScoreIndex = blockIndexes;
      }
    }

    if (maxScoreIndex == null) {
      return null;
    }

    return maxScoreIndex;
  }

  // Version 3
  static List<int>? findBestBlock3(
      Map<List<int>, List<List<int>>?> accessibleBlocks,
      int fireRange,
      int playerID) {
    BlockController blockController = Get.find();
    blockController.update();
    List<List<Block?>> blocks = blockController.blocks;
    List<List<List<DateTime>>> blocksBlowTimes =
        blockController.blocksBlowTimes;
    PlayerController playerController = Get.find();
    List<int>? maxScoreIndex;
    double maxScore = double.minPositive; // Negatif skorlardan kaçınmak için

    for (var blockIndexes in accessibleBlocks.keys) {
      List<DateTime> blockBlowTimeRemainingList =
          blocksBlowTimes[blockIndexes[1]][blockIndexes[0]];

      if ((blockBlowTimeRemainingList.isNotEmpty &&
          blockBlowTimeRemainingList
              .any((val) => val.difference(DateTime.now()).inSeconds <= 1))) {
        continue;
      }

      bool hasPowerUp =
          blocks[blockIndexes[1]][blockIndexes[0]]?.powerUp != null;
      double score = hasPowerUp ? 5 : 0;
      int destructableBlockCount = 0;

      int enemyDamageScore = 0;

      for (int i = 0; i <= fireRange; i++) {
        if (blockIndexes[0] + i > 8) break;
        Block? b = blocks[blockIndexes[1]][blockIndexes[0] + i];
        for (int j = 0; j < playerController.players.length; j++) {
          Player p = playerController.players[j];
          if (p.id != playerID && !p.isDead) {
            if (((p.x.value >= blockIndexes[0] - 1 &&
                        p.x.value <= blockIndexes[0] + 1) &&
                    (p.y.value >= blockIndexes[1] - 1 &&
                        p.y.value <= blockIndexes[1] + 1)) ||
                ((p.x.value == blockIndexes[0] &&
                        p.y.value == blockIndexes[1]) ||
                    (p.x.value == blockIndexes[0] + i &&
                        p.y.value == blockIndexes[1]))) {
              enemyDamageScore += 5;
            }
          }
        }
        if (((b?.hasExplosion.value ?? false) == false) &&
            ((b?.isDestructible ?? false) == true)) {
          destructableBlockCount++;
        }
        if (blockIndexes[0] - i < 0) break;
        b = blocks[blockIndexes[1]][blockIndexes[0] - i];
        if (((b?.hasExplosion.value ?? false) == false) &&
            ((b?.isDestructible ?? false) == true)) {
          destructableBlockCount++;
        }
      }
      for (int i = 0; i <= fireRange; i++) {
        if (blockIndexes[1] + i > 8) break;
        Block? b = blocks[blockIndexes[1] + i][blockIndexes[0]];
        if (((b?.hasExplosion.value ?? false) == false) &&
            ((b?.isDestructible ?? false) == true)) {
          destructableBlockCount++;
        }
        if (blockIndexes[1] - i < 0) break;
        b = blocks[blockIndexes[1] - i][blockIndexes[0]];
        if (((b?.hasExplosion.value ?? false) == false) &&
            ((b?.isDestructible ?? false) == true)) {
          destructableBlockCount++;
        }
      }

      bool gonnaBlow = false;

      for (int i = 0; i < accessibleBlocks[blockIndexes]!.length; i++) {
        List<int> path = accessibleBlocks[blockIndexes]![i];
        bool pass = false;

        if (path.isNotEmpty) {
          List<DateTime> blowStartTimes = blocksBlowTimes[path[1]][path[0]];

          for (var blowTime in blowStartTimes) {
            Duration? timePassed = blowStartTimes.isNotEmpty
                ? blowTime.difference(DateTime.now())
                : null;

            if (timePassed == null) {
              continue;
            }

            DateTime blowStartTime = blowTime.add(Duration(seconds: 0));
            DateTime blowEndTime =
                blowTime.add(Duration(seconds: 1)); // 2 fitil, 1 patlama
            DateTime timeEnteredBlock =
                DateTime.now().add(Duration(milliseconds: i * 200));
            DateTime timeExitedBlock =
                DateTime.now().add(Duration(milliseconds: (i + 1) * 200));

            bool isHitByBlow = !(timeExitedBlock.isBefore(blowStartTime) ||
                timeEnteredBlock.isAfter(blowEndTime));

            if (isHitByBlow) {
              gonnaBlow = true;
            }

            if (blowStartTimes.isEmpty) {
              pass = true;
            }
          }
          if (pass) {
            continue;
          }
        }
      }

      if (gonnaBlow) {
        continue;
      }

      score += (destructableBlockCount * 2) + enemyDamageScore;
      -accessibleBlocks[blockIndexes]!.length / 2;

      if (score > maxScore) {
        maxScore = score;
        maxScoreIndex = blockIndexes;
      }
    }

    if (maxScoreIndex == null) {
      return null;
    }

    return maxScoreIndex;
  }

  // Version 4
  static List<int>? findBestBlock4(
      Map<List<int>, List<List<int>>?> accessibleBlocks,
      int fireRange,
      int playerID) {
    BlockController blockController = Get.find();
    blockController.update();
    List<List<Block?>> blocks = blockController.blocks;
    List<List<List<DateTime>>> blocksBlowTimes =
        blockController.blocksBlowTimes;
    PlayerController playerController = Get.find();
    List<int>? maxScoreIndex;
    double maxScore = double.minPositive; // Negatif skorlardan kaçınmak için

    for (var blockIndexes in accessibleBlocks.keys) {
      List<DateTime> blockBlowTimeRemainingList =
          blocksBlowTimes[blockIndexes[1]][blockIndexes[0]];

      if ((blockBlowTimeRemainingList.isNotEmpty &&
          blockBlowTimeRemainingList
              .any((val) => val.difference(DateTime.now()).inSeconds <= 1))) {
        continue;
      }

      bool hasPowerUp =
          blocks[blockIndexes[1]][blockIndexes[0]]?.powerUp != null;
      double score = hasPowerUp ? 5 : 0;
      int destructableBlockCount = 0;

      int enemyDamageScore = 0;

      for (int i = 0; i <= fireRange; i++) {
        if (blockIndexes[0] + i > 8) break;
        Block? b = blocks[blockIndexes[1]][blockIndexes[0] + i];
        for (int j = 0; j < playerController.players.length; j++) {
          Player p = playerController.players[j];
          if (p.id != playerID && !p.isDead) {
            if (((p.x.value >= blockIndexes[0] - 1 &&
                        p.x.value <= blockIndexes[0] + 1) &&
                    (p.y.value >= blockIndexes[1] - 1 &&
                        p.y.value <= blockIndexes[1] + 1)) ||
                ((p.x.value == blockIndexes[0] &&
                        p.y.value == blockIndexes[1]) ||
                    (p.x.value == blockIndexes[0] + i &&
                        p.y.value == blockIndexes[1]))) {
              enemyDamageScore += 5;
            }
          }
        }
        if (((b?.hasExplosion.value ?? false) == false) &&
            ((b?.isDestructible ?? false) == true)) {
          destructableBlockCount++;
        }
        if (blockIndexes[0] - i < 0) break;
        b = blocks[blockIndexes[1]][blockIndexes[0] - i];
        if (((b?.hasExplosion.value ?? false) == false) &&
            ((b?.isDestructible ?? false) == true)) {
          destructableBlockCount++;
        }
      }
      for (int i = 0; i <= fireRange; i++) {
        if (blockIndexes[1] + i > 8) break;
        Block? b = blocks[blockIndexes[1] + i][blockIndexes[0]];
        if (((b?.hasExplosion.value ?? false) == false) &&
            ((b?.isDestructible ?? false) == true)) {
          destructableBlockCount++;
        }
        if (blockIndexes[1] - i < 0) break;
        b = blocks[blockIndexes[1] - i][blockIndexes[0]];
        if (((b?.hasExplosion.value ?? false) == false) &&
            ((b?.isDestructible ?? false) == true)) {
          destructableBlockCount++;
        }
      }

      bool gonnaBlow = false;

      for (int i = 0; i < accessibleBlocks[blockIndexes]!.length; i++) {
        List<int> path = accessibleBlocks[blockIndexes]![i];
        bool pass = false;

        if (path.isNotEmpty) {
          List<DateTime> blowStartTimes = blocksBlowTimes[path[1]][path[0]];

          for (var blowTime in blowStartTimes) {
            Duration? timePassed = blowStartTimes.isNotEmpty
                ? blowTime.difference(DateTime.now())
                : null;

            if (timePassed == null) {
              continue;
            }

            DateTime blowStartTime = blowTime.add(Duration(seconds: 0));
            DateTime blowEndTime =
                blowTime.add(Duration(seconds: 1)); // 2 fitil, 1 patlama
            DateTime timeEnteredBlock =
                DateTime.now().add(Duration(milliseconds: i * 200));
            DateTime timeExitedBlock =
                DateTime.now().add(Duration(milliseconds: (i + 1) * 200));

            bool isHitByBlow = !(timeExitedBlock.isBefore(blowStartTime) ||
                timeEnteredBlock.isAfter(blowEndTime));

            if (isHitByBlow) {
              gonnaBlow = true;
            }

            if (blowStartTimes.isEmpty) {
              pass = true;
            }
          }
          if (pass) {
            continue;
          }
        }
      }

      if (gonnaBlow) {
        continue;
      }

      score += (destructableBlockCount * 2) + enemyDamageScore;
      -accessibleBlocks[blockIndexes]!.length / 2;

      if (score > maxScore) {
        maxScore = score;
        maxScoreIndex = blockIndexes;
      }
    }

    if (maxScoreIndex == null) {
      return null;
    }

    return maxScoreIndex;
  }
}
