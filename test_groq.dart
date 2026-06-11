import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  String apiKey = 'DUMMY';
  var response = await http.post(
    Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: jsonEncode({
      "model": "llama-3.3-70b-versatile",
      "messages": [
        {"role": "system", "content": "Anda adalah asisten."},
        {"role": "user", "content": "Halo"},
      ],
    }),
  );

  print('Status: ${response.statusCode}');
  print('Body: ${response.body}');
}
