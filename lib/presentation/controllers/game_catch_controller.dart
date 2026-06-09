import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math';

class GameCatchController extends GetxController {
  var basketPosition = 0.0.obs;
  var eggY = (-1.0).obs;
  var eggX = 0.0.obs;
  var score = 0.obs;
  var isPlaying = false.obs;
  
  StreamSubscription? _accelSub;
  Timer? _gameTimer;

  void startGame() {
    score.value = 0;
    isPlaying.value = true;
    eggY.value = -1.0;
    eggX.value = _randomX();
    
    _accelSub = accelerometerEventStream().listen((AccelerometerEvent event) {
      // Menggeser keranjang berdasarkan kemiringan sumbu X
      // Dibutuhkan penyesuaian tanda negatif tergantung sensitivitas
      double move = event.x * 0.1;
      basketPosition.value -= move;
      
      // Limitasi posisi basket
      if (basketPosition.value < -1.0) basketPosition.value = -1.0;
      if (basketPosition.value > 1.0) basketPosition.value = 1.0;
    });

    _gameTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!isPlaying.value) return;
      
      eggY.value += 0.05; // Kecepatan jatuh
      
      // Cek benturan
      if (eggY.value >= 0.8) {
        if ((eggX.value - basketPosition.value).abs() < 0.3) {
          // Tertangkap
          score.value += 10;
          eggY.value = -1.0;
          eggX.value = _randomX();
        } else if (eggY.value >= 1.0) {
          // Jatuh ke tanah
          stopGame();
        }
      }
    });
  }

  void stopGame() {
    isPlaying.value = false;
    _accelSub?.cancel();
    _gameTimer?.cancel();
  }

  double _randomX() {
    return Random().nextDouble() * 2 - 1; // Return -1.0 to 1.0
  }

  @override
  void onClose() {
    stopGame();
    super.onClose();
  }
}
