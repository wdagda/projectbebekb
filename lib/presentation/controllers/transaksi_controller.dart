import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/datasources/local_db.dart';

class TransaksiController extends GetxController {
  var produkList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  
  final _storage = GetStorage();
  var stokPakan = 0.obs;
  var lastPakanUpdate = ''.obs;

  var riwayatPakan = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProduk();
    fetchPakan();
  }

  Future<void> fetchPakan() async {
    final db = await LocalDB.database;
    final List<Map<String, dynamic>> maps = await db.query('StokPakan', orderBy: 'id DESC');
    riwayatPakan.value = maps;

    // Hitung total stok
    var result = await db.rawQuery('SELECT SUM(jumlah) as total FROM StokPakan');
    stokPakan.value = (result.first['total'] as int?) ?? 0;
    
    if (maps.isNotEmpty) {
      lastPakanUpdate.value = maps.first['tanggal'].toString().split('T')[0];
    } else {
      lastPakanUpdate.value = 'Belum ada data';
    }
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

  Future<void> konversiProduk(String sourceProdukName, int rawQty, String targetProdukName) async {
    final db = await LocalDB.database;

    var sourceProduct = produkList.firstWhere((p) => p['nama_produk'] == sourceProdukName);
    if (sourceProduct['stok'] < rawQty) {
      Get.snackbar('Gagal', 'Stok $sourceProdukName kurang');
      return;
    }

    int targetQty = 0;
    if (sourceProdukName == 'Telur Bebek Mentah' && targetProdukName == 'Telur Asin') {
      targetQty = rawQty; // 1 mentah = 1 asin
    } else if (sourceProdukName == 'Telur Asin' && targetProdukName == 'Kerupuk Telur Asin') {
      targetQty = (rawQty / 2).floor(); // Asumsi 2 telur asin = 1 bks kerupuk
    } else {
      Get.snackbar('Gagal', 'Konversi dari $sourceProdukName ke $targetProdukName tidak didukung');
      return;
    }

    await db.transaction((txn) async {
      // Potong stok sumber
      await txn.rawUpdate("UPDATE Produk SET stok = stok - ? WHERE nama_produk = ?", [rawQty, sourceProdukName]);
      
      // Tambah stok target
      await txn.rawUpdate("UPDATE Produk SET stok = stok + ? WHERE nama_produk = ?", [targetQty, targetProdukName]);
      
      // Log Konversi
      await txn.insert('RiwayatTransaksi', {
        'produk_id': sourceProduct['id'],
        'tanggal': DateTime.now().toIso8601String(),
        'jenis_transaksi': 'Konversi',
        'jumlah_perubahan': -rawQty,
        'keterangan': 'Dikonversi ke $targetQty $targetProdukName'
      });
    });

    fetchProduk();
    Get.back(); // tutup dialog
    Get.snackbar("Sukses", "$rawQty $sourceProdukName menjadi $targetQty $targetProdukName");
  }

  Future<void> updatePakan(int diff) async {
    if (stokPakan.value + diff < 0) {
      Get.snackbar('Gagal', 'Stok pakan tidak bisa minus');
      return;
    }
    
    final db = await LocalDB.database;
    await db.insert('StokPakan', {
      'tanggal': DateTime.now().toIso8601String(),
      'jenis_mutasi': diff > 0 ? 'Masuk' : 'Keluar',
      'jumlah': diff, // Menyimpan nilai plus atau minus
      'keterangan': diff > 0 ? 'Penambahan pakan' : 'Konsumsi pakan harian'
    });
    
    fetchPakan();
    Get.snackbar('Berhasil', diff > 0 ? 'Pakan ditambahkan' : 'Pakan dikurangi');
  }

  Future<void> tambahStok(int produkId, int jumlahTambah) async {
    final db = await LocalDB.database;
    
    await db.transaction((txn) async {
      // 1. Catat riwayat
      await txn.insert('RiwayatTransaksi', {
        'produk_id': produkId,
        'tanggal': DateTime.now().toIso8601String(),
        'jenis_transaksi': 'Penambahan',
        'jumlah_perubahan': jumlahTambah,
        'keterangan': 'Penambahan stok manual sejumlah $jumlahTambah'
      });
      
      // 2. Tambah stok
      await txn.rawUpdate('''
        UPDATE Produk 
        SET stok = stok + ? 
        WHERE id = ?
      ''', [jumlahTambah, produkId]);
    });
    
    fetchProduk();
    Get.snackbar("Sukses", "Stok berhasil ditambahkan");
  }
}
