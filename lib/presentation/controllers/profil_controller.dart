import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import '../../../data/datasources/local_db.dart';
import '../../../core/utils/crypto_utils.dart';
import '../../routes/app_routes.dart';

class ProfilController extends GetxController {
  final _storage = GetStorage();
  
  var username = ''.obs;
  var role = ''.obs;

  @override
  void onInit() {
    super.onInit();
    username.value = _storage.read('username') ?? 'Peternak';
    role.value = _storage.read('role') ?? 'Admin';
  }

  final _localAuth = LocalAuthentication();

  void updateProfileData(String nama, String newUsername, String password) async {
    if (newUsername.trim().isEmpty) {
      Get.snackbar('Error', 'Username tidak boleh kosong');
      return;
    }

    try {
      bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Verifikasi sidik jari untuk mengubah profil',
        options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );

      if (didAuthenticate) {
        final db = await LocalDB.database;
        String oldUsername = username.value;
        
        Map<String, dynamic> updateData = {'username': newUsername};
        if (nama.isNotEmpty) updateData['nama'] = nama;
        if (password.isNotEmpty) updateData['password_hash'] = CryptoUtils.hashPassword(password);

        await db.update('User', updateData, where: 'username = ?', whereArgs: [oldUsername]);

        username.value = newUsername;
        _storage.write('username', newUsername);
        
        Get.back();
        Get.snackbar('Sukses', 'Profil berhasil diupdate');
      } else {
        Get.snackbar('Gagal', 'Verifikasi sidik jari dibatalkan');
      }
    } catch (e) {
      Get.snackbar('Error', 'Perangkat tidak mendukung atau belum mengatur biometrik.');
    }
  }

  void logout() {
    _storage.erase();
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
