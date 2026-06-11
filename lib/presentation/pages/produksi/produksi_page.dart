import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/produksi_controller.dart';

class ProduksiPage extends StatelessWidget {
  ProduksiPage({Key? key}) : super(key: key);

  final ProduksiController controller = Get.put(ProduksiController());
  final _qtyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Produksi Telur'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Pilih Kandang Asal:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Obx(() => DropdownButtonFormField<int>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              value: controller.selectedKandangId.value,
              items: controller.kandangList.map((k) {
                return DropdownMenuItem<int>(
                  value: k.id,
                  child: Text(k.namaKandang),
                );
              }).toList(),
              onChanged: (val) => controller.selectedKandangId.value = val,
              hint: const Text('Pilih Kandang'),
            )),
            const SizedBox(height: 24),
            const Text('Jumlah Telur Mentah (Butir):', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.egg),
              ),
            ),
            const SizedBox(height: 32),
            Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value ? null : () async {
                if (_qtyController.text.isNotEmpty) {
                  await controller.catatProduksi(int.parse(_qtyController.text));
                  _qtyController.clear();
                  controller.selectedKandangId.value = null;
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.pink,
              ),
              child: controller.isLoading.value 
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Simpan Produksi', style: TextStyle(color: Colors.white, fontSize: 16)),
            )),
            const SizedBox(height: 24),
            const Card(
              color: Colors.lightGreen,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Info: Saat disimpan, stok "Telur Bebek Mentah" pada menu Stok akan bertambah secara otomatis.', style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
