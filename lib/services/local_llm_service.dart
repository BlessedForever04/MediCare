import 'dart:convert';
import 'package:http/http.dart' as http;

class LocalLLMService {
  final String _url =
      'http://10.0.2.2:11434/api/generate'; // emulator localhost

  Future<String> getLLMResponse(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "model": "mistral",
          "prompt": prompt,
          "stream": true,
        }),
      );

      if (response.statusCode == 200) {
        final lines = response.body.split('\n');
        String combined = '';

        for (var line in lines) {
          if (line.trim().isEmpty) continue;
          final jsonLine = jsonDecode(line);
          combined += jsonLine['response'] ?? '';
        }

        return combined.trim();
      } else {
        return 'AI Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Failed to connect to LLM: $e';
    }
  }
}
