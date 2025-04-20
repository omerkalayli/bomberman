import 'package:bomberman/entities/block.dart';
import 'package:flutter/material.dart';

class BlockWidget extends StatelessWidget {
  const BlockWidget({super.key, required this.block});

  final Block? block;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        color: Color.fromARGB(255, 143, 129, 129),
      ),
      child:
          //  block?.haveBomb ?? false
          //     ? Center(
          //         child: Container(
          //           color: Colors.black,
          //           decoration:
          //               BoxDecoration(borderRadius: BorderRadius.circular(99)),
          //           margin: EdgeInsets.all(20),
          //         ),
          //       )
          //     :
          block?.hasExplosion.value ?? false
              ? Center(
                  child: Container(
                    color: Colors.yellow,
                    margin: EdgeInsets.all(4),
                  ),
                )
              : block?.showPowerUp ?? false
                  ? block?.powerUp?.type == "fire"
                      ? Text("F")
                      : Text("B")
                  : Container(),
    );
  }
}
