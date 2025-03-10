import 'package:bomberman/controllers/block_controller.dart';
import 'package:bomberman/entities/block.dart';
import 'package:get/get.dart';

class AStar {
  static List<int> findBestBlock(
      Map<List<int>, List<List<int>>> accessibleBlocks, int fireRange) {
    BlockController blockController = Get.find();
    List<List<Block?>> blocks = blockController.blocks;
    List<int> maxScoreIndex = accessibleBlocks.keys.first;
    double maxScore = -1;

    for (var blockIndexes in accessibleBlocks.keys) {
      int destructableBlockCount = 0;
      for (int i = 0; i <= fireRange; i++) {
        if (blockIndexes[0] + i > 8) break;
        Block? b = blocks[blockIndexes[0] + i][blockIndexes[1]];
        if (((b?.hasExplosion.value ?? false) == false) &&
            ((b?.isDestructible ?? false) == true)) {
          destructableBlockCount++;
        }
        if (blockIndexes[0] - i < 0) break;
        b = blocks[blockIndexes[0] - i][blockIndexes[1]];
        if (((b?.hasExplosion.value ?? false) == false) &&
            ((b?.isDestructible ?? false) == true)) {
          destructableBlockCount++;
        }
      }
      for (int i = 0; i <= fireRange; i++) {
        if (blockIndexes[1] + i > 8) break;
        Block? b = blocks[blockIndexes[0]][blockIndexes[1] + i];
        if (((b?.hasExplosion.value ?? false) == false) &&
            ((b?.isDestructible ?? false) == true)) {
          destructableBlockCount++;
        }
        if (blockIndexes[1] - i < 0) break;
        b = blocks[blockIndexes[0]][blockIndexes[1] - i];
        if (((b?.hasExplosion.value ?? false) == false) &&
            ((b?.isDestructible ?? false) == true)) {
          destructableBlockCount++;
        }
      }
      double score = (1 /
          (accessibleBlocks[blockIndexes]?.length ?? -1) *
          destructableBlockCount);

      if (score > maxScore) {
        maxScore = score;
        maxScoreIndex = blockIndexes;
      }
    }

    return maxScoreIndex;
  }
}
