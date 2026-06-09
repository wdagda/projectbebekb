import 'package:get/get.dart';
import '../../data/datasources/local_db.dart';
import '../../data/models/kandang_model.dart';

class ProduksiController extends GetxController {
  var kandangList = <Kandang>[].obs;
  var selectedKandangId = Rxn<int>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchKandang();
  }

  Future<void> fetchKandang() async {
    final db = await LocalDB.database;
    final List<Map<String, dynamic>> maps = await db.query('Kandang');
    kandangList.value = maps.map((e) => Kandang.fromMap(e)).toList();
  }

  Future<void> catatProduksi(int jumlahTelur) async {
    if (selectedKandangId.value == null) {
      Get.snackbar('Error', 'Pilih kandang terlebih dahulu');
      return;
    }

    isLoading.value = true;
    final db = await LocalDB.database;
    
    // Gunakan Transaction agar sinkronisasi data aman
    await db.transaction((txn) async {
      // 1. Catat ke tabel ProduksiTelur
      await txn.insert('ProduksiTelur', {
        'kandang_id': selectedKandangId.value,
        'tanggal': DateTime.now().toIso8601String(),
        'jumlah_telur': jumlahTelur,
      });

      // 2. Tambah Otomatis Stok "Telur Bebek Mentah" (Asumsi ID = 1)
      await txn.rawUpdate('''
        UPDATE Produk 
        SET stok = stok + ? 
        WHERE nama_produk = 'Telur Bebek Mentah'
      ''', [jumlahTelur]);
    });

    isLoading.value = false;
    Get.snackbar('Sukses', 'Produksi tercatat & stok mentah bertambah otomatis');
  }
}
