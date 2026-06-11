import 'package:get/get.dart';
import '../../data/datasources/local_db.dart';
import '../../data/datasources/api_service.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:async';
import 'package:intl/intl.dart';

class DashboardController extends GetxController {
  var totalKandang = 0.obs;
  var totalBebek = 0.obs;
  var totalProduksiHariIni = 0.obs;
  var cuacaInfo = "Memuat cuaca...".obs;
  
  var previewKandang = <Map<String, dynamic>>[].obs;
  var currentTimeWIB = "".obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
    loadDashboardData();
    fetchWeather();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _startTimer() {
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    // WIB is UTC+7
    final now = DateTime.now().toUtc().add(const Duration(hours: 7));
    currentTimeWIB.value = DateFormat('HH:mm:ss').format(now) + " WIB";
  }

  Future<void> loadDashboardData() async {
    final db = await LocalDB.database;
    
    // Total Kandang
    var resKandang = await db.rawQuery('SELECT COUNT(*) as count FROM Kandang');
    totalKandang.value = Sqflite.firstIntValue(resKandang) ?? 0;

    // Total Bebek
    var resBebek = await db.rawQuery("SELECT SUM(CASE WHEN jenis_mutasi = 'Masuk' THEN jumlah_bebek ELSE -jumlah_bebek END) as total FROM Bebek");
    totalBebek.value = Sqflite.firstIntValue(resBebek) ?? 0;

    // Total Telur Hari Ini
    String today = DateTime.now().toIso8601String().substring(0, 10);
    var resTelur = await db.rawQuery(
      "SELECT SUM(jumlah_telur) as total FROM ProduksiTelur WHERE tanggal LIKE '$today%'"
    );
    totalProduksiHariIni.value = Sqflite.firstIntValue(resTelur) ?? 0;

    // Preview 3 Kandang
    var resPreview = await db.rawQuery('''
      SELECT Kandang.nama_kandang, 
             COALESCE(SUM(CASE WHEN Bebek.jenis_mutasi = 'Masuk' THEN Bebek.jumlah_bebek ELSE -Bebek.jumlah_bebek END), 0) as populasi 
      FROM Kandang 
      LEFT JOIN Bebek ON Kandang.id = Bebek.kandang_id 
      GROUP BY Kandang.id 
      ORDER BY Kandang.id DESC LIMIT 3
    ''');
    previewKandang.assignAll(resPreview);
  }

  Future<void> fetchWeather() async {
    // Sebagai contoh statis, menggunakan koordinat Malang/Batu (atau bisa dari lokasi kandang)
    // -7.98, 112.63
    String result = await ApiService.getWeather(-7.98, 112.63);
    cuacaInfo.value = result;
  }
}
