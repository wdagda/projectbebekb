import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

  void logout() {
    _storage.erase();
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
