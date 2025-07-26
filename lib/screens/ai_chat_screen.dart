import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AIChatScreen extends StatefulWidget {
  final String language;
  final String topic;

  AIChatScreen({required this.language, required this.topic});

  @override
  _AIChatScreenState createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  TextEditingController _controller = TextEditingController();
  List<String> _messages = [];
  bool _isLoading = false;

  // Function to fetch AI-generated Q&A from Flask API
  Future<void> _getAIResponse(String question) async {
    setState(() {
      _isLoading = true;
    });

    // Example Flask API call (Make sure to replace with your API endpoint)
    final response = await http.post(
      Uri.parse('https://your-flask-app-url.com/ask'),  // Change this to your actual Flask API URL
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'language': widget.language, 'topic': widget.topic, 'question': question}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      String answer = responseData['answer'] ?? "Sorry, I couldn't understand that.";
      setState(() {
        _messages.add('AI: $answer');
        _isLoading = false;
      });
    } else {
      setState(() {
        _messages.add('AI: Error occurred.');
        _isLoading = false;
      });
    }
  }

  // Function to handle user input and AI interaction
  void _sendMessage() {
    String userMessage = _controller.text.trim();
    if (userMessage.isNotEmpty) {
      setState(() {
        _messages.add('You: $userMessage');
      });
      _controller.clear();
      _getAIResponse(userMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.language} - ${widget.topic} Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _messages[_messages.length - index - 1],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _messages[_messages.length - index - 1].startsWith('You:')
                          ? Colors.blue
                          : Colors.green,
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask a question...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
