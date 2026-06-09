import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profil_controller.dart';
import '../game/game_catch_egg_page.dart';
import '../game/game_balance_egg_page.dart';
import 'chatbot_page.dart';
import 'exchange_page.dart';

class ProfilPage extends StatelessWidget {
  ProfilPage({Key? key}) : super(key: key);

  final ProfilController controller = Get.put(ProfilController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.orangeAccent,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Obx(() => Text(
              controller.username.value.toUpperCase(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )),
            Obx(() => Text(
              controller.role.value,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            )),
            const SizedBox(height: 32),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.gamepad, color: Colors.green),
              title: const Text('Mini Game: Tangkap Telur (Accelerometer)'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Get.to(() => GameCatchEggPage()),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.balance, color: Colors.blue),
              title: const Text('Mini Game: Seimbangkan Telur (Gyroscope)'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Get.to(() => GameBalanceEggPage()),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.orange),
              title: const Text('Asisten AI (Chatbot)'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Get.to(() => ChatbotPage()),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.currency_exchange, color: Colors.indigo),
              title: const Text('Konversi Kurs Penjualan'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Get.to(() => ExchangePage()),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () => controller.logout(),
            ),
          ],
        ),
      ),
    );
  }
}
