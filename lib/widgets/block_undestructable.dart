import 'package:bomberman/widgets/block_widget.dart';
import 'package:flutter/material.dart';

class BlockUndestructable extends StatelessWidget {
  const BlockUndestructable({super.key});

  @override
  Widget build(BuildContext context) {
    Color bgColor = Color.fromARGB(255, 63, 78, 82);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: Colors.black),
        color: bgColor,
      ),
    );
  }
}
