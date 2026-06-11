import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/populasi_controller.dart';
import '../../../data/models/kandang_model.dart';

class RiwayatPopulasiPage extends StatelessWidget {
  final Kandang kandang;
  RiwayatPopulasiPage({Key? key, required this.kandang}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Unique tag agar controller tidak konflik jika pindah-pindah kandang
    final PopulasiController controller = Get.put(PopulasiController(kandang.id!), tag: kandang.id.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('Populasi: ${kandang.namaKandang}'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            color: Colors.pink.shade50,
            child: Column(
              children: [
                const Text('Total Bebek Saat Ini', style: TextStyle(fontSize: 16, color: Colors.black54)),
                const SizedBox(height: 8),
                Obx(() => Text('${controller.totalPopulasi.value} Ekor', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.pink))),
                Text('Kapasitas Kandang: ${kandang.kapasitas}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
              if (controller.riwayatPopulasi.isEmpty) return const Center(child: Text('Belum ada riwayat populasi.'));
              
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.riwayatPopulasi.length,
                itemBuilder: (context, index) {
                  final data = controller.riwayatPopulasi[index];
                  bool isMasuk = data['jenis_mutasi'] == 'Masuk';
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isMasuk ? Colors.green.shade100 : Colors.red.shade100,
                        child: Icon(
                          isMasuk ? Icons.arrow_downward : Icons.arrow_upward,
                          color: isMasuk ? Colors.green : Colors.red,
                        ),
                      ),
                      title: Text('${data['jenis_mutasi']} - ${data['keterangan'] ?? ''}'),
                      subtitle: Text(data['tanggal_input'].toString().split('T').join(' ').substring(0, 16)),
                      trailing: Text(
                        '${isMasuk ? '+' : '-'}${data['jumlah_bebek']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isMasuk ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showMutasiDialog(context, controller),
        label: const Text('Input Bebek', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.pink,
      ),
    );
  }

  void _showMutasiDialog(BuildContext context, PopulasiController controller) {
    final qtyCtrl = TextEditingController();
    final ketCtrl = TextEditingController();
    String jenis = 'Masuk';

    Get.defaultDialog(
      title: 'Input Populasi Bebek',
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: jenis,
                items: const [
                  DropdownMenuItem(value: 'Masuk', child: Text('Bebek Masuk (Beli/Tetas)')),
                  DropdownMenuItem(value: 'Keluar', child: Text('Bebek Keluar (Jual/Afkir)')),
                  DropdownMenuItem(value: 'Mati', child: Text('Bebek Mati')),
                ],
                onChanged: (v) => setState(() => jenis = v!),
                decoration: const InputDecoration(labelText: 'Jenis Mutasi', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: qtyCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Jumlah Ekor', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ketCtrl,
                decoration: const InputDecoration(labelText: 'Keterangan (Opsional)', border: OutlineInputBorder()),
              ),
            ],
          );
        }
      ),
      textConfirm: 'Simpan',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (qtyCtrl.text.isNotEmpty) {
          controller.tambahRiwayat(jenis, int.parse(qtyCtrl.text), ketCtrl.text);
        }
      }
    );
  }
}
