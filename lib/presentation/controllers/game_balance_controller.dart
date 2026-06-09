import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

class GameBalanceController extends GetxController {
  var isPlaying = false.obs;
  var survivalTime = 0.obs;
  
  StreamSubscription? _gyroSub;
  Timer? _timer;

  void startGame() {
    survivalTime.value = 0;
    isPlaying.value = true;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isPlaying.value) survivalTime.value++;
    });

    _gyroSub = gyroscopeEventStream().listen((GyroscopeEvent event) {
      if (!isPlaying.value) return;
      
      // Deteksi goyangan berlebih
      if (event.x.abs() > 2.0 || event.y.abs() > 2.0) {
         stopGame();
         Get.snackbar('Game Over!', 'Telur jatuh karena goyangan terlalu keras. Bertahan: ${survivalTime.value} detik.');
      }
    });
  }

  void stopGame() {
    isPlaying.value = false;
    _gyroSub?.cancel();
    _timer?.cancel();
  }

  @override
  void onClose() {
    stopGame();
    super.onClose();
  }
}
