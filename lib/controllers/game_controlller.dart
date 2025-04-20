import 'package:bomberman/controllers/block_controller.dart';
import 'package:bomberman/controllers/player_controller.dart';
import 'package:bomberman/entities/computer.dart';
import 'package:get/get.dart';

class GameController extends GetxController {
  PlayerController playerController = Get.find();
  GameState gameState = GameState.stop;
  BlockController blockController = Get.find();

  void startGame(Algorithm alg1, Algorithm alg2) {
    blockController.initBlocks();
    blockController.refresh();
    initGame();
    playerController.players.refresh();
    gameState = GameState.onGoing;
    // (playerController.players[0] as Computer)
    //     .agentStart(Algorithm.BFS, Algorithm.AStar2);
    (playerController.players[1] as Computer)
        .agentStart(Algorithm.BFS, Algorithm.AStar1);
    (playerController.players[2] as Computer)
        .agentStart(Algorithm.BFS, Algorithm.AStar1);
    // (playerController.players[3] as Computer)
    //     .agentStart(Algorithm.DFS, Algorithm.AStar2);
    playerController.players.refresh();
  }

  void finishGame() {
    gameState = GameState.finished;
    playerController.players.refresh();
  }

  void initGame() {
    playerController.initPlayers();
  }
}

enum GameState { onGoing, stop, finished }
