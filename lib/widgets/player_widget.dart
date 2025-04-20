import 'package:flutter/material.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({super.key, this.color, this.isDead});

  final Color? color;
  final bool? isDead;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.all(8),
      color: isDead ?? false
          ? Colors.transparent
          : (color ?? Colors.deepOrangeAccent).withValues(alpha: 0.5),
      child: isDead ?? false
          ? Icon(
              Icons.close,
              color: color,
              size: 48,
            )
          : null,
    );
  }
}
