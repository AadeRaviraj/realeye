// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class ChatScreen extends StatefulWidget {
//   final String userId;
//   final String apiBase;
//
//   const ChatScreen({
//     Key? key,
//     required this.userId,
//     required this.apiBase,
//   }) : super(key: key);
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   List<Map<String, dynamic>> _messages = [];
//   bool isLoading = false;
//
//   Future<void> sendMessage(String text) async {
//     if (text.trim().isEmpty) return;
//
//     setState(() {
//       _messages.add({"sender": "user", "text": text});
//       _controller.clear();
//       isLoading = true;
//     });
//     _scrollToBottom();
//
//     final uri = Uri.parse("${widget.apiBase}/api/chat/send");
//
//     print("🚀 Sending message to: $uri");
//     print("📝 Message: $text");
//     print("👤 User ID: ${widget.userId}");
//
//     try {
//       final res = await http.post(
//         uri,
//         headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//         },
//         body: jsonEncode({
//           "user_id": widget.userId,
//           "message": text
//         }),
//       ).timeout(Duration(seconds: 60));
//
//       print("📡 Response status: ${res.statusCode}");
//       print("📦 Response body: ${res.body}");
//
//       if (res.statusCode == 200) {
//         final data = jsonDecode(res.body);
//         final reply = data["reply"] ?? "No reply received";
//         final status = data["status"] ?? "unknown";
//
//         print("✅ Success - Status: $status, Reply: $reply");
//
//         setState(() {
//           _messages.add({"sender": "ai", "text": reply});
//         });
//       } else if (res.statusCode == 400) {
//         final error = jsonDecode(res.body)["error"] ?? "Bad request";
//         setState(() {
//           _messages.add({"sender": "ai", "text": "Error: $error"});
//         });
//       } else if (res.statusCode == 500) {
//         setState(() {
//           _messages.add({"sender": "ai", "text": "Server error. Please try again."});
//         });
//       } else {
//         setState(() {
//           _messages.add({"sender": "ai", "text": "Unexpected error: ${res.statusCode}"});
//         });
//       }
//     } on http.ClientException catch (e) {
//       print("❌ HTTP Client Exception: $e");
//       setState(() {
//         _messages.add({"sender": "ai", "text": "Network error. Please check your connection."});
//       });
//     } on TimeoutException catch (e) {
//       print("⏰ Timeout Exception: $e");
//       setState(() {
//         _messages.add({"sender": "ai", "text": "Request timeout. Please try again."});
//       });
//     } catch (e) {
//       print("💥 Unexpected error: $e");
//       setState(() {
//         _messages.add({"sender": "ai", "text": "Unexpected error: $e"});
//       });
//     } finally {
//       setState(() => isLoading = false);
//       _scrollToBottom();
//     }
//   }
//
//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Realeye AI Chat"),
//         backgroundColor: Colors.blueAccent,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final m = _messages[index];
//                 final isUser = m["sender"] == "user";
//                 return Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                   child: Align(
//                     alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//                     child: Container(
//                       constraints: BoxConstraints(
//                         maxWidth: MediaQuery.of(context).size.width * 0.8,
//                       ),
//                       padding: EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: isUser
//                             ? Colors.blueAccent.withOpacity(0.9)
//                             : Colors.grey[100],
//                         borderRadius: BorderRadius.circular(18),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 2,
//                             offset: Offset(0, 1),
//                           ),
//                         ],
//                       ),
//                       child: Text(
//                         m["text"],
//                         style: TextStyle(
//                           color: isUser ? Colors.white : Colors.black87,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           if (isLoading)
//             Padding(
//               padding: EdgeInsets.all(12),
//               child: Row(
//                 children: [
//                   SizedBox(width: 16),
//                   CircularProgressIndicator(strokeWidth: 2),
//                   SizedBox(width: 16),
//                   Text(
//                     "AI is thinking...",
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           Container(
//             padding: EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 8,
//                   offset: Offset(0, -2),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(
//                       hintText: "Ask Realeye AI...",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(24),
//                         borderSide: BorderSide.none,
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey[100],
//                       contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                     ),
//                     onSubmitted: (text) => sendMessage(text),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [Colors.blueAccent, Colors.lightBlue],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     shape: BoxShape.circle,
//                   ),
//                   child: IconButton(
//                     icon: Icon(Icons.send, color: Colors.white),
//                     onPressed: isLoading ? null : () => sendMessage(_controller.text),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:async';
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
  bool _isLoading = false;
  int _remainingMessages = 50;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    try {
      final uri = Uri.parse("${widget.apiBase}/api/chat/history?user_id=${widget.userId}");
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _messages = List<Map<String, dynamic>>.from(data['messages'] ?? [])
              .map((msg) => {
            "sender": msg["sender"] ?? "ai",
            "text": msg["message"] ?? "",
          })
              .toList();
        });
        _scrollToBottom();
      }
    } catch (e) {
      print("Error loading chat history: $e");
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    final String userMessage = text.trim();
    setState(() {
      _messages.add({"sender": "user", "text": userMessage});
      _controller.clear();
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final uri = Uri.parse("${widget.apiBase}/api/chat/send");
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "user_id": widget.userId,
          "message": userMessage,
        }),
      ).timeout(const Duration(seconds: 60));

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        setState(() {
          _messages.add({
            "sender": "ai",
            "text": data["reply"] ?? "I apologize, but I couldn't generate a response. Please try again."
          });
          _remainingMessages = data["remaining_messages"] ?? _remainingMessages;
        });
      } else {
        _handleErrorResponse(data);
      }
    } on http.ClientException catch (e) {
      _handleError("Network error: ${e.message}");
    } on TimeoutException catch (e) {
      _handleError("Request timeout. Please try again.");
    } catch (e) {
      _handleError("Unexpected error: $e");
    } finally {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  void _handleErrorResponse(Map<String, dynamic> data) {
    final errorMessage = data["error"] ?? "Unknown error occurred";
    setState(() {
      _messages.add({
        "sender": "ai",
        "text": "Sorry, I encountered an error: $errorMessage"
      });
    });
  }

  void _handleError(String error) {
    setState(() {
      _messages.add({
        "sender": "ai",
        "text": error
      });
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Study Assistant"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Chip(
              label: Text(
                "$_remainingMessages left",
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blueAccent.shade700,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "Start a conversation with your AI tutor!",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message["sender"] == "user";

                return MessageBubble(
                  text: message["text"],
                  isUser: isUser,
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  SizedBox(width: 16),
                  CircularProgressIndicator(strokeWidth: 2),
                  SizedBox(width: 16),
                  Text(
                    "AI is thinking...",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Ask me anything...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    maxLines: null,
                    onSubmitted: (text) => sendMessage(text),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent,
                        Colors.lightBlue,
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _isLoading
                        ? null
                        : () => sendMessage(_controller.text),
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

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const MessageBubble({
    Key? key,
    required this.text,
    required this.isUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.smart_toy, size: 16, color: Colors.white),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isUser ? Colors.blueAccent : Colors.grey[100],
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
          if (isUser)
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.green,
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
        ],
      ),
    );
  }
}