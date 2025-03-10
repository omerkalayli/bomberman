import 'package:bomberman/entities/power_up.dart';
import 'package:get/get.dart';

class Block {
  bool? isDestructible;
  final PowerUp? powerUp;
  bool? showPowerUp;
  final bool? haveBomb;
  final int? bomberID;
  RxBool hasExplosion = false.obs; // Sadece bu özellik reaktif olacak

  Block({
    this.isDestructible,
    this.powerUp,
    this.showPowerUp,
    this.haveBomb,
    this.bomberID,
    bool? hasExplosion,
  }) : hasExplosion = RxBool(hasExplosion ?? false); // Varsayılan false

  // copyWith fonksiyonunda sadece hasExplosion reaktif olacak
  Block copyWith({
    required int x,
    required int y,
    required bool isDestructible,
    required bool isBreakable,
    required bool showPowerUp,
    required bool haveBomb,
    PowerUp? powerUp,
    required bool hasExplosion,
  }) {
    return Block(
      isDestructible: isDestructible,
      powerUp: powerUp ?? this.powerUp,
      showPowerUp: showPowerUp,
      haveBomb: haveBomb,
      bomberID: bomberID,
      hasExplosion:
          hasExplosion, // Burada reaktif olmayan değer ataması yapıyoruz
    );
  }

  @override
  String toString() {
    return 'Block{isDestructible: $isDestructible, powerUp: $powerUp}';
  }
}
