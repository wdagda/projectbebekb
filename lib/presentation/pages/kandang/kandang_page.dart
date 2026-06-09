import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/kandang_controller.dart';
import 'kandang_form_page.dart';
import 'kandang_map_page.dart';

class KandangPage extends StatelessWidget {
  KandangPage({Key? key}) : super(key: key);

  final KandangController controller = Get.put(KandangController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Kandang'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.kandangList.isEmpty) {
          return const Center(child: Text('Belum ada data kandang'));
        }
        return ListView.builder(
          itemCount: controller.kandangList.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            final kandang = controller.kandangList[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.home_work, color: Colors.white),
                ),
                title: Text(kandang.namaKandang, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Kapasitas: ${kandang.kapasitas} Bebek'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.map, color: Colors.blue),
                      onPressed: () {
                        Get.to(() => KandangMapPage(kandang: kandang));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.deleteKandang(kandang.id!),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => KandangFormPage()),
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
