// // lib/screens/topics_screen.dart
// import 'package:flutter/material.dart';
// import 'package:realeyes/models/topic.dart';
// import 'package:realeyes/services/api_service.dart';
// import 'package:realeyes/screens/subtopics_screen.dart';
//
// class TopicsScreen extends StatelessWidget {
//   final int courseId;
//
//   const TopicsScreen({Key? key, required this.courseId}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Course Topics'),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: FutureBuilder<List<Topic>>(
//         future: ApiService.getTopics(courseId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5F9DF2)), // sky blue
//               ),
//             );
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           final topics = snapshot.data!;
//           if (topics.isEmpty) {
//             return const Center(child: Text('No topics available.'));
//           }
//           return ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: topics.length,
//             itemBuilder: (context, index) {
//               final topic = topics[index];
//               return _buildTopicCard(context, topic);
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildTopicCard(BuildContext context, Topic topic) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           PageRouteBuilder(
//             pageBuilder: (_, __, ___) => SubtopicsScreen(topicId: topic.id),
//             transitionsBuilder: (_, animation, __, child) {
//               return FadeTransition(opacity: animation, child: child);
//             },
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF5F9DF2).withOpacity(0.1), // sky blue shadow
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Left accent bar
//             Container(
//               width: 8,
//               height: 80,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF5F9DF2), // sky blue
//                 borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       topic.title,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF2C3E50),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '${topic.id} subtopics', // Placeholder; ideally from API
//                       style: const TextStyle(fontSize: 14, color: Color(0xFF7F8C8D)),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Icon(
//                 Icons.arrow_forward_ios,
//                 color: const Color(0xFF5F9DF2), // sky blue
//                 size: 18,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// lib/screens/topics_screen.dart
import 'package:flutter/material.dart';
import 'package:realeyes/models/topic.dart';
import 'package:realeyes/services/api_service.dart';
import 'package:realeyes/screens/subtopics_screen.dart';
import 'package:realeyes/features/profile/widgets/ai_chat_fab.dart';

class TopicsScreen extends StatefulWidget {
  final int courseId;
  const TopicsScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  int? _expandedIndex;   // which topic is expanded

  static const Color skyBlue = Color(0xFF5F9DF2);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Course Topics',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black87,
      ),
      floatingActionButton: const AIChatFab(),
      body: FutureBuilder<List<Topic>>(
        future: ApiService.getTopics(widget.courseId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(skyBlue),
              ),
            );
          }
          if (snapshot.hasError) {
            return _buildError(snapshot.error.toString());
          }
          final topics = snapshot.data ?? [];
          if (topics.isEmpty) {
            return _buildEmpty();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: topics.length,
            itemBuilder: (context, index) {
              return _TopicAccordionCard(
                topic: topics[index],
                index: index,
                isExpanded: _expandedIndex == index,
                onToggle: () {
                  setState(() {
                    _expandedIndex = _expandedIndex == index ? null : index;
                  });
                },
                courseId: widget.courseId,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildError(String error) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.error_outline, color: Colors.red, size: 48),
      const SizedBox(height: 12),
      Text(error, textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600)),
    ]),
  );

  Widget _buildEmpty() => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.menu_book_rounded, size: 64, color: Colors.grey.shade300),
      const SizedBox(height: 12),
      Text('No topics available', style: TextStyle(color: Colors.grey.shade500)),
    ]),
  );
}

// ── Accordion Card ─────────────────────────────────────────────
class _TopicAccordionCard extends StatelessWidget {
  final Topic topic;
  final int index;
  final bool isExpanded;
  final VoidCallback onToggle;
  final int courseId;

  const _TopicAccordionCard({
    required this.topic,
    required this.index,
    required this.isExpanded,
    required this.onToggle,
    required this.courseId,
  });

  static const Color skyBlue = Color(0xFF5F9DF2);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isExpanded ? skyBlue.withOpacity(0.5) : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isExpanded
                ? skyBlue.withOpacity(0.12)
                : Colors.black.withOpacity(0.06),
            blurRadius: isExpanded ? 14 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header (always visible) ─────────────────────
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Number circle
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isExpanded
                            ? [skyBlue, const Color(0xFF9C27B0)]
                            : [Colors.grey.shade300, Colors.grey.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isExpanded ? skyBlue : null,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Tap to ${isExpanded ? "collapse" : "explore subtopics"}',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                  // Arrow
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        color: isExpanded ? skyBlue : Colors.grey.shade400,
                        size: 28),
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded Content ────────────────────────────
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                Divider(
                  height: 1,
                  color: skyBlue.withOpacity(0.2),
                  indent: 16,
                  endIndent: 16,
                ),
                const SizedBox(height: 8),
                // "View all subtopics" button
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: _SubtopicPreview(topicId: topic.id),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Subtopic Preview inside accordion ─────────────────────────
class _SubtopicPreview extends StatelessWidget {
  final int topicId;
  const _SubtopicPreview({required this.topicId});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
        label: const Text('View Subtopics',
            style: TextStyle(fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5F9DF2),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) =>
                  SubtopicsScreen(topicId: topicId),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        },
      ),
    );
  }
}