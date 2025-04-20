import 'package:bomberman/controllers/block_controller.dart';
import 'package:bomberman/controllers/player_controller.dart';
import 'package:bomberman/entities/block.dart';
import 'package:get/get.dart';

class DFS {
  // DFS kullanarak geçebileceği tüm blokları ve mesafeleri bulma
  static Map<List<int>, List<List<int>>> findAccessibleBlocksWithPath(
    int startX,
    int startY,
  ) {
    BlockController blockController = Get.find();
    List<List<Block?>> blocks = blockController.blocks;

    bool _isBlocked(int x, int y) {
      if (blocks[y][x] == null) return false;
      return blocks[y][x]?.hasExplosion.value == true ||
          blocks[y][x]?.isDestructible != null ||
          (blocks[y][x]?.haveBomb ?? false); // Eğer blok engelse, geçilemez
    }

    Map<List<int>, List<List<int>>> accessibleBlocksWithPath = {};
    List<List<bool>> visited =
        List.generate(9, (_) => List.generate(9, (_) => false));

    List<List<int>> directions = [
      [0, 1],
      [0, -1],
      [1, 0],
      [-1, 0],
    ];

    // DFS için stack
    List<List<dynamic>> stack = [
      [
        startX,
        startY,
        [
          [startX, startY]
        ]
      ] // [x, y, yol]
    ];
    visited[startY][startX] = true;

    // DFS başlat
    while (stack.isNotEmpty) {
      List<dynamic> current = stack.removeLast();
      int x = current[0];
      int y = current[1];
      List<List<int>> currentPath = current[2];

      // Geçilebilir bir bloksa ve daha önce eklenmemişse, listeye ekle
      if (!_isBlocked(x, y) && !visited[y][x]) {
        accessibleBlocksWithPath[[x, y]] = currentPath;
        visited[y][x] = true; // Ziyeret edilen blogu isaretle
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
          List<List<int>> newPath = List.from(currentPath);
          newPath.add([newX, newY]);
          stack.add([newX, newY, newPath]); // Stacke ekle
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
    List<List<Block?>> blocks = blockController.blocks;
    PlayerController playerController = Get.find();

    bool _isBlocked(int x, int y) {
      if (blocks[y][x] == null) return false;
      return blocks[y][x]?.hasExplosion.value == true ||
          blocks[y][x]?.isDestructible != null ||
          (blocks[y][x]?.haveBomb ?? false);
    }

    List<List<bool>> visited =
        List.generate(9, (_) => List.generate(9, (_) => false));

    List<List<int>> directions = [
      [0, 1], // Aşağı
      [0, -1], // Yukarı
      [1, 0], // Sağ
      [-1, 0], // Sol
    ];

    // DFS için stack kullanıyoruz
    List<List<dynamic>> stack = [
      [
        startX,
        startY,
        [
          [startX, startY]
        ]
      ] // [x, y, yol]
    ];
    visited[startY][startX] = true;

    while (stack.isNotEmpty) {
      List<dynamic> current = stack.removeLast();
      int x = current[0];
      int y = current[1];
      List<List<int>> currentPath = List<List<int>>.from(current[2]);

      // Buraya kadar geldiyse, güvenli bir yerse en kısa yolu döndür
      bool isSafe = true;
      for (var bomb in blockController.droppedBombs) {
        int range = playerController
                .getPlayerByID(bomb.bomberID)
                ?.fireBuffCount
                .value ??
            0;

        // Bomba menzilinde mi?
        if ((bomb.x == x && (bomb.y - range <= y && y <= bomb.y + range)) ||
            (bomb.y == y && (bomb.x - range <= x && x <= bomb.x + range))) {
          isSafe = false;
          break;
        }
      }

      if (isSafe) {
        return {
          [x, y]: currentPath
        };
      }

      // Komşuları sıraya ekle
      for (List<int> direction in directions) {
        int newX = x + direction[0];
        int newY = y + direction[1];

        if (newX >= 0 &&
            newX < 9 &&
            newY >= 0 &&
            newY < 9 &&
            !visited[newY][newX] &&
            !_isBlocked(newX, newY)) {
          visited[newY][newX] = true;
          List<List<int>> newPath = List.from(currentPath);
          newPath.add([newX, newY]);
          stack.add([newX, newY, newPath]); // Yığınına ekle
        }
      }
    }

    return {};
  }
}
