
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AIChatScreen extends StatefulWidget {
  final String userId;
  const AIChatScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> msgs = [];
  bool isTyping = false;
  final String apiBase = "https://realeye.onrender.com";

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final res = await http.get(Uri.parse("$apiBase/chat/history?user_id=${widget.userId}&limit=100"));
      if (res.statusCode == 200) {
        final j = jsonDecode(res.body);
        setState(() {
          msgs = List<Map<String, dynamic>>.from(j['messages'] ?? []);
        });
        _scrollToBottom();
      }
    } catch (e) {
      print("history error: $e");
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // optimistic add
    setState(() {
      msgs.add({
        "user_id": widget.userId,
        "sender": "user",
        "message": text,
        "created_at": DateTime.now().toIso8601String()
      });
      _controller.clear();
      isTyping = true;
    });
    _scrollToBottom();

    try {
      final res = await http.post(Uri.parse("$apiBase/chat"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"user_id": widget.userId, "message": text, "language": "en"}));
      if (res.statusCode == 200) {
        final j = jsonDecode(res.body);
        final reply = j['reply'] ?? "No reply";
        setState(() {
          msgs.add({
            "user_id": widget.userId,
            "sender": "ai",
            "message": reply,
            "created_at": DateTime.now().toIso8601String()
          });
        });
      } else {
        setState(() {
          msgs.add({"user_id": widget.userId, "sender": "ai", "message": "Server error", "created_at": DateTime.now().toIso8601String()});
        });
      }
    } catch (e) {
      setState(() {
        msgs.add({"user_id": widget.userId, "sender": "ai", "message": "Error: $e", "created_at": DateTime.now().toIso8601String()});
      });
    } finally {
      setState(() {
        isTyping = false;
      });
      _scrollToBottom();
    }
  }

  Widget _buildBubble(Map<String, dynamic> msg) {
    final isUser = msg['sender'] == 'user';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            color: isUser ? Colors.blueAccent.withOpacity(0.85) : Colors.grey.shade200,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(14),
              topRight: const Radius.circular(14),
              bottomLeft: Radius.circular(isUser ? 14 : 0),
              bottomRight: Radius.circular(isUser ? 0 : 14),
            ),
          ),
          child: Text(
            msg['message'] ?? '',
            style: TextStyle(color: isUser ? Colors.white : Colors.black87),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Assistant"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: msgs.length,
              itemBuilder: (context, i) => _buildBubble(msgs[i]),
            ),
          ),
          if (isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(children: const [
                SizedBox(width: 12),
                CircularProgressIndicator(strokeWidth: 2),
                SizedBox(width: 8),
                Text("realeye is typing..."),
              ]),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    hintText: "Ask Realeye...",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _sendMessage,
                child: const Icon(Icons.send),
              )
            ]),
          )
        ],
      ),
    );
  }
}
