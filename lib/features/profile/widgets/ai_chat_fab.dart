// // ============================================================
// // File     : lib/widgets/ai_chat_fab.dart
// // Description: Reusable animated floating AI chatbot button.
// //              Add as floatingActionButton to any study screen.
// //              Opens AIChatScreen as bottom sheet.
// // Usage:
// //   floatingActionButton: const AIChatFab(),
// // ============================================================
//
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:realeyes/ai_chat/ai_chat_screen.dart';
//
// class AIChatFab extends StatefulWidget {
//   const AIChatFab({Key? key}) : super(key: key);
//
//   @override
//   State<AIChatFab> createState() => _AIChatFabState();
// }
//
// class _AIChatFabState extends State<AIChatFab>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _pulseAnim;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1400),
//     )..repeat(reverse: true);
//     _pulseAnim = Tween<double>(begin: 1.0, end: 1.12).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _openChat(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _ChatBottomSheet(userId: user.uid),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ScaleTransition(
//       scale: _pulseAnim,
//       child: Container(
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           gradient: const LinearGradient(
//             colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF4776E6).withOpacity(0.45),
//               blurRadius: 16,
//               offset: const Offset(0, 6),
//             ),
//           ],
//         ),
//         child: Material(
//           color: Colors.transparent,
//           shape: const CircleBorder(),
//           child: InkWell(
//             customBorder: const CircleBorder(),
//             onTap: () => _openChat(context),
//             child: const Padding(
//               padding: EdgeInsets.all(14),
//               child: Icon(Icons.smart_toy_rounded, color: Colors.white, size: 26),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ── Chat Bottom Sheet ──────────────────────────────────────────
// class _ChatBottomSheet extends StatelessWidget {
//   final String userId;
//   const _ChatBottomSheet({required this.userId});
//
//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//       initialChildSize: 0.88,
//       minChildSize: 0.5,
//       maxChildSize: 0.95,
//       builder: (_, controller) => Container(
//         decoration: BoxDecoration(
//           color: Theme.of(context).scaffoldBackgroundColor,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         child: Column(
//           children: [
//             // Handle + title
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//               child: Column(
//                 children: [
//                   Center(
//                     child: Container(
//                       width: 40, height: 4,
//                       decoration: BoxDecoration(
//                           color: Colors.grey.shade400,
//                           borderRadius: BorderRadius.circular(10)),
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           gradient: const LinearGradient(
//                               colors: [Color(0xFF4776E6), Color(0xFF8E54E9)]),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: const Icon(Icons.smart_toy_rounded,
//                             color: Colors.white, size: 20),
//                       ),
//                       const SizedBox(width: 10),
//                       const Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('AI Assistant',
//                               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                           Text('Ask me anything about your studies',
//                               style: TextStyle(fontSize: 11, color: Colors.grey)),
//                         ],
//                       ),
//                       const Spacer(),
//                       IconButton(
//                         icon: const Icon(Icons.close_rounded),
//                         onPressed: () => Navigator.pop(context),
//                       ),
//                     ],
//                   ),
//                   const Divider(),
//                 ],
//               ),
//             ),
//             // Chat screen (embedded)
//             Expanded(
//               child: AIChatScreen(userId: userId),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:realeyes/Config/ai_api_config.dart';

class AIChatFab extends StatefulWidget {
  const AIChatFab({Key? key}) : super(key: key);

  @override
  State<AIChatFab> createState() => _AIChatFabState();
}

class _AIChatFabState extends State<AIChatFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openChat(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ChatBottomSheet(userId: user.uid),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulseAnim,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => _openChat(context),
            child: const Padding(
              padding: EdgeInsets.all(14),
              child: Icon(Icons.smart_toy_rounded,
                  color: Colors.white, size: 26),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// CHAT BOTTOM SHEET WITH FULL LOGIC
// ============================================================

class _ChatBottomSheet extends StatefulWidget {
  final String userId;
  const _ChatBottomSheet({required this.userId});

  @override
  State<_ChatBottomSheet> createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<_ChatBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> messages = [];
  bool isLoading = false;
  int remainingMessages = 5;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  String _stripMarkdown(String text) {
    text = text.replaceAll(RegExp(r'\*\*(.*?)\*\*'), r'$1');
    text = text.replaceAll(RegExp(r'\*(.*?)\*'), r'$1');
    text = text.replaceAll(RegExp(r'`(.*?)`'), r'$1');
    text = text.replaceAll(RegExp(r'^> ', multiLine: true), '');
    return text;
  }

  Future<void> _loadHistory() async {
    try {
      final url = Uri.parse("${AiApiConfig.baseUrl}/history");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"user_id": widget.userId}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> history = data['history'] ?? [];
        setState(() {
          messages = history
              .expand((item) => [
            {"msg": _stripMarkdown(item['question']), "isUser": true},
            {"msg": _stripMarkdown(item['answer']), "isUser": false},
          ])
              .toList();
        });
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      }
    } catch (e) {
      print("Failed to load history: $e");
    }
  }

  Future<void> sendMessage() async {
    String text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({"msg": text, "isUser": true});
      isLoading = true;
      _controller.clear();
    });

    try {
      final url = Uri.parse("${AiApiConfig.baseUrl}/send");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"user_id": widget.userId, "message": text}),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        setState(() {
          messages.add({
            "msg": "Server error (${response.statusCode}). Please try again later.",
            "isUser": false
          });
        });
        return;
      }

      final data = jsonDecode(response.body);
      if (data["error"] == "LIMIT_EXCEEDED") {
        setState(() {
          messages.add({
            "msg": "Daily limit reached. Upgrade to Pro for unlimited messages.",
            "isUser": false
          });
          remainingMessages = 0;
        });
      } else if (data.containsKey("response")) {
        setState(() {
          messages.add({
            "msg": _stripMarkdown(data["response"]),
            "isUser": false
          });
          remainingMessages = data["remaining"] ?? 0;
        });
      } else {
        setState(() {
          messages.add({"msg": "Unexpected response.", "isUser": false});
        });
      }
    } catch (e) {
      print("Error in sendMessage: $e");
      setState(() {
        messages.add({
          "msg": "Connection error. Please check your internet.",
          "isUser": false
        });
      });
    } finally {
      setState(() => isLoading = false);
      Future.delayed(const Duration(milliseconds: 200), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLimitReached = remainingMessages <= 0;
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      builder: (_, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // --- Draggable Handle ---
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // --- Header with Gradient ---
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.smart_toy, color: Color(0xFF4776E6)),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AI Assistant',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Text('Your study companion',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),
                  if (remainingMessages > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "$remainingMessages left",
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12),
                      ),
                    ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // --- Chat Messages ---
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Align(
                      alignment: msg["isUser"]
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: msg["isUser"]
                              ? const Color(0xFF4776E6)
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: msg["isUser"]
                                ? const Radius.circular(16)
                                : const Radius.circular(4),
                            bottomRight: msg["isUser"]
                                ? const Radius.circular(4)
                                : const Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          msg["msg"],
                          style: TextStyle(
                            color: msg["isUser"] ? Colors.white : Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            // --- Input Row ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !isLimitReached,
                      decoration: InputDecoration(
                        hintText: isLimitReached
                            ? "Limit reached. Upgrade to Pro."
                            : "Ask something...",
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: isLimitReached
                        ? Colors.grey
                        : const Color(0xFF4776E6),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: isLimitReached ? null : sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}