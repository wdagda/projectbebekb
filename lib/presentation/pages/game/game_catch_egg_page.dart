import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/game_catch_controller.dart';

class GameCatchEggPage extends StatelessWidget {
  GameCatchEggPage({Key? key}) : super(key: key);

  final GameCatchController controller = Get.put(GameCatchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tangkap Telur')),
      body: Obx(() {
        if (!controller.isPlaying.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Skor Terakhir: ${controller.score.value}', style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.startGame,
                  child: const Text('Mulai Permainan'),
                )
              ],
            ),
          );
        }

        return Stack(
          children: [
            // Telur
            Align(
              alignment: Alignment(controller.eggX.value, controller.eggY.value),
              child: const Icon(Icons.egg, size: 40, color: Colors.orange),
            ),
            // Keranjang
            Align(
              alignment: Alignment(controller.basketPosition.value, 0.9),
              child: const Icon(Icons.shopping_basket, size: 80, color: Colors.brown),
            ),
            // Skor
            Positioned(
              top: 16,
              right: 16,
              child: Text('Skor: ${controller.score.value}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            )
          ],
        );
      }),
    );
  }
}
