import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Gunakan API Key yang valid untuk production, ini hanya contoh/placeholder
  static const String _weatherApiKey = 'REPLACE_WITH_YOUR_OPENWEATHER_API_KEY';
  
  static Future<String> getWeather(double lat, double lon) async {
    try {
      final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_weatherApiKey&units=metric';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String weather = data['weather'][0]['main'];
        double temp = data['main']['temp'];
        String city = data['name'];
        return "$weather - ${temp.toStringAsFixed(1)}°C\n$city";
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
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_openAiApiKey',
        },
        body: json.encode({
          'model': 'gpt-3.5-turbo',
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
      return "Maaf, AI sedang tidur.";
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
