import 'package:flutter/material.dart';

class BombWidget extends StatelessWidget {
  const BombWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 143, 129, 129),
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
        margin: EdgeInsets.all(12),
      ),
    );
  }
}
