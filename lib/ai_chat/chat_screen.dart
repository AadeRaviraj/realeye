import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  //final String userId;
  // final String apiBase; // pass API base URL (use Render URL in production)
  // final String currentUserId;
  //
  //
  // const ChatScreen({Key? key, required this.currentUserId, required this.apiBase}) : super(key: key);

  final String userId;
  final String apiBase;

  const ChatScreen({
    Key? key,
    required this.userId,
    required this.apiBase,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _messages = [];
  bool isLoading = false;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({"sender":"user","text":text});
      _controller.clear();
      isLoading = true;
    });
    _scrollToBottom();

    final uri = Uri.parse("${widget.apiBase}/api/chat/send");
    try {
      final res = await http.post(uri,
        headers: {"Content-Type":"application/json"},
        body: jsonEncode({"user_id": widget.userId, "message": text}),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final reply = data["reply"] ?? "No reply";
        setState(() {
          _messages.add({"sender":"ai","text":reply});
        });
      } else {
        setState(() {
          _messages.add({"sender":"ai","text":"Server error ${res.statusCode}"});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({"sender":"ai","text":"Error: $e"});
      });
    } finally {
      setState(() => isLoading = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 200), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Realeye AI Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                final isUser = m["sender"] == "user";
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blueAccent.withOpacity(0.8) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(m["text"], style: TextStyle(color: isUser ? Colors.white : Colors.black87)),
                  ),
                );
              },
            ),
          ),
          if (isLoading)
            Padding(padding: EdgeInsets.all(8), child: Row(children: [CircularProgressIndicator(), SizedBox(width:8), Text("AI is typing...")])),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(children: [
              Expanded(
                child: TextField(controller: _controller, decoration: InputDecoration(hintText: "Ask Realeye...")),
              ),
              IconButton(icon: Icon(Icons.send), onPressed: () => sendMessage(_controller.text)),
            ]),
          ),
        ],
      ),
    );
  }
}
