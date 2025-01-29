import 'package:bomberman/block_controller.dart';
import 'package:bomberman/entities/block.dart';
import 'package:bomberman/widgets/block_destructable.dart';
import 'package:bomberman/widgets/block_undestructable.dart';
import 'package:bomberman/widgets/block_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
    final BlockController blockController = BlockController();

    useEffect(() {
      blockController.initBlocks();
      return null;
    });

    return Scaffold(
      backgroundColor: Color(0xff3E2723),
      body: Row(
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
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 9),
                    itemCount: 81,
                    itemBuilder: (context, index) {
                      int x = index ~/ 9;
                      int y = index % 9;
                      Block? block = blockController.blocks[x][y];
                      if (block == null) {
                        return BlockWidget();
                      }
                      if (block.isDestructible) {
                        return BlockDestructable();
                      } else {
                        return BlockUndestructable();
                      }
                    })),
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
                    height: 80,
                    child: Center(
                        child: Text(
                      "Bomberman",
                      style: TextStyle(color: Color(0xff3E2723), fontSize: 24),
                    )))
              ],
            ),
          )
        ],
      ),
    );
  }
}
