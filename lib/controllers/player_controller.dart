import 'package:bomberman/entities/computer.dart';
import 'package:bomberman/entities/player.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PlayerController extends GetxController {
  RxList<Player> players = <Player>[].obs;

  @override
  void onInit() {
    super.onInit();
    initPlayers();
  }

  void initPlayers() {
    players.assignAll([
      Player(id: 0, x: 0.obs, y: 0.obs),
      Computer(id: 1, x: 0.obs, y: 8.obs),
      Computer(id: 2, x: 8.obs, y: 0.obs),
      Computer(id: 3, x: 8.obs, y: 8.obs),
    ]);
  }

  Player? getPlayerByID(int id) {
    return players.firstWhereOrNull((player) => player.id == id);
  }

  Player? returnPlayer(int x, int y) {
    return players.firstWhereOrNull(
        (player) => player.x.value == x && player.y.value == y);
  }
}
