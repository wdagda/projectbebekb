import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({Key? key}) : super(key: key);

  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Duck Farm', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.loadDashboardData();
          await controller.fetchWeather();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Cuaca
              Card(
                color: Colors.blue.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.cloud, size: 48, color: Colors.blue),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Info Cuaca Lokasi Kandang', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Obx(() => Text(controller.cuacaInfo.value, style: const TextStyle(fontSize: 16))),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Ringkasan Peternakan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              
              // Grid Ringkasan
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _buildSummaryCard(
                    title: 'Total Kandang',
                    value: controller.totalKandang,
                    icon: Icons.home_work,
                    color: Colors.brown,
                  ),
                  _buildSummaryCard(
                    title: 'Populasi Bebek',
                    value: controller.totalBebek,
                    icon: Icons.pets,
                    color: Colors.pink,
                  ),
                  _buildSummaryCard(
                    title: 'Produksi Hari Ini',
                    value: controller.totalProduksiHariIni,
                    icon: Icons.egg,
                    color: Colors.yellow.shade700,
                  ),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: InkWell(
                      onTap: () {
                        // TODO: Pindah ke tab produksi AI Prediksi
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.auto_graph, size: 36, color: Colors.green),
                            SizedBox(height: 8),
                            Text('Prediksi AI', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Ketuk untuk melihat', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required RxInt value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 8),
            Obx(() => Text(
              value.value.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
