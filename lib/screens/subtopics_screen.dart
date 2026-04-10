// lib/screens/subtopics_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:navaveda/models/subtopic.dart';
import 'package:navaveda/services/api_service.dart';
import 'package:navaveda/screens/notes_screen.dart';

import 'package:navaveda/features/profile/widgets/ai_chat_fab.dart';

class SubtopicsScreen extends StatefulWidget {
  final int topicId;

  const SubtopicsScreen({Key? key, required this.topicId}) : super(key: key);

  @override
  _SubtopicsScreenState createState() => _SubtopicsScreenState();
}

class _SubtopicsScreenState extends State<SubtopicsScreen> {
  String? _firebaseUid;
  late Future<List<Subtopic>> _subtopicsFuture;

  static const Color skyBlue = Color(0xFF5F9DF2);
  static const Color lightSky = Color(0xFFE3F2FD);

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _firebaseUid = user?.uid;
    if (_firebaseUid == null) {
      _subtopicsFuture = Future.error('User not logged in');
    } else {
      _subtopicsFuture = ApiService.getSubtopics(widget.topicId, _firebaseUid!);
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Subtopics'),
  //       backgroundColor: Colors.white,
  //       elevation: 0,
  //       foregroundColor: Colors.black87,
  //     ),
  //       floatingActionButton: const AIChatFab(),
  //
  //
  //     body: FutureBuilder<List<Subtopic>>(
  //       future: _subtopicsFuture,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(child: CircularProgressIndicator());
  //         }
  //         if (snapshot.hasError) {
  //           return Center(child: Text('Error: ${snapshot.error}'));
  //         }
  //         final subtopics = snapshot.data!;
  //         if (subtopics.isEmpty) {
  //           return const Center(child: Text('No subtopics found.'));
  //         }
  //         return ListView.builder(
  //           padding: const EdgeInsets.all(16),
  //           itemCount: subtopics.length,
  //           itemBuilder: (context, index) {
  //             final subtopic = subtopics[index];
  //             return _buildSubtopicCard(context, subtopic);
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

  // Widget _buildSubtopicCard(BuildContext context, Subtopic subtopic) {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) => NotesScreen(
  //             subtopicId: subtopic.id,
  //             topicId: widget.topicId,
  //             isCompleted: subtopic.completed,
  //           ),
  //         ),
  //       );
  //     },
  //     child: Container(
  //       margin: const EdgeInsets.only(bottom: 16),
  //       padding: const EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(20),
  //         boxShadow: [
  //           BoxShadow(
  //             color: skyBlue.withOpacity(0.1),
  //             blurRadius: 10,
  //             offset: const Offset(0, 4),
  //           ),
  //         ],
  //       ),
  //       child: Row(
  //         children: [
  //           Container(
  //             width: 50,
  //             height: 50,
  //             decoration: BoxDecoration(
  //               gradient: const LinearGradient(
  //                 colors: [skyBlue, lightSky],
  //                 begin: Alignment.topLeft,
  //                 end: Alignment.bottomRight,
  //               ),
  //               shape: BoxShape.circle,
  //             ),
  //             child: const Icon(Icons.menu_book, color: Colors.white, size: 24),
  //           ),
  //           const SizedBox(width: 16),
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   subtopic.title,
  //                   style: const TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w600,
  //                     color: Color(0xFF2C3E50),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 4),
  //                 const Text(
  //                   'Interactive lesson',
  //                   style: TextStyle(fontSize: 13, color: Color(0xFF7F8C8D)),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           subtopic.completed ? _buildCompletedBadge() : _buildStartButton(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Subtopics',
            style: TextStyle(fontWeight: FontWeight.bold),

        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
            ),
          ),
        ),

      ),

      // floatingActionButton: const AIChatFab(),
      body: FutureBuilder<List<Subtopic>>(
        future: _subtopicsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5F9DF2)),
            ));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final subtopics = snapshot.data ?? [];
          if (subtopics.isEmpty) {
            return const Center(child: Text('No subtopics found.'));
          }

          // Calculate progress
          final completed = subtopics.where((s) => s.completed).length;
          final total = subtopics.length;
          final progress = completed / total;

          return Column(
            children: [
              // Progress header
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5F9DF2), Color(0xFF9C27B0)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Your Progress',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w600)),
                        Text('$completed / $total',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: subtopics.length,
                  itemBuilder: (context, index) =>
                      _buildSubtopicCard(context, subtopics[index]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  void _refreshSubtopics() {
    setState(() {
      _subtopicsFuture = ApiService.getSubtopics(widget.topicId, _firebaseUid!);
    });
  }

  Widget _buildSubtopicCard(BuildContext context, Subtopic subtopic) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCompleted = subtopic.completed;

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NotesScreen(
              subtopicId: subtopic.id,
              topicId: widget.topicId,
              isCompleted: subtopic.completed,
            ),
          ),
        );
        _refreshSubtopics(); // <-- refresh after returning
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompleted
                ? Colors.green.withOpacity(0.3)
                : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isCompleted
                  ? Colors.green.withOpacity(0.08)
                  : skyBlue.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.green.withOpacity(0.1)
                      : lightSky,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCompleted ? Icons.check_circle_rounded : Icons.menu_book_rounded,
                  color: isCompleted ? Colors.green : skyBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subtopic.title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isCompleted ? Colors.green.shade700 : null,
                        decoration: isCompleted
                            ? TextDecoration.none
                            : null,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      isCompleted ? 'Completed ✓' : 'Tap to start lesson',
                      style: TextStyle(
                        fontSize: 12,
                        color: isCompleted
                            ? Colors.green.shade400
                            : Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              // Status badge
              isCompleted ? _buildCompletedBadge() : _buildStartButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade700],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.green.shade300.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 16),
          SizedBox(width: 4),
          Text('Completed', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [skyBlue, Color(0xFF7B1FA2)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: skyBlue.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: const Text(
        'Start',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12),
      ),
    );
  }
}