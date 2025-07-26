import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PatientAIAssistantPage extends StatefulWidget {
  const PatientAIAssistantPage({super.key});

  @override
  State<PatientAIAssistantPage> createState() => _PatientAIAssistantPageState();
}

class _PatientAIAssistantPageState extends State<PatientAIAssistantPage> {
  final List<String> suggestions = [
    'Monitor your blood pressure daily.',
    'Reduce salt intake to help manage hypertension.',
    'Exercise regularly to control blood sugar.',
    'Take your medicines on time.',
    'Eat a balanced diet rich in vegetables and whole grains.',
    'Stay hydrated and avoid sugary drinks.',
  ];

  final List<Map<String, String>> chat = [
    {'role': 'user', 'text': 'What should I do for high blood pressure?'},
    {
      'role': 'ai',
      'text': 'Monitor your blood pressure daily and reduce salt intake.',
    },
    {'role': 'user', 'text': 'How can I improve my diabetes?'},
    {
      'role': 'ai',
      'text': 'Exercise regularly and take your medicines on time.',
    },
  ];

  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  Future<String> _getLLMResponse(String prompt) async {
    final url = Uri.parse(
      'http://10.0.2.2:11434/api/generate',
    ); 

    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'model': 'mistral', 
      'prompt': prompt,
      'stream': false,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'].toString().trim();
      } else {
        return 'AI Error: ${response.statusCode}';
      }
    } catch (e) {
      return 'Failed to connect to AI: $e';
    }
  }

  void _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      chat.add({'role': 'user', 'text': userMessage});
      _isLoading = true;
      _controller.clear();
    });

    final aiResponse = await _getLLMResponse(userMessage);

    setState(() {
      chat.add({'role': 'ai', 'text': aiResponse});
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Health Assistant'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI Suggestions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...suggestions.map(
                      (s) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.psychology,
                              color: Colors.blue,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(s)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: chat.length,
                itemBuilder: (context, i) {
                  final msg = chat[i];
                  final isUser = msg['role'] == 'user';
                  return Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Card(
                      color: isUser
                          ? Colors.blue.shade100
                          : Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          msg['text'] ?? '',
                          style: TextStyle(
                            color: isUser
                                ? Colors.blue.shade900
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isLoading) const CircularProgressIndicator(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Ask a health question...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendMessage,
                  child: const Icon(Icons.send),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
