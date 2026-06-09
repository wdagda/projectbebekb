import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/datasources/local_db.dart';
import '../../data/models/kandang_model.dart';

class KandangController extends GetxController {
  var kandangList = <Kandang>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchKandang();
  }

  Future<void> fetchKandang() async {
    isLoading.value = true;
    final db = await LocalDB.database;
    final List<Map<String, dynamic>> maps = await db.query('Kandang');
    kandangList.value = maps.map((e) => Kandang.fromMap(e)).toList();
    isLoading.value = false;
  }

  Future<void> addKandang(Kandang kandang) async {
    final db = await LocalDB.database;
    await db.insert('Kandang', kandang.toMap());
    fetchKandang();
    Get.back();
    Get.snackbar('Sukses', 'Kandang berhasil ditambahkan');
  }

  Future<void> deleteKandang(int id) async {
    final db = await LocalDB.database;
    await db.delete('Kandang', where: 'id = ?', whereArgs: [id]);
    fetchKandang();
    Get.snackbar('Terhapus', 'Kandang dihapus');
  }

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Error', 'Layanan lokasi dinonaktifkan.');
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Error', 'Izin lokasi ditolak.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Error', 'Izin lokasi ditolak permanen.');
      return null;
    }

    Get.snackbar('Info', 'Mendapatkan lokasi...', duration: const Duration(seconds: 1));
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
