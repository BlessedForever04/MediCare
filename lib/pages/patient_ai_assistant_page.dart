import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../services/local_llm_service.dart';

class ChatMessage {
  final String role;
  final String text;
  ChatMessage({required this.role, required this.text});
}

class PatientAIAssistantPage extends StatefulWidget {
  const PatientAIAssistantPage({super.key});

  @override
  State<PatientAIAssistantPage> createState() => _PatientAIAssistantPageState();
}

class _PatientAIAssistantPageState extends State<PatientAIAssistantPage> {
  final DatabaseService _dbService = DatabaseService();
  final LocalLLMService _llmService = LocalLLMService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;

  final List<String> suggestions = [
    'Monitor your blood pressure daily.',
    'Reduce salt intake to help manage hypertension.',
    'Exercise regularly to control blood sugar.',
    'Take your medicines on time.',
    'Eat a balanced diet rich in vegetables and whole grains.',
    'Stay hydrated and avoid sugary drinks.',
  ];

  final List<ChatMessage> chat = [];

  @override
  void initState() {
    super.initState();
    _dbService.getMedicalHistory().then((records) {
      if (records.isEmpty) {
        _dbService.insertDisease("Hypertension");
        _dbService.insertDisease("Diabetes");
      }
    });
  }

  void _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      chat.add(ChatMessage(role: 'user', text: userMessage));
      _isLoading = true;
      _controller.clear();
    });

    // Fetch medical history
    final historyRecords = await _dbService.getMedicalHistory();
    final history = historyRecords.isEmpty
        ? "No past records."
        : historyRecords.map((r) => r['name']).join(", ");

    // Construct prompt
    final prompt =
        "You are a medical assistant.\nThe patient has the following medical history: $history\nAnswer their question carefully:\n$userMessage";

    // Call Ollama LLM
    final aiResponse = await _llmService.getLLMResponse(prompt);

    setState(() {
      chat.add(ChatMessage(role: 'ai', text: aiResponse));
      _isLoading = false;
    });

    // Scroll to bottom
    await Future.delayed(const Duration(milliseconds: 100));
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Patient AI Assistant")),
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
                controller: _scrollController,
                itemCount: chat.length,
                itemBuilder: (context, i) {
                  final msg = chat[i];
                  final isUser = msg.role == 'user';
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
                          msg.text,
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
