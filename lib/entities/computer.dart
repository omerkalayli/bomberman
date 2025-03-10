import 'package:bomberman/algorithms/a_star.dart';
import 'package:bomberman/algorithms/bfs.dart';
import 'package:bomberman/controllers/block_controller.dart';
import 'package:bomberman/entities/player.dart';
import 'package:get/get.dart';

class Computer extends Player {
  Computer({required super.id, required super.x, required super.y});

  Map<List<int>, List<List<int>>>? accessibleBlocks;
  List<int>? bestBlock;
  Map<List<int>, List<List<int>>>? nearestSafePlace;

  // BFS
  void findAccessibleBlocks() {
    accessibleBlocks = BFS.findAccessibleBlocksWithPath(x.value, y.value);
  }

  void findBestAStarBlock() {
    bestBlock =
        AStar.findBestBlock(accessibleBlocks ?? {}, fireBuffCount.value);
    // print("${bestBlock![0]}, ${bestBlock![1]}");
  }

  @override
  Future<void> moveTo(List<List<int>> path) async {
    BlockController blockController = Get.find();
    for (var turn in path) {
      if (turn[1] > y.value) {
        moveUp(blockController.blocks);
      }
      if (turn[1] < y.value) {
        moveDown(blockController.blocks);
      }
      if (turn[0] < x.value) {
        moveRight(blockController.blocks);
      }
      if (turn[0] > x.value) {
        moveLeft(blockController.blocks);
      }
      findAccessibleBlocks();
      await Future.delayed(Duration(milliseconds: 200));
    }
  }

  void findNearestSafePlace() {
    nearestSafePlace = BFS.findNearestSafePlace(x.value, y.value);
  }

  void agentStart() async {
    while (true) {
      // 1. Geçerli durumu analiz et (Erişilebilir blokları hesapla)
      findAccessibleBlocks();

      // 2. En iyi hedef bloğu bul
      findBestAStarBlock();

      // 3. En iyi bloğa git
      if (accessibleBlocks != null) {
        if (accessibleBlocks![bestBlock] != null) {
          await moveTo(accessibleBlocks![bestBlock]!);
        }
      }

      // 4. Bombayı bırak
      dropBomb();

      // 5. Wn yakın güvenli yere git
      findNearestSafePlace();
      List<List<int>> path = nearestSafePlace!.values.first;
      await moveTo(path);

      // 5. Bir süre bekle ve tekrar kontrol et
      await Future.delayed(Duration(
          milliseconds: 500)); // 500ms bekleyerek döngüyü tekrar başlat
    }
  }
}
