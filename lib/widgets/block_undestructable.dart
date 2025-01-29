import 'package:bomberman/widgets/block_widget.dart';
import 'package:flutter/material.dart';

class BlockUndestructable extends BlockWidget {
  const BlockUndestructable({super.key});

  @override
  Widget build(BuildContext context) {
    Color bgColor = Color(0xff7A3B3A);
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 4, color: Colors.black),
        color: bgColor,
      ),
    );
  }
}
