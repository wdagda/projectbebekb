import 'package:get/get.dart';
import '../../data/datasources/local_db.dart';

class TransaksiController extends GetxController {
  var produkList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProduk();
  }

  Future<void> fetchProduk() async {
    isLoading.value = true;
    final db = await LocalDB.database;
    final List<Map<String, dynamic>> maps = await db.query('Produk');
    produkList.value = maps;
    isLoading.value = false;
  }

  Future<void> catatPenjualan(int produkId, int jumlahTerjual) async {
    final db = await LocalDB.database;
    
    // Cek stok apakah cukup
    var produk = produkList.firstWhere((p) => p['id'] == produkId);
    if (produk['stok'] < jumlahTerjual) {
      Get.snackbar('Gagal', 'Stok tidak mencukupi untuk dijual');
      return;
    }

    await db.transaction((txn) async {
      // 1. Catat riwayat
      await txn.insert('RiwayatTransaksi', {
        'produk_id': produkId,
        'tanggal': DateTime.now().toIso8601String(),
        'jenis_transaksi': 'Penjualan',
        'jumlah_perubahan': -jumlahTerjual,
        'keterangan': 'Terjual sejumlah $jumlahTerjual'
      });
      
      // 2. Potong stok
      await txn.rawUpdate('''
        UPDATE Produk 
        SET stok = stok - ? 
        WHERE id = ?
      ''', [jumlahTerjual, produkId]);
    });
    
    fetchProduk();
    Get.snackbar("Sukses", "Penjualan berhasil, stok terpotong");
  }

  Future<void> konversiProduk(int rawQty, String targetProdukName) async {
    final db = await LocalDB.database;

    // Asumsi ID 1 adalah Telur Mentah
    var mentah = produkList.firstWhere((p) => p['nama_produk'] == 'Telur Bebek Mentah');
    if (mentah['stok'] < rawQty) {
      Get.snackbar('Gagal', 'Stok telur mentah kurang');
      return;
    }

    int targetQty = 0;
    if (targetProdukName == 'Telur Asin') {
      targetQty = rawQty; // 1 mentah = 1 asin
    } else if (targetProdukName == 'Kerupuk Telur Asin') {
      targetQty = (rawQty / 2).floor(); // Asumsi 2 telur = 1 bks kerupuk
    }

    await db.transaction((txn) async {
      // Potong stok mentah
      await txn.rawUpdate("UPDATE Produk SET stok = stok - ? WHERE nama_produk = 'Telur Bebek Mentah'", [rawQty]);
      
      // Tambah stok target
      await txn.rawUpdate("UPDATE Produk SET stok = stok + ? WHERE nama_produk = ?", [targetQty, targetProdukName]);
      
      // Log Konversi
      await txn.insert('RiwayatTransaksi', {
        'produk_id': mentah['id'],
        'tanggal': DateTime.now().toIso8601String(),
        'jenis_transaksi': 'Konversi',
        'jumlah_perubahan': -rawQty,
        'keterangan': 'Dikonversi ke $targetQty $targetProdukName'
      });
    });

    fetchProduk();
    Get.back(); // tutup dialog
    Get.snackbar("Sukses", "$rawQty Telur Mentah menjadi $targetQty $targetProdukName");
  }
}
