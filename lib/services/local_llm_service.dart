import 'dart:convert';
import 'package:http/http.dart' as http;

class LocalLLMService {
  final String _url =
      'http://192.168.43.194:3000/api/chat';

  Future<String> getResponse(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "model": "mistral",
          "messages": [
            {"role": "user", "content": prompt},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message']['content'].toString().trim();
      } else {
        throw Exception("LLM API failed: ${response.body}");
      }
    } catch (e) {
      return 'Failed to connect to LLM: $e';
    }
  }
}
