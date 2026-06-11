import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/ai_controller.dart';

class AiPage extends StatelessWidget {
  AiPage({Key? key}) : super(key: key);

  final AiController controller = Get.put(AiController());
  final TextEditingController _promptController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asisten AI Bebek (Groq)'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Tanyakan apa saja tentang peternakan bebek, prediksi panen, atau analisis data kandang Anda.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _promptController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Contoh: Berapa suhu optimal untuk kandang bebek bertelur?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => ElevatedButton.icon(
              onPressed: controller.isLoading.value 
                ? null 
                : () {
                    if (_promptController.text.isNotEmpty) {
                      controller.askGroq(_promptController.text);
                      // Jangan bersihkan text dulu biar user bisa edit pertanyaan
                    }
                  },
              icon: controller.isLoading.value 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.send),
              label: Text(controller.isLoading.value ? 'Menganalisis...' : 'Tanya AI'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            )),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),
            const Text('Jawaban AI:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: SingleChildScrollView(
                  child: Obx(() {
                    if (controller.aiResponse.value.isEmpty && !controller.isLoading.value) {
                      return const Center(
                        child: Text(
                          'Hasil jawaban AI akan muncul di sini.',
                          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                        )
                      );
                    }
                    return Text(
                      controller.aiResponse.value,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
