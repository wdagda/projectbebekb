import 'package:get/get.dart';
import '../../data/datasources/api_service.dart';

class ExchangeController extends GetxController {
  var rates = {}.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRates();
  }

  Future<void> fetchRates() async {
    isLoading.value = true;
    var data = await ApiService.getExchangeRates();
    rates.value = data;
    isLoading.value = false;
  }

  double convert(double amountIdr, String targetCurrency) {
    if (rates.isEmpty || !rates.containsKey(targetCurrency)) return 0.0;
    // Base api kita IDR, jadi 1 IDR = rate targetCurrency
    return amountIdr * rates[targetCurrency];
  }
}
