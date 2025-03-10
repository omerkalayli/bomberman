import 'package:flutter/material.dart';

class BombPowerUp extends StatelessWidget {
  const BombPowerUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 143, 129, 129),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Center(
          child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(4),
            child: Text(
              "💣",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Positioned(
            left: 0,
            top: -5,
            child: Text(
              "+",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      )),
    );
  }
}
