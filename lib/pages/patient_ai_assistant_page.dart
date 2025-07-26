import 'package:flutter/material.dart';

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
    {'role': 'ai', 'text': 'Monitor your blood pressure daily and reduce salt intake.'},
    {'role': 'user', 'text': 'How can I improve my diabetes?'},
    {'role': 'ai', 'text': 'Exercise regularly and take your medicines on time.'},
  ];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      chat.add({'role': 'user', 'text': _controller.text.trim()});
      chat.add({'role': 'ai', 'text': 'This is a mock AI suggestion based on your question.'});
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Health Assistant'), centerTitle: true, backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 2),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('AI Suggestions', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...suggestions.map((s) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              const Icon(Icons.psychology, color: Colors.blue, size: 20),
                              const SizedBox(width: 8),
                              Expanded(child: Text(s)),
                            ],
                          ),
                        )),
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
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Card(
                      color: isUser ? Colors.blue.shade100 : Colors.grey.shade200,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(msg['text'] ?? '', style: TextStyle(color: isUser ? Colors.blue.shade900 : Colors.black87)),
                      ),
                    ),
                  );
                },
              ),
            ),
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
                  onPressed: _sendMessage,
                  child: const Icon(Icons.send),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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