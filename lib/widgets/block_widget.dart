import 'package:flutter/material.dart';

class BlockWidget extends StatelessWidget {
  const BlockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xff1e1e1e),
      ),
    );
  }
}
