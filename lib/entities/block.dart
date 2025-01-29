import 'package:bomberman/entities/power_up.dart';

class Block {
  final bool isDestructible;
  final PowerUp? powerUp;

  Block({
    required this.isDestructible,
    this.powerUp,
  });

  Block copyWith({
    required int x,
    required int y,
    required bool isDestructible,
    required bool isBreakable,
    PowerUp? powerUp,
  }) {
    return Block(
      isDestructible: isDestructible,
      powerUp: powerUp ?? this.powerUp,
    );
  }

  @override
  String toString() {
    return 'Block{isDestructible: $isDestructible, powerUp: $powerUp}';
  }
}
