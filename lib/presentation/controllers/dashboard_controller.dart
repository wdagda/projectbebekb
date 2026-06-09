import 'package:get/get.dart';
import '../../data/datasources/local_db.dart';
import '../../data/datasources/api_service.dart';
import 'package:sqflite/sqflite.dart';

class DashboardController extends GetxController {
  var totalKandang = 0.obs;
  var totalBebek = 0.obs;
  var totalProduksiHariIni = 0.obs;
  var cuacaInfo = "Memuat cuaca...".obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
    fetchWeather();
  }

  Future<void> loadDashboardData() async {
    final db = await LocalDB.database;
    
    // Total Kandang
    var resKandang = await db.rawQuery('SELECT COUNT(*) as count FROM Kandang');
    totalKandang.value = Sqflite.firstIntValue(resKandang) ?? 0;

    // Total Bebek
    var resBebek = await db.rawQuery('SELECT SUM(jumlah_bebek) as total FROM Bebek');
    totalBebek.value = Sqflite.firstIntValue(resBebek) ?? 0;

    // Total Telur Hari Ini
    String today = DateTime.now().toIso8601String().substring(0, 10);
    var resTelur = await db.rawQuery(
      "SELECT SUM(jumlah_telur) as total FROM ProduksiTelur WHERE tanggal LIKE '$today%'"
    );
    totalProduksiHariIni.value = Sqflite.firstIntValue(resTelur) ?? 0;
  }

  Future<void> fetchWeather() async {
    // Sebagai contoh statis, menggunakan koordinat Malang/Batu (atau bisa dari lokasi kandang)
    // -7.98, 112.63
    String result = await ApiService.getWeather(-7.98, 112.63);
    cuacaInfo.value = result;
  }
}
