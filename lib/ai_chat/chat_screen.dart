import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
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
      _messages.add({"sender": "user", "text": text});
      _controller.clear();
      isLoading = true;
    });
    _scrollToBottom();

    final uri = Uri.parse("${widget.apiBase}/api/chat/send");

    print("🚀 Sending message to: $uri");
    print("📝 Message: $text");
    print("👤 User ID: ${widget.userId}");

    try {
      final res = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "user_id": widget.userId,
          "message": text
        }),
      ).timeout(Duration(seconds: 60));

      print("📡 Response status: ${res.statusCode}");
      print("📦 Response body: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final reply = data["reply"] ?? "No reply received";
        final status = data["status"] ?? "unknown";

        print("✅ Success - Status: $status, Reply: $reply");

        setState(() {
          _messages.add({"sender": "ai", "text": reply});
        });
      } else if (res.statusCode == 400) {
        final error = jsonDecode(res.body)["error"] ?? "Bad request";
        setState(() {
          _messages.add({"sender": "ai", "text": "Error: $error"});
        });
      } else if (res.statusCode == 500) {
        setState(() {
          _messages.add({"sender": "ai", "text": "Server error. Please try again."});
        });
      } else {
        setState(() {
          _messages.add({"sender": "ai", "text": "Unexpected error: ${res.statusCode}"});
        });
      }
    } on http.ClientException catch (e) {
      print("❌ HTTP Client Exception: $e");
      setState(() {
        _messages.add({"sender": "ai", "text": "Network error. Please check your connection."});
      });
    } on TimeoutException catch (e) {
      print("⏰ Timeout Exception: $e");
      setState(() {
        _messages.add({"sender": "ai", "text": "Request timeout. Please try again."});
      });
    } catch (e) {
      print("💥 Unexpected error: $e");
      setState(() {
        _messages.add({"sender": "ai", "text": "Unexpected error: $e"});
      });
    } finally {
      setState(() => isLoading = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Realeye AI Chat"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                final isUser = m["sender"] == "user";
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isUser
                            ? Colors.blueAccent.withOpacity(0.9)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        m["text"],
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (isLoading)
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  SizedBox(width: 16),
                  CircularProgressIndicator(strokeWidth: 2),
                  SizedBox(width: 16),
                  Text(
                    "AI is thinking...",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ask Realeye AI...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                    onSubmitted: (text) => sendMessage(text),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.lightBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: isLoading ? null : () => sendMessage(_controller.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}