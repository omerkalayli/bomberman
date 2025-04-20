import 'package:bomberman/algorithms/a_star_and_bakctracking.dart';
import 'package:bomberman/algorithms/bfs.dart';
import 'package:bomberman/algorithms/dfs.dart';
import 'package:bomberman/controllers/block_controller.dart';
import 'package:bomberman/controllers/player_controller.dart';
import 'package:bomberman/entities/player.dart';
import 'package:get/get.dart';

class Computer extends Player {
  Computer({required super.id, required super.x, required super.y});

  Map<List<int>, List<List<int>>>? accessibleBlocks;
  List<int>? bestBlock;
  Map<List<int>, List<List<int>>>? nearestSafePlace;

  // BFS veya DFS
  void findAccessibleBlocks(Algorithm alg) {
    if (alg == Algorithm.BFS) {
      accessibleBlocks = BFS.findAccessibleBlocksWithPath(x.value, y.value);
    } else if (alg == Algorithm.DFS) {
      accessibleBlocks = DFS.findAccessibleBlocksWithPath(x.value, y.value);
    }
  }

  void findBestBlockAStar(Algorithm alg) {
    if (accessibleBlocks?.isEmpty ?? true) {
      bestBlock = null;
    } else {
      if (alg == Algorithm.AStar1) {
        bestBlock = AStarAndBakctracking.findBestBlock1(
            accessibleBlocks ?? {}, fireBuffCount.value, id);
      } else if (alg == Algorithm.AStar2) {
        bestBlock = AStarAndBakctracking.findBestBlock2(
            accessibleBlocks ?? {}, fireBuffCount.value, id);
      }
    }
  }

  @override
  Future<void> moveTo(List<List<int>> path) async {
    BlockController blockController = Get.find();
    for (var turn in path) {
      if (turn[1] > y.value) {
        moveRight(blockController.blocks);
      }
      if (turn[1] < y.value) {
        moveLeft(blockController.blocks);
      }
      if (turn[0] < x.value) {
        moveUp(blockController.blocks);
      }
      if (turn[0] > x.value) {
        moveDown(blockController.blocks);
      }
      // findAccessibleBlocks();
      PlayerController playerController = Get.find();
      playerController.players.refresh();
      await Future.delayed(Duration(milliseconds: 200));
    }
  }

  void findNearestSafePlace() {
    nearestSafePlace = BFS.findNearestSafePlace(x.value, y.value);
  }

  void agentStart(Algorithm alg1, Algorithm alg2) async {
    BlockController blockController = Get.find();
    blockController.initExplosionIndexHandling();

    while (!isDead) {
      PlayerController playerController = Get.find();
      bool hasAliveOpponent =
          playerController.players.value.any((p) => p.id != id && !p.isDead);
      if (!hasAliveOpponent) {
        score.value += 10;
        break;
      }

      // 1. Geçerli durumu analiz et (Erişilebilir blokları hesapla)
      findAccessibleBlocks(alg1);

      // 2. En iyi hedef bloğu bul
      findBestBlockAStar(alg2);
      if (bestBlock == null) {
        await Future.delayed(Duration(milliseconds: 200));
        continue;
      }

      // 3. En iyi bloğa git
      if (accessibleBlocks != null) {
        if (accessibleBlocks![bestBlock] != null) {
          await moveTo(accessibleBlocks![bestBlock]!);
        }
      }

      // 4. Bombayı bırak
      while (bombBuffCount.value <= 0) {
        await Future.delayed(Duration(milliseconds: 200));
      }
      dropBomb();

      // 5. En yakın güvenli yere git
      findNearestSafePlace();
      if (nearestSafePlace?.isNotEmpty ?? false) {
        if (nearestSafePlace!.values.first.isNotEmpty) {
          await moveTo(nearestSafePlace!.values.first);
        }
      }
    }
  }
}

enum Algorithm { BFS, AStar1, AStar2, DFS }
