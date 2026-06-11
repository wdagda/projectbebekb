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
          backgroundColor: Colors.pink,
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
            _buildPakanTab(context),
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
                  if (val == 'konversi') _showKonversiDialog(context, produk);
                },
                itemBuilder: (context) {
                  List<PopupMenuEntry<String>> items = [];
                  items.add(const PopupMenuItem(value: 'tambah', child: Text('Tambah Stok')));
                  items.add(const PopupMenuItem(value: 'jual', child: Text('Jual / Keluar')));
                  if (produk['nama_produk'] == 'Telur Bebek Mentah' || produk['nama_produk'] == 'Telur Asin') {
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

  void _showKonversiDialog(BuildContext context, Map produk) {
    final qtyCtrl = TextEditingController();
    bool isMentah = produk['nama_produk'] == 'Telur Bebek Mentah';
    String target = isMentah ? 'Telur Asin' : 'Kerupuk Telur Asin';
    
    Get.defaultDialog(
      title: 'Konversi ${produk['nama_produk']}',
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              TextField(
                controller: qtyCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Jumlah ${produk['nama_produk']}', border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: target,
                items: [
                  if (isMentah) const DropdownMenuItem(value: 'Telur Asin', child: Text('Ke Telur Asin')),
                  if (!isMentah) const DropdownMenuItem(value: 'Kerupuk Telur Asin', child: Text('Ke Kerupuk Telur Asin')),
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
          controller.konversiProduk(produk['nama_produk'], int.parse(qtyCtrl.text), target);
        }
      }
    );
  }

  Widget _buildPakanTab(BuildContext context) {
    final TextEditingController pakanCtrl = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.grass, size: 80, color: Colors.green),
          const SizedBox(height: 16),
          const Text('Stok Pakan Saat Ini', style: TextStyle(fontSize: 18, color: Colors.grey)),
          Obx(() => Text('${controller.stokPakan.value} Kg', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold))),
          Obx(() => Text('Terakhir Update: ${controller.lastPakanUpdate.value}', style: const TextStyle(fontSize: 14, color: Colors.blue))),
          const SizedBox(height: 32),
          TextField(
            controller: pakanCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Jumlah (Kg)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.scale),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  if (pakanCtrl.text.isNotEmpty) {
                    controller.updatePakan(-int.parse(pakanCtrl.text));
                    pakanCtrl.clear();
                  }
                },
                icon: const Icon(Icons.remove),
                label: const Text('Kurangi'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  if (pakanCtrl.text.isNotEmpty) {
                    controller.updatePakan(int.parse(pakanCtrl.text));
                    pakanCtrl.clear();
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Tambah'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Masukkan jumlah pakan di kolom atas, lalu tekan Tambah atau Kurangi.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Riwayat Transaksi Pakan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (controller.riwayatPakan.isEmpty) {
                return const Center(child: Text('Belum ada riwayat pakan.'));
              }
              return ListView.builder(
                itemCount: controller.riwayatPakan.length,
                itemBuilder: (context, index) {
                  final data = controller.riwayatPakan[index];
                  bool isMasuk = data['jenis_mutasi'] == 'Masuk';
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        isMasuk ? Icons.arrow_downward : Icons.arrow_upward,
                        color: isMasuk ? Colors.green : Colors.red,
                      ),
                      title: Text(data['keterangan'] ?? '-'),
                      subtitle: Text(data['tanggal'].toString().split('T').join(' ').substring(0, 16)),
                      trailing: Text(
                        '${data['jumlah']} Kg',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isMasuk ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
