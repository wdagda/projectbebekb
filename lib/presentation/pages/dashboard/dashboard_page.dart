import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';
import '../ai/ai_page.dart';

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
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Obx(() => Text(
                controller.currentTimeWIB.value,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )),
            ),
          )
        ],
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
                        Get.to(() => AiPage());
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
              const SizedBox(height: 24),

              // Preview Kandang
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Preview Kandang', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      // Ini bisa dihubungkan ke navigasi tab Kandang di MainPage jika diperlukan.
                    },
                    child: const Text('Lihat Semua'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Obx(() {
                if (controller.previewKandang.isEmpty) {
                  return const Text('Belum ada data kandang.');
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.previewKandang.length,
                  itemBuilder: (context, index) {
                    final k = controller.previewKandang[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.home_work, color: Colors.brown),
                        title: Text(k['nama_kandang'] ?? 'Kandang'),
                        subtitle: Text('Populasi: ${k['populasi'] ?? 0} Ekor'),
                      ),
                    );
                  },
                );
              }),
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
