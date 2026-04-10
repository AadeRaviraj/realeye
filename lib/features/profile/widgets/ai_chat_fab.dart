import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:navaveda/Config/ai_api_config.dart';

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
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4776E6).withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
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
  final FocusNode _focusNode = FocusNode();

  List<Map<String, Object>> messages = [];
  bool isLoading = false;
  int remainingMessages = 5;

  // Enhanced markdown stripper – removes bold, italic, code, blockquotes, numbered lists, $1 etc.
  String _stripMarkdown(String text) {
    text = text.replaceAll(RegExp(r'\*\*(.*?)\*\*'), r'$1');
    text = text.replaceAll(RegExp(r'\*(.*?)\*'), r'$1');
    text = text.replaceAll(RegExp(r'`(.*?)`'), r'$1');
    text = text.replaceAll(RegExp(r'^> ', multiLine: true), '');
    text = text.replaceAll(RegExp(r'^\d+\.\s+', multiLine: true), '');
    text = text.replaceAll(RegExp(r'^\d+\)\s+', multiLine: true), '');
    text = text.replaceAll(RegExp(r'\$(\d+)'), r'');
    text = text.replaceAll(RegExp(r'^#+\s+', multiLine: true), '');
    return text;
  }

  @override
  void initState() {
    super.initState();
    _loadHistory();
    // Auto‑focus the text field when the sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
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
            <String, Object>{"msg": item['question'], "isUser": true},
            <String, Object>{
              "msg": _stripMarkdown(item['answer']),
              "isUser": false
            },
          ])
              .toList();
        });
        Future.delayed(const Duration(milliseconds: 100), () {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      } else {
        print("History load failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Failed to load history: $e");
    }
  }

  Future<void> sendMessage() async {
    String text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(<String, Object>{"msg": text, "isUser": true});
      isLoading = true;
      _controller.clear();
    });

    try {
      final url = Uri.parse("${AiApiConfig.baseUrl}/send");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "user_id": widget.userId,
          "message": text,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        setState(() {
          messages.add(<String, Object>{
            "msg": "Server error (${response.statusCode}). Please try again later.",
            "isUser": false
          });
        });
        return;
      }

      final data = jsonDecode(response.body);

      if (data["error"] == "LIMIT_EXCEEDED") {
        setState(() {
          messages.add(<String, Object>{
            "msg": "Daily limit reached. Upgrade to Pro for unlimited messages.",
            "isUser": false
          });
          remainingMessages = 0;
        });
      } else if (data.containsKey("response")) {
        setState(() {
          messages.add(<String, Object>{
            "msg": _stripMarkdown(data["response"]),
            "isUser": false
          });
          remainingMessages = data["remaining"] ?? 0;
        });
      } else {
        setState(() {
          messages.add(<String, Object>{
            "msg": "Unexpected response from server.",
            "isUser": false
          });
        });
      }
    } catch (e) {
      print("Error in sendMessage: $e");
      setState(() {
        messages.add(<String, Object>{
          "msg": "Server error. Please check your internet connection and try again.",
          "isUser": false
        });
      });
    } finally {
      setState(() {
        isLoading = false;
      });
      // Scroll to bottom after adding new message
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
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.95,      // More space for the chat
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset), // Push up when keyboard opens
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Draggable handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 10),
              // Header
              const Text("AI Assistant",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const Divider(thickness: 1),
              // Message list
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isUser = msg["isUser"] == true;
                    return Align(
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75),
                        decoration: BoxDecoration(
                          color: isUser
                              ? const Color(0xFF4776E6)
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: isUser
                                ? const Radius.circular(16)
                                : const Radius.circular(4),
                            bottomRight: isUser
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
                          msg["msg"].toString(),
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black87,
                            fontSize: 14,
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
              // WhatsApp‑style input row (expands and stays above keyboard)
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        enabled: !isLimitReached,
                        maxLines: null,
                        minLines: 1,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
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
                        style: const TextStyle(color: Colors.black87),
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
      ),
    );
  }
}