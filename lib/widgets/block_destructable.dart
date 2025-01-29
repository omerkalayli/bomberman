import 'package:flutter/material.dart';

class BlockDestructable extends StatelessWidget {
  const BlockDestructable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black, blurRadius: 2, offset: Offset(0, 2))
        ],
        color: Colors.brown,
      ),
    );
  }
}
