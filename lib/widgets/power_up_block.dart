import 'package:flutter/material.dart';

class PowerUpBlock extends StatefulWidget {
  const PowerUpBlock({super.key});

  @override
  State<PowerUpBlock> createState() => _PowerUpBlockState();
}

class _PowerUpBlockState extends State<PowerUpBlock> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset("bomberman/images/bomb.svg"),
    );
  }
}
