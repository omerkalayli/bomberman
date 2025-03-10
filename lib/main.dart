import 'package:bomberman/controllers/block_controller.dart';
import 'package:bomberman/controllers/game_controlller.dart';
import 'package:bomberman/controllers/player_controller.dart';
import 'package:bomberman/pages/game_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(
        PlayerController()); // TODO: bunları putlamaıd bir sıkıntı var sanırsam
    Get.put(BlockController());
    Get.put(GameController());
    GameController().initGame();
    return MaterialApp(
      title: 'Bomberman',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // textTheme: GoogleFonts.pressStart2pTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: GamePage(),
    );
  }
}
