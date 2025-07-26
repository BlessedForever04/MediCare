import 'dart:convert';
import 'package:http/http.dart' as http;

class LocalLLMService {
  final String _url = 'http://10.0.2.2:11434/api/chat'; // emulator uses 10.0.2.2

  Future<String> getResponse(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "model": "mistral",
          "messages": [
            {"role": "user", "content": prompt}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message']['content'].toString().trim();
      } else {
        throw Exception("LLM API failed: ${response.body}");
      }
    } catch (e) {
      return '⚠️ Failed to connect to LLM: $e';
    }
  }
}