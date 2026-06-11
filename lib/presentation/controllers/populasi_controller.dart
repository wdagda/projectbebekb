import 'package:get/get.dart';
import '../../data/datasources/local_db.dart';

class PopulasiController extends GetxController {
  final int kandangId;
  PopulasiController(this.kandangId);

  var riwayatPopulasi = <Map<String, dynamic>>[].obs;
  var totalPopulasi = 0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRiwayat();
  }

  Future<void> fetchRiwayat() async {
    isLoading.value = true;
    final db = await LocalDB.database;
    final maps = await db.query(
      'Bebek', 
      where: 'kandang_id = ?', 
      whereArgs: [kandangId],
      orderBy: 'id DESC'
    );
    riwayatPopulasi.value = maps;

    int total = 0;
    for (var m in maps) {
      int jumlah = m['jumlah_bebek'] as int;
      if (m['jenis_mutasi'] == 'Masuk') {
        total += jumlah;
      } else {
        total -= jumlah; // Keluar atau Mati
      }
    }
    totalPopulasi.value = total;
    isLoading.value = false;
  }

  Future<void> tambahRiwayat(String jenisMutasi, int jumlah, String keterangan) async {
    if (jenisMutasi != 'Masuk' && totalPopulasi.value - jumlah < 0) {
      Get.snackbar('Gagal', 'Jumlah pengurangan melebihi total populasi kandang');
      return;
    }

    final db = await LocalDB.database;
    await db.insert('Bebek', {
      'kandang_id': kandangId,
      'jenis_mutasi': jenisMutasi,
      'jumlah_bebek': jumlah,
      'tanggal_input': DateTime.now().toIso8601String(),
      'keterangan': keterangan,
    });

    fetchRiwayat();
    Get.back();
    Get.snackbar('Sukses', 'Data mutasi bebek berhasil ditambahkan');
  }
}
