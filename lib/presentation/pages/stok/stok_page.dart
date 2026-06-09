import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/transaksi_controller.dart';

class StokPage extends StatelessWidget {
  StokPage({Key? key}) : super(key: key);

  final TransaksiController controller = Get.put(TransaksiController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manajemen Stok'),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Produk Olahan'),
              Tab(text: 'Stok Pakan (WIP)'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildProdukTab(context),
            const Center(child: Text('Fitur Stok Pakan (Segera hadir)')),
          ],
        ),
      ),
    );
  }

  Widget _buildProdukTab(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
      return ListView.builder(
        itemCount: controller.produkList.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final produk = controller.produkList[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.inventory, color: Colors.white)),
              title: Text(produk['nama_produk'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Tersedia: ${produk['stok']}'),
              trailing: PopupMenuButton<String>(
                onSelected: (val) {
                  if (val == 'tambah') _showTambahDialog(context, produk);
                  if (val == 'jual') _showJualDialog(context, produk);
                  if (val == 'konversi') _showKonversiDialog(context);
                },
                itemBuilder: (context) {
                  List<PopupMenuEntry<String>> items = [];
                  items.add(const PopupMenuItem(value: 'tambah', child: Text('Tambah Stok')));
                  items.add(const PopupMenuItem(value: 'jual', child: Text('Jual / Keluar')));
                  if (produk['nama_produk'] == 'Telur Bebek Mentah') {
                    items.add(const PopupMenuItem(value: 'konversi', child: Text('Konversi Produk')));
                  }
                  return items;
                },
              ),
            ),
          );
        },
      );
    });
  }

  void _showJualDialog(BuildContext context, Map produk) {
    final qtyCtrl = TextEditingController();
    Get.defaultDialog(
      title: 'Jual ${produk['nama_produk']}',
      content: TextField(
        controller: qtyCtrl,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Jumlah dijual', border: OutlineInputBorder()),
      ),
      textConfirm: 'Jual',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (qtyCtrl.text.isNotEmpty) {
          controller.catatPenjualan(produk['id'], int.parse(qtyCtrl.text));
          Get.back();
        }
      }
    );
  }

  void _showTambahDialog(BuildContext context, Map produk) {
    final qtyCtrl = TextEditingController();
    Get.defaultDialog(
      title: 'Tambah Stok ${produk['nama_produk']}',
      content: TextField(
        controller: qtyCtrl,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Jumlah ditambahkan', border: OutlineInputBorder()),
      ),
      textConfirm: 'Tambah',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (qtyCtrl.text.isNotEmpty) {
          controller.tambahStok(produk['id'], int.parse(qtyCtrl.text));
          Get.back();
        }
      }
    );
  }

  void _showKonversiDialog(BuildContext context) {
    final qtyCtrl = TextEditingController();
    String target = 'Telur Asin';
    Get.defaultDialog(
      title: 'Konversi Mentah',
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              TextField(
                controller: qtyCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Jumlah Mentah', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: target,
                items: const [
                  DropdownMenuItem(value: 'Telur Asin', child: Text('Ke Telur Asin')),
                  DropdownMenuItem(value: 'Kerupuk Telur Asin', child: Text('Ke Kerupuk Telur Asin')),
                ],
                onChanged: (v) => setState(() => target = v!),
              )
            ],
          );
        }
      ),
      textConfirm: 'Konversi',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (qtyCtrl.text.isNotEmpty) {
          controller.konversiProduk(int.parse(qtyCtrl.text), target);
        }
      }
    );
  }
}
