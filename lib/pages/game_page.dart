import 'package:bomberman/controllers/block_controller.dart';
import 'package:bomberman/controllers/game_controlller.dart';
import 'package:bomberman/controllers/player_controller.dart';
import 'package:bomberman/entities/block.dart';
import 'package:bomberman/entities/computer.dart';
import 'package:bomberman/entities/player.dart';
import 'package:bomberman/widgets/block_destructable.dart';
import 'package:bomberman/widgets/block_undestructable.dart';
import 'package:bomberman/widgets/block_widget.dart';
import 'package:bomberman/widgets/bomb.dart';
import 'package:bomberman/widgets/bomb_power_up.dart';
import 'package:bomberman/widgets/explosion.dart';
import 'package:bomberman/widgets/fire_power_up.dart';
import 'package:bomberman/widgets/player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class GamePage extends StatefulHookWidget {
  const GamePage({super.key});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double mainPadding = 16;
    Color bgColor = Color(0xffD7BFA6);
    Color borderColor = Color(0xff704214);
    final BlockController blockController = Get.find();
    final PlayerController playerController = Get.find();
    final GameController gameController = Get.find();

    useEffect(() {
      playerController.initPlayers();
      blockController.initBlocks();

      return null;
    });

    return Scaffold(
      backgroundColor: Color(0xff3E2723),
      body: KeyboardListener(
          focusNode: FocusNode(),
          onKeyEvent: (event) => _handleKeyEvent(
              event, blockController.blocks, playerController, blockController),
          child: Obx(() {
            return Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(mainPadding),
                  child: Container(
                      width: height - mainPadding * 2,
                      height: height - mainPadding * 2,
                      decoration: BoxDecoration(
                        color: Color(0xff1e1e1e),
                        border: Border.all(width: 2, color: borderColor),
                      ),
                      child: Stack(
                        children: [
                          Board(blockController: blockController),
                          Objects(playerController: playerController),
                        ],
                      )),
                ),
                Container(
                  height: height - mainPadding * 2,
                  width: width - height - mainPadding,
                  decoration: BoxDecoration(
                      color: bgColor,
                      border: Border.all(width: 2, color: borderColor)),
                  child: Column(
                    children: [
                      Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Gap(8),
                              Center(
                                  child: Text(
                                "Bomberman",
                                style: TextStyle(
                                    color: Color(0xff3E2723), fontSize: 24),
                              )),
                              Gap(20),
                              InkWell(
                                onTap: () {
                                  gameController.startGame(
                                      Algorithm.BFS, Algorithm.AStar1);
                                },
                                child: Container(
                                  color: Color(0xff3E2723),
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "Play",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Gap(32),
                              Container(
                                color: Colors.black,
                                height: 2,
                              ),
                              Container(
                                width: double.infinity,
                                color: playerController.players[0].isDead
                                    ? Colors
                                        .grey.shade700 // Ölüm sonrası gri ton
                                    : Colors.redAccent.withOpacity(
                                        0.7), // Ölmeden önceki renk, biraz daha soluk
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  children: [
                                    Text(
                                      "Player 1\nBomba Sayısı: ${playerController.players[0].bombBuffCount}\nBomba Yayılımı: ${playerController.players[0].fireBuffCount}\nScore: ${playerController.players[0].score}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  width: double.infinity,
                                  color: Colors.black,
                                  height: 2),
                              Container(
                                width: double.infinity,
                                color: playerController.players[1].isDead
                                    ? Colors
                                        .grey.shade700 // Ölüm sonrası gri ton
                                    : Colors.green.withOpacity(
                                        0.7), // Ölmeden önceki renk, biraz daha soluk
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  children: [
                                    Text(
                                      "Player 2\nBomba Sayısı: ${playerController.players[1].bombBuffCount}\nBomba Yayılımı: ${playerController.players[1].fireBuffCount}\nScore: ${playerController.players[1].score}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  width: double.infinity,
                                  color: Colors.black,
                                  height: 2),
                              Container(
                                width: double.infinity,
                                color: playerController.players[2].isDead
                                    ? Colors
                                        .grey.shade700 // Ölüm sonrası gri ton
                                    : Colors.blueAccent.withOpacity(
                                        0.7), // Ölmeden önceki renk, biraz daha soluk
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  children: [
                                    Text(
                                      "Player 3\nBomba Sayısı: ${playerController.players[2].bombBuffCount}\nBomba Yayılımı: ${playerController.players[2].fireBuffCount}\nScore: ${playerController.players[2].score}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  width: double.infinity,
                                  color: Colors.black,
                                  height: 2),
                              Container(
                                width: double.infinity,
                                color: playerController.players[3].isDead
                                    ? Colors
                                        .grey.shade700 // Ölüm sonrası gri ton
                                    : Colors.amber.withOpacity(
                                        0.7), // Ölmeden önceki renk, biraz daha soluk
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  children: [
                                    Text(
                                      "Player 4\nBomba Sayısı: ${playerController.players[3].bombBuffCount}\nBomba Yayılımı: ${playerController.players[3].fireBuffCount}\nScore: ${playerController.players[3].score}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                color: Colors.black,
                                height: 2,
                              ),
                            ],
                          ))
                    ],
                  ),
                )
              ],
            );
          })),
    );
  }

  bool isKeyPressed1 = false; // Tuşa basıldığını takip etmek için bir flag
  bool isKeyPressed2 = false; // Tuşa basıldığını takip etmek için bir flag

  // Bir veya iki oyuncu insansa eger klavye girisleri buradan dinlenir

  void _handleKeyEvent(KeyEvent event, RxList<List<Block?>> blocks,
      PlayerController controller, BlockController blockController) {
    Player me = controller.players[0];
    Player me2 = controller.players[3];

    // Player 1 için tuş işleme
    if (event is KeyDownEvent && !isKeyPressed1) {
      isKeyPressed1 = true;

      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        me.moveRight(blocks);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        me.moveLeft(blocks);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        me.moveDown(blocks);
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        me.moveUp(blocks);
      } else if (event.logicalKey == LogicalKeyboardKey.keyL) {
        me.dropBomb();
      }
    } else if (event is KeyUpEvent) {
      isKeyPressed1 = false; // Player 1 için tuş bırakıldığında flag'i sıfırla
    }

    // Player 2 için tuş işleme
    if (event is KeyDownEvent && !isKeyPressed2) {
      isKeyPressed2 = true;

      if (event.logicalKey == LogicalKeyboardKey.keyD) {
        me2.moveRight(blocks);
      } else if (event.logicalKey == LogicalKeyboardKey.keyA) {
        me2.moveLeft(blocks);
      } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
        me2.moveDown(blocks);
      } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
        me2.moveUp(blocks);
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        me2.dropBomb();
      }
    } else if (event is KeyUpEvent) {
      isKeyPressed2 = false; // Player 2 için tuş bırakıldığında flag'i sıfırla
    }

    // PlayerController'ı güncelle
    PlayerController playerController = Get.find();
    playerController.players.refresh();
  }
}

