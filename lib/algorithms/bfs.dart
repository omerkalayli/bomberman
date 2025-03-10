import 'package:bomberman/controllers/block_controller.dart';
import 'package:bomberman/controllers/player_controller.dart';
import 'package:bomberman/entities/block.dart';
import 'package:bomberman/entities/player.dart';
import 'package:get/get.dart';

class BFS {
  // BFS kullanarak geçebileceği tüm blokları ve mesafeleri bulma
  static Map<List<int>, List<List<int>>> findAccessibleBlocksWithPath(
    int startX,
    int startY,
  ) {
    BlockController blockController = Get.find();
    List<List<Block?>> blocks = blockController.blocks.value;

    bool _isBlocked(int x, int y) {
      if (blocks[y][x] == null) return false;
      return blocks[y][x]?.hasExplosion.value == true ||
          blocks[y][x]?.isDestructible != null ||
          (blocks[y][x]?.haveBomb ?? false); // Eğer blok engelse, geçilemez
    }

    Map<List<int>, List<List<int>>> accessibleBlocksWithPath = {};
    List<List<bool>> visited =
        List.generate(9, (_) => List.generate(9, (_) => false));

    List<List<dynamic>> queue = [
      [
        startX,
        startY,
        [
          [startX, startY]
        ]
      ] // [x, y, yol]
    ];
    visited[startY][startX] = true;

    List<List<int>> directions = [
      [0, 1],
      [0, -1],
      [1, 0],
      [-1, 0],
    ];

    // BFS başlat
    while (queue.isNotEmpty) {
      List<dynamic> current = queue.removeAt(0);
      int x = current[0];
      int y = current[1];
      List<List<int>> currentPath = current[2];

      // Geçilebilir bir bloksa ve daha önce eklenmemişse, listeye ekle
      if (!_isBlocked(x, y) && !visited[y][x]) {
        accessibleBlocksWithPath[[x, y]] = currentPath;
        visited[y][x] = true; // Bu bloğu ziyaret ettik, burayı işaretle
      }

      // Komşuları kontrol et
      for (List<int> direction in directions) {
        int newX = x + direction[0];
        int newY = y + direction[1];

        // Eğer komşu geçerli bir alandaysa, daha önce ziyaret edilmediyse ve engel değilse
        if (newX >= 0 &&
            newX < 9 &&
            newY >= 0 &&
            newY < 9 &&
            !visited[newY][newX] &&
            !_isBlocked(newX, newY)) {
          List<List<int>> newPath = List.from(currentPath)..add([newX, newY]);
          queue.add([newX, newY, newPath]);
        }
      }
    }

    return accessibleBlocksWithPath;
  }

  static Map<List<int>, List<List<int>>> findNearestSafePlace(
    int startX,
    int startY,
  ) {
    BlockController blockController = Get.find();
    List<List<Block?>> blocks = blockController.blocks.value;
    PlayerController playerController = Get.find();
    bool _isBlocked(int x, int y) {
      if (blocks[y][x] == null) return false;

      return blocks[y][x]?.hasExplosion.value == true ||
          blocks[y][x]?.isDestructible != null ||
          (blocks[y][x]?.haveBomb ?? false);
    }

    Map<List<int>, List<List<int>>> accessibleBlocksWithPath = {};
    List<List<bool>> visited =
        List.generate(9, (_) => List.generate(9, (_) => false));

    List<List<dynamic>> queue = [
      [
        startX,
        startY,
        [
          [startX, startY]
        ]
      ]
    ];
    visited[startY][startX] = true;

    List<List<int>> directions = [
      [0, 1],
      [0, -1],
      [1, 0],
      [-1, 0],
    ];
    // İlk uygun bfs node'una gider.
    // BFS başlat
    while (queue.isNotEmpty) {
      List<dynamic> current = queue.removeAt(0);
      int x = current[0];
      int y = current[1];
      List<List<int>> currentPath = current[2];

      // Geçilebilir bir bloksa ve daha önce eklenmemişse, listeye ekle
      if (!_isBlocked(x, y) && !visited[y][x]) {
        accessibleBlocksWithPath[[x, y]] = currentPath;
        visited[y][x] = true; // Bu bloğu ziyaret ettik, burayı işaretle
      }

      // Komşuları kontrol et
      for (List<int> direction in directions) {
        int newX = x + direction[0];
        int newY = y + direction[1];

        // Eğer komşu geçerli bir alandaysa, daha önce ziyaret edilmediyse ve engel değilse
        if (newX >= 0 &&
            newX < 9 &&
            newY >= 0 &&
            newY < 9 &&
            !visited[newY][newX] &&
            !_isBlocked(newX, newY)) {
          List<List<int>> newPath = List.from(currentPath)..add([newX, newY]);
          queue.add([newX, newY, newPath]);
        }
      }
    }
    for (var finalLoc in accessibleBlocksWithPath.keys) {
      int x = finalLoc[0];
      int y = finalLoc[1];
      for (var bomb in blockController.droppedBombs) {
        int range = playerController
                .getPlayerByID(bomb.bomberID)
                ?.fireBuffCount
                .value ??
            0;
        bool canDie = false;
        for (int i = bomb.x; i <= bomb.x + range; i++) {
          if (x == i && bomb.y == y) {
            canDie = true;
          }
        }

// X pozisyonunda azalan yönde
        for (int i = bomb.x; i >= bomb.x - range; i--) {
          if (x == i && bomb.y == y) {
            canDie = true;
          }
        }

// Y pozisyonunda artan yönde
        for (int i = bomb.y; i <= bomb.y + range; i++) {
          if (y == i && bomb.x == x) {
            canDie = true;
          }
        }

// Y pozisyonunda azalan yönde
        for (int i = y; i >= y - range; i--) {
          if (y == i && bomb.x == x) {
            canDie = true;
          }
        }
        if (canDie) {
          return {finalLoc: accessibleBlocksWithPath[finalLoc]!};
        }
      }
    }
    return accessibleBlocksWithPath;
  }
}
