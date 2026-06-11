import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/game_balance_controller.dart';

class GameBalanceEggPage extends StatelessWidget {
  GameBalanceEggPage({Key? key}) : super(key: key);

  final GameBalanceController controller = Get.put(GameBalanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seimbangkan Telur')),
      body: Center(
        child: Obx(() {
          if (!controller.isPlaying.value) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Waktu Bertahan: ${controller.survivalTime.value} detik', style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Text('Aturan: Jaga smartphone Anda sekokoh mungkin. Jika rotasi terlalu cepat, telur akan pecah.', textAlign: TextAlign.center),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: controller.startGame,
                  child: const Text('Mulai Permainan'),
                )
              ],
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${controller.survivalTime.value} dtk', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(height: 32),
              // Animasi sederhana
              TweenAnimationBuilder(
                tween: Tween<double>(begin: -0.1, end: 0.1),
                duration: const Duration(seconds: 1),
                builder: (context, double val, child) {
                  return Transform.rotate(
                    angle: val,
                    child: child,
                  );
                },
                child: const Icon(Icons.egg, size: 100, color: Colors.pink),
              ),
              const SizedBox(height: 32),
              const Text('Awas jangan sampai goyang!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ],
          );
        }),
      ),
    );
  }
}
