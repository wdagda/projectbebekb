import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/exchange_controller.dart';

class ExchangePage extends StatelessWidget {
  ExchangePage({Key? key}) : super(key: key);

  final ExchangeController controller = Get.put(ExchangeController());
  final TextEditingController inputController = TextEditingController();
  final selectedCurrency = 'USD'.obs;
  final convertedAmount = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konversi Nilai Jual')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Cek potensi nilai jual produk di luar negeri.', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            TextField(
              controller: inputController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah dalam Rupiah (IDR)',
                border: OutlineInputBorder(),
                prefixText: 'Rp ',
              ),
              onChanged: (val) {
                if (val.isNotEmpty) {
                  convertedAmount.value = controller.convert(double.parse(val), selectedCurrency.value);
                } else {
                  convertedAmount.value = 0.0;
                }
              },
            ),
            const SizedBox(height: 16),
            Obx(() => DropdownButtonFormField<String>(
              value: selectedCurrency.value,
              decoration: const InputDecoration(labelText: 'Konversi Ke', border: OutlineInputBorder()),
              items: ['USD', 'JPY', 'EUR', 'GBP', 'MYR', 'SGD'].map((c) {
                return DropdownMenuItem(value: c, child: Text(c));
              }).toList(),
              onChanged: (val) {
                selectedCurrency.value = val!;
                if (inputController.text.isNotEmpty) {
                  convertedAmount.value = controller.convert(double.parse(inputController.text), val);
                }
              },
            )),
            const SizedBox(height: 32),
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Nilai Estimasi:', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Obx(() {
                      if (controller.isLoading.value) return const CircularProgressIndicator();
                      return Text(
                        '${convertedAmount.value.toStringAsFixed(2)} ${selectedCurrency.value}',
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
                      );
                    }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
