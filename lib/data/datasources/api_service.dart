import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants.dart';

class ApiService {
  // Gunakan API Key yang valid untuk production, ini hanya contoh/placeholder
  static const String _weatherApiKey = 'REPLACE_WITH_YOUR_OPENWEATHER_API_KEY';
  
  static Future<String> getWeather(double lat, double lon) async {
    try {
      final url = 'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        double temp = data['current_weather']['temperature'];
        return "Suhu Lokasi: ${temp.toStringAsFixed(1)}°C";
      }
      return "Cuaca tidak tersedia";
    } catch (e) {
      return "Gagal memuat cuaca";
    }
  }

  static const String _openAiApiKey = 'REPLACE_WITH_YOUR_OPENAI_API_KEY';

  static Future<String> chatWithAI(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Constants.groqApiKey}',
        },
        body: json.encode({
          'model': 'llama-3.3-70b-versatile',
          'messages': [
            {'role': 'system', 'content': 'Anda adalah asisten peternak bebek profesional. Jawab pertanyaan seputar peternakan bebek secara singkat.'},
            {'role': 'user', 'content': prompt}
          ],
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['choices'][0]['message']['content'];
      }
      return "Maaf, AI sedang tidur. Status: ${response.statusCode}";
    } catch (e) {
      return "Koneksi ke AI gagal.";
    }
  }

  static Future<Map<String, dynamic>> getExchangeRates() async {
    try {
      // ExchangeRate-API (Gratis tidak perlu key khusus untuk endpoint standar)
      final url = 'https://open.er-api.com/v6/latest/IDR';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['rates'];
      }
      return {};
    } catch (e) {
      return {};
    }
  }
}
