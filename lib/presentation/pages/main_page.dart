import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import 'dashboard/dashboard_page.dart';
import 'kandang/kandang_page.dart';
import 'produksi/produksi_page.dart';
import 'stok/stok_page.dart';
import 'profil/profil_page.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final MainController controller = Get.put(MainController());

  // Placeholder untuk halaman lain
  final List<Widget> pages = [
    DashboardPage(),
    KandangPage(),
    ProduksiPage(),
    StokPage(),
    ProfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changePage,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.home_work), label: 'Kandang'),
          BottomNavigationBarItem(icon: Icon(Icons.egg), label: 'Produksi'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Stok'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      )),
    );
  }
}
