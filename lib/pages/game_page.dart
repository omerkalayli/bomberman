import 'package:bomberman/algorithms/bfs.dart';
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
import 'package:collection/collection.dart';

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

    useEffect(() {
      playerController.initPlayers();
      blockController.initBlocks();

      // (playerController.players.value[1] as Computer).agentStart();
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
                          GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 9),
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
                                if (block?.showPowerUp ??
                                    false == true && block?.powerUp != null) {
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
                              }),
                          GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 9),
                              itemCount: 81,
                              itemBuilder: (context, index) {
                                int x = index ~/ 9;
                                int y = index % 9;

                                for (Player p in playerController.players) {
                                  if (p.x == x && p.y == y) {
                                    return PlayerWidget(
                                      color: p.id == -1 ? Colors.green : null,
                                      isDead: p.isDead,
                                    );
                                  }
                                }
                                return Container();
                              }),
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
                              Center(
                                  child: Text(
                                "Bomberman",
                                style: TextStyle(
                                    color: Color(0xff3E2723), fontSize: 24),
                              )),
                              Gap(16),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  color: Color(0xff3E2723),
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "Oyna",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Gap(8),
                              InkWell(
                                onTap: () {
                                  playerController.initPlayers();
                                  blockController.initBlocks();
                                },
                                child: Container(
                                  color: Color(0xff3E2723),
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    "Yeniden Başlat",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Gap(8),
                              Divider(
                                color: Colors.black,
                                thickness: 2,
                              ),
                              Text(
                                  "P0\nBomba Sayısı: ${playerController.players[0].bombBuffCount}\nBomba Yayılımı: ${playerController.players[0].fireBuffCount}"),
                              Gap(8),
                              Divider(
                                color: Colors.black,
                                thickness: 2,
                              ),
                              Text(
                                  "P1\nBomba Sayısı: ${playerController.players[0].bombBuffCount}\nBomba Yayılımı: ${playerController.players[0].fireBuffCount}"),
                              Gap(8),
                              Divider(
                                color: Colors.black,
                                thickness: 2,
                              ),
                              Text(
                                  "P2\nBomba Sayısı: ${playerController.players[1].bombBuffCount}\nBomba Yayılımı: ${playerController.players[1].fireBuffCount}"),
                              Gap(8),
                              Divider(
                                color: Colors.black,
                                thickness: 2,
                              ),
                              Text(
                                  "P3\nBomba Sayısı: ${playerController.players[2].bombBuffCount}\nBomba Yayılımı: ${playerController.players[2].fireBuffCount}"),
                              Gap(8),
                              Divider(
                                color: Colors.black,
                                thickness: 2,
                              ),
                              // Text(
                              //     "Oyuncu Koordinatlar:\n(${playerController.players[0].x.value},${playerController.players[0].y.value})"),
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

  void _handleKeyEvent(KeyEvent event, RxList<List<Block?>> blocks,
      PlayerController controller, BlockController blockController) {
    Player me = controller.players[0];
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      me.moveRight(blocks);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      me.moveLeft(blocks);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      me.moveDown(blocks);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      me.moveUp(blocks);
    } else if (event.logicalKey == LogicalKeyboardKey.space) {
      me.dropBomb();
    }
  }
}
