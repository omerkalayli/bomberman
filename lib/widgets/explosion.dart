import 'package:flutter/material.dart';

class Explosion extends StatelessWidget {
  const Explosion({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        color: Colors.yellow,
        margin: EdgeInsets.all(4),
      ),
    );
  }
}
