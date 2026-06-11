import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../core/constants.dart';

class AiController extends GetxController {
  var isLoading = false.obs;
  var aiResponse = "".obs;

  Future<void> askGroq(String prompt) async {
    if (Constants.groqApiKey == "PASTE_API_KEY_GROQ_DI_SINI" || Constants.groqApiKey.isEmpty) {
      aiResponse.value = "Error: API Key Groq belum diatur di lib/core/constants.dart";
      return;
    }

    isLoading.value = true;
    aiResponse.value = "";

    try {
      final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${Constants.groqApiKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "llama-3.3-70b-versatile", // Menggunakan model dari screenshot
          "messages": [
            {
              "role": "system",
              "content": "Anda adalah asisten AI ahli peternakan bebek. Jawab dalam bahasa Indonesia dengan singkat dan padat."
            },
            {
              "role": "user", 
              "content": prompt
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        aiResponse.value = data['choices'][0]['message']['content'];
      } else {
        aiResponse.value = "Gagal memuat. Status: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      aiResponse.value = "Terjadi kesalahan: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
