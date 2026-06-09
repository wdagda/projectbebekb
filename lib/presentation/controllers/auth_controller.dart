import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import '../../../data/datasources/local_db.dart';
import '../../../core/utils/crypto_utils.dart';
import '../../routes/app_routes.dart';

class AuthController extends GetxController {
  final _storage = GetStorage();
  final _localAuth = LocalAuthentication();

  var isLoading = false.obs;
  var obscureText = true.obs;

  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value;
  }

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    bool isLoggedIn = _storage.read('isLoggedIn') ?? false;
    if (isLoggedIn) {
      // Delay to avoid routing before UI is built
      Future.delayed(Duration(milliseconds: 100), () {
        Get.offAllNamed(AppRoutes.DASHBOARD);
      });
    }
  }

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Username dan password tidak boleh kosong');
      return;
    }

    isLoading.value = true;
    try {
      final db = await LocalDB.database;
      String hashedPw = CryptoUtils.hashPassword(password);
      
      final List<Map<String, dynamic>> result = await db.query(
        'User',
        where: 'username = ? AND password_hash = ?',
        whereArgs: [username, hashedPw],
      );

      if (result.isNotEmpty) {
        // Save session
        _storage.write('isLoggedIn', true);
        _storage.write('username', result.first['username']);
        _storage.write('role', result.first['role']);
        
        Get.offAllNamed(AppRoutes.DASHBOARD);
      } else {
        Get.snackbar('Login Gagal', 'Username atau password salah');
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan sistem');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithFingerprint() async {
    try {
      bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      bool isDeviceSupported = await _localAuth.isDeviceSupported();

      if (canCheckBiometrics && isDeviceSupported) {
        bool didAuthenticate = await _localAuth.authenticate(
          localizedReason: 'Gunakan sidik jari untuk masuk ke Dashboard',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ),
        );

        if (didAuthenticate) {
          // Asumsi login biometrik bypass pengecekan DB (atau bisa di-link ke akun terakhir)
          _storage.write('isLoggedIn', true);
          _storage.write('username', 'Biometric User'); 
          Get.offAllNamed(AppRoutes.DASHBOARD);
        }
      } else {
        Get.snackbar('Biometrik', 'Perangkat tidak mendukung atau belum diatur');
      }
    } catch (e) {
      Get.snackbar('Error Biometrik', 'Gagal memverifikasi sidik jari');
    }
  }

  void logout() {
    _storage.erase();
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