class Objects extends StatelessWidget {
  const Objects({
    super.key,
    required this.playerController,
  });

  final PlayerController playerController;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 9),
        itemCount: 81,
        itemBuilder: (context, index) {
          int x = index ~/ 9;
          int y = index % 9;
          for (Player p in playerController.players) {
            Color color;

            if (p.id == 0) {
              color = Colors.green;
            } else if (p.id == 1) {
              color = Colors.redAccent;
            } else if (p.id == 2) {
              color = Colors.blueAccent;
            } else {
              color = Colors.amber;
            }
            if (p.x.value == x && p.y.value == y) {
              return PlayerWidget(
                color: color,
                isDead: p.isDead,
              );
            }
          }
          return Container();
        });
  }
}

class Board extends StatelessWidget {
  const Board({
    super.key,
    required this.blockController,
  });

  final BlockController blockController;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 9),
        itemCount: 81,
        itemBuilder: (context, index) {
          int x = index ~/ 9;
          int y = index % 9;
          Block? block = blockController.blocks[y][x];

          if (block?.haveBomb ?? false) {
            return BombWidget();
          }
          if (block?.hasExplosion.value ?? false) {
            return Explosion();
          }
          if (block?.showPowerUp ?? false == true && block?.powerUp != null) {
            return block?.powerUp?.type == "bomb"
                ? BombPowerUp()
                : FirePowerUp();
          }
          if (block == null) {
            return BlockWidget(
              block: block,
            );
          }
          if (block.isDestructible ?? false) {
            return BlockDestructable();
          } else {
            return BlockUndestructable();
          }
        });
  }
}
