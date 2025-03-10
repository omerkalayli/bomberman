import 'package:bomberman/controllers/player_controller.dart';
import 'package:get/get.dart';

class GameController extends GetxController {
  PlayerController playerController = Get.find();

  GameState gameState = GameState.stop;

  void initGame() {
    playerController.initPlayers();
  }
}

enum GameState { onGoing, stop }
