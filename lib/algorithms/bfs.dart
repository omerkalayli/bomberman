import 'dart:collection';

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
          List<List<int>> newPath =
              List.from(currentPath); // Burada currentPath'ı doğrudan kopyala
          newPath.add([newX, newY]); // Yeni koordinat ekle
          queue.add([newX, newY, newPath]); // Sıraya ekle
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

    List<List<bool>> visited =
        List.generate(9, (_) => List.generate(9, (_) => false));
    Queue<List<dynamic>> queue = Queue();

    List<List<int>> directions = [
      [0, 1], // Aşağı
      [0, -1], // Yukarı
      [1, 0], // Sağ
      [-1, 0], // Sol
    ];

    // Eğer başlangıç noktası tehlikeliyse burayı hemen işaretle
    // if (_isBlocked(startX, startY)) {
    //   return {};
    // }

    visited[startY][startX] = true;

    // Başlangıç noktasını ekleme, sadece komşuları sıraya ekle
    for (List<int> direction in directions) {
      int newX = startX + direction[0];
      int newY = startY + direction[1];

      if (newX >= 0 &&
          newX < 9 &&
          newY >= 0 &&
          newY < 9 &&
          !_isBlocked(newX, newY)) {
        visited[newY][newX] = true;
        // `path`'i açıkça List<List<int>> olarak belirtiyoruz.
        queue.add([
          newX,
          newY,
          [
            [newX, newY]
          ] // Path başlangıç noktasını içerir
        ]);
      }
    }

    while (queue.isNotEmpty) {
      var current = queue.removeFirst();
      int x = current[0];
      int y = current[1];
      // Burada `current[2]`'yi `List<List<int>>` olarak doğru bir şekilde alıyoruz
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
          queue.add([
            newX,
            newY,
            List.from(currentPath)..add([newX, newY])
          ]);
        }
      }
    }

    return {};
  }
}
