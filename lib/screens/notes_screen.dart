
// lib/screens/notes_screen.dart
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:navaveda/models/notes.dart';
import 'package:navaveda/models/study_session_request.dart';
import 'package:navaveda/services/api_service.dart';
import 'package:navaveda/screens/quiz_screen.dart';
import 'package:navaveda/features/profile/widgets/ai_chat_fab.dart';

class NotesScreen extends StatefulWidget {
  final int subtopicId;
  final int topicId;
  final bool isCompleted;

  const NotesScreen({
    Key? key,
    required this.subtopicId,
    required this.topicId,
    required this.isCompleted,
  }) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {

  // ── Backend logic — unchanged ──────────────────────────────
  DateTime? _startTime;
  bool _sessionSent = false;
  bool _quizEnabled = false;
  Timer? _timer;
  // int _secondsLeft = 40;

  // ── UI state ────────────────────────────────────────────────
  late AnimationController _quizBtnController;
  late Animation<double> _quizBtnScale;
  late AnimationController _timerController;

  static const Color skyBlue   = Color(0xFF5F9DF2);
  static const Color purple    = Color(0xFF9C27B0);
  static const Color lightSky  = Color(0xFFE3F2FD);
  static const Color darkBg    = Color(0xFF0F0F0F);
  static const Color lightBg   = Color(0xFFF5F7FA);

  // Section accent colors — each section gets a different color
  static const List<Color> _sectionColors = [
    Color(0xFF5F9DF2),
    Color(0xFF9C27B0),
    Color(0xFF11998E),
    Color(0xFFF7971E),
    Color(0xFFED213A),
    Color(0xFF4776E6),
    Color(0xFF38EF7D),
    Color(0xFFFC5C7D),
  ];

  static const List<IconData> _sectionIcons = [
    Icons.lightbulb_rounded,
    Icons.explore_rounded,
    Icons.timeline_rounded,
    Icons.hub_rounded,
    Icons.bolt_rounded,
    Icons.layers_rounded,
    Icons.auto_awesome_rounded,
    Icons.star_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    WidgetsBinding.instance.addObserver(this);

    // Quiz button animation
    _quizBtnController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _quizBtnScale = CurvedAnimation(
        parent: _quizBtnController, curve: Curves.elasticOut);

    // Timer animation controller (for circular countdown)
    _timerController = AnimationController(
        vsync: this, duration: const Duration(seconds: 40));

    if (!widget.isCompleted) {
      _timerController.forward();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!_quizEnabled) {
          final elapsed =
              DateTime.now().difference(_startTime!).inSeconds;
          // if (mounted) {
          //   setState(() => _secondsLeft = (40 - elapsed).clamp(0, 40));
          // }
          if (elapsed >= 40) {
            if (mounted) {
              setState(() => _quizEnabled = true);
              _quizBtnController.forward();
            }
            timer.cancel();
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _quizBtnController.dispose();
    _timerController.dispose();
    _endStudySession();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _endStudySession();
    }
  }

  // ── Backend logic — DO NOT CHANGE ──────────────────────────
  void _endStudySession() {
    if (_sessionSent) return;
    final endTime = DateTime.now();
    final duration = endTime.difference(_startTime!).inSeconds;
    if (duration >= 40) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      ApiService.sendStudySession(StudySessionRequest(
        firebaseUid: user.uid,
        subtopicId: widget.subtopicId,
        startTime: _startTime!,
        endTime: endTime,
      )).catchError((e) => print('session error: $e'));
    }
    _sessionSent = true;
  }

  void _goToQuiz() {
    if (widget.isCompleted) return;
    _endStudySession();
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => QuizScreen(
          subtopicId: widget.subtopicId, topicId: widget.topicId),
    ));
  }

  // ── Parse markdown into sections ────────────────────────────
  /// Splits content by ## headings → returns list of {title, body}
  List<Map<String, String>> _parseSections(String raw) {
    // Normalize

    // final content = raw
    //     .replaceAll(r'\n', '\n')
    //     .replaceAll('â', '–')
    //     .trim();
    final content = raw
        .replaceAll('\\n', '\n')
        .replaceAll(r'\n', '\n')
        .replaceAll('â', '–')
        .replaceAll('â', '"')
        .replaceAll('â', '"')
        .replaceAll('â', "'")
        .trim();


    final lines = content.split('\n');
    final sections = <Map<String, String>>[];

    String? currentTitle;
    final buffer = StringBuffer();
    String? introText; // text before first ## heading

    for (final line in lines) {
      if (line.startsWith('## ')) {
        // Save previous section
        if (currentTitle != null) {
          sections.add({
            'title': currentTitle,
            'body': buffer.toString().trim(),
          });
          buffer.clear();
        } else if (buffer.isNotEmpty) {
          // Text before first ## → intro section
          introText = buffer.toString().trim();
          buffer.clear();
        }
        currentTitle = line.replaceFirst('## ', '').trim();
      } else if (line.startsWith('# ')) {
        // Main title — put in intro
        if (buffer.isNotEmpty) {
          introText = (introText ?? '') + buffer.toString().trim();
          buffer.clear();
        }
        introText = (introText ?? '') +
            '# ${line.replaceFirst('# ', '').trim()}\n';
      } else {
        buffer.writeln(line);
      }
    }

    // Last section
    if (currentTitle != null && buffer.isNotEmpty) {
      sections.add({
        'title': currentTitle,
        'body': buffer.toString().trim(),
      });
    }

    // If no ## headings found — put everything as single section
    if (sections.isEmpty) {
      sections.add({'title': 'Notes', 'body': content});
    }

    return sections;
  }

  bool _hasValidCode(String code) {
    final trimmed = code.trim();
    if (trimmed.isEmpty) return false;
    return trimmed.replaceAll(RegExp(r'[\s<>\-_=\.]'), '').length > 5;
  }

  // ── BUILD ────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? darkBg : lightBg,
      appBar: AppBar(
        title: const Text('Lesson Notes',
            style: TextStyle(fontWeight: FontWeight.bold)),
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
        actions: [
          // Countdown timer in AppBar
          if (!widget.isCompleted && !_quizEnabled)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              // child: _CountdownBadge(
              //   secondsLeft: _secondsLeft,
              //   controller: _timerController,
              // ),
            ),
        ],
      ),
      floatingActionButton: const AIChatFab(),
      body: FutureBuilder<Notes>(
        future: ApiService.getNotes(widget.subtopicId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(skyBlue),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text('${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            );
          }

          final note = snapshot.data!;
          final sections = _parseSections(note.content);


          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Hero banner ────────────────────────────────
              SliverToBoxAdapter(
                child: _HeroBanner(
                  title: sections.isNotEmpty &&
                      sections[0]['body']!.startsWith('# ')
                      ? sections[0]['title']!
                      : 'Lesson Notes',
                  sectionCount: sections.length,
                  isDark: isDark,
                ),
              ),

              // ── Reading progress indicator ─────────────────
              SliverToBoxAdapter(
                child: _ReadingProgressBar(
                  total: sections.length,
                  isDark: isDark,
                ),
              ),

              // ── Section cards ──────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final section = sections[index];
                      final color = _sectionColors[
                      index % _sectionColors.length];
                      final icon = _sectionIcons[
                      index % _sectionIcons.length];

                      return _SectionCard(
                        index: index,
                        title: section['title']!,
                        body: section['body']!,
                        accentColor: color,
                        icon: icon,
                        isDark: isDark,
                      );
                    },
                    childCount: sections.length,
                  ),
                ),
              ),

              // ── Code card ──────────────────────────────────
              if (_hasValidCode(note.codeExample))
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverToBoxAdapter(
                    child: _CodeCard(
                        code: note.codeExample, isDark: isDark),
                  ),
                ),

              // ── Quiz / Completion ───────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
                sliver: SliverToBoxAdapter(
                  child: widget.isCompleted
                      ? _CompletionCard(isDark: isDark)
                      : _QuizUnlockWidget(
                    quizEnabled: _quizEnabled,
                    // secondsLeft: _secondsLeft,
                    controller: _quizBtnController,
                    scaleAnim: _quizBtnScale,
                    onTap: _goToQuiz,
                    isDark: isDark,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }


}

// ──────────────────────────────────────────────────────────────
// HERO BANNER
// ──────────────────────────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  final String title;
  final int sectionCount;
  final bool isDark;

  const _HeroBanner({
    required this.title,
    required this.sectionCount,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF5F9DF2), Color(0xFF9C27B0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5F9DF2).withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background decoration circles
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            left: -10,
            bottom: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$sectionCount Sections • Tap to expand',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.menu_book_rounded,
                        color: Colors.white70, size: 14),
                    SizedBox(width: 4),
                    Text('Read all sections to unlock quiz',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// READING PROGRESS BAR
// ──────────────────────────────────────────────────────────────
class _ReadingProgressBar extends StatelessWidget {
  final int total;
  final bool isDark;
  const _ReadingProgressBar({required this.total, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Lesson Content',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF5F9DF2).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$total sections',
              style: const TextStyle(
                  color: Color(0xFF5F9DF2),
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// SECTION CARD — expandable accordion
// ──────────────────────────────────────────────────────────────
class _SectionCard extends StatefulWidget {
  final int index;
  final String title;
  final String body;
  final Color accentColor;
  final IconData icon;
  final bool isDark;

  const _SectionCard({
    required this.index,
    required this.title,
    required this.body,
    required this.accentColor,
    required this.icon,
    required this.isDark,
  });

  @override
  State<_SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<_SectionCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    // First card auto-expanded
    _expanded = widget.index == 0;
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _expandAnim =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    if (_expanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _expanded
              ? widget.accentColor.withOpacity(0.4)
              : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _expanded
                ? widget.accentColor.withOpacity(0.12)
                : Colors.black.withOpacity(0.05),
            blurRadius: _expanded ? 16 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(

        children: [
          // ── Header ────────────────────────────────────────
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                children: [
                  // Section number + icon
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _expanded
                            ? [
                          widget.accentColor,
                          widget.accentColor.withOpacity(0.7)
                        ]
                            : [
                          Colors.grey.shade300,
                          Colors.grey.shade400
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: _expanded
                          ? [
                        BoxShadow(
                          color: widget.accentColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(widget.icon,
                            color: Colors.white, size: 18),
                        Text(
                          '${widget.index + 1}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _expanded
                                ? widget.accentColor
                                : (widget.isDark
                                ? Colors.white
                                : Colors.black87),
                          ),
                        ),
                        if (!_expanded)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              _getPreview(widget.body),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Expand/collapse arrow
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: _expanded
                          ? widget.accentColor
                          : Colors.grey.shade400,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Expanded body ──────────────────────────────────
          SizeTransition(

            sizeFactor: _expandAnim,
            child: Column(

              children: [

                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.accentColor.withOpacity(0.0),
                        widget.accentColor.withOpacity(0.3),
                        widget.accentColor.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),

                Padding(

                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  child: MarkdownBody(

                    data: widget.body,
                    selectable: true,

                    styleSheet: MarkdownStyleSheet(

                      h3: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: widget.isDark
                            ? Colors.white
                            : widget.accentColor,
                      ),
                      p: TextStyle(
                        fontSize: 15,
                        height: 1.65,
                        color: widget.isDark
                            ? Colors.grey.shade300
                            : const Color(0xFF2C3E50),
                      ),
                      strong: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: widget.isDark
                            ? Colors.white
                            : widget.accentColor,
                      ),
                      em: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: widget.isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                      listBullet: TextStyle(
                        fontSize: 15,
                        color: widget.isDark
                            ? Colors.grey.shade300
                            : const Color(0xFF2C3E50),
                      ),
                      listBulletPadding:
                      const EdgeInsets.only(left: 8),
                      blockquote: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade500,
                      ),
                      blockquoteDecoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                              color: widget.accentColor, width: 3),
                        ),
                        color:
                        widget.accentColor.withOpacity(0.05),
                      ),
                      code: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        color: widget.accentColor,
                        backgroundColor: widget.accentColor
                            .withOpacity(0.08),
                      ),
                      codeblockDecoration: BoxDecoration(
                        color: widget.isDark
                            ? Colors.grey.shade900
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                          widget.accentColor.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// First 80 chars of body as preview text (strips markdown)
  String _getPreview(String body) {
    final clean = body
        .replaceAll(RegExp(r'[#*_`>-]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return clean.length > 80 ? '${clean.substring(0, 80)}…' : clean;
  }
}

// ──────────────────────────────────────────────────────────────
// CODE CARD
// ──────────────────────────────────────────────────────────────
class _CodeCard extends StatefulWidget {
  final String code;
  final bool isDark;
  const _CodeCard({required this.code, required this.isDark});

  @override
  State<_CodeCard> createState() => _CodeCardState();
}

class _CodeCardState extends State<_CodeCard> {
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isDark
            ? const Color(0xFF1A1A1A)
            : const Color(0xFF1E2A3A),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                // Terminal dots
                Row(
                  children: [
                    _Dot(color: Colors.red.shade400),
                    const SizedBox(width: 6),
                    _Dot(color: Colors.yellow.shade400),
                    const SizedBox(width: 6),
                    _Dot(color: Colors.green.shade400),
                  ],
                ),
                const SizedBox(width: 12),
                const Text(
                  'Code Example',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                // Copy button
                GestureDetector(
                  onTap: () async {
                    // Copy to clipboard
                    setState(() => _copied = true);
                    await Future.delayed(
                        const Duration(seconds: 2));
                    if (mounted) {
                      setState(() => _copied = false);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _copied
                              ? Icons.check_rounded
                              : Icons.copy_rounded,
                          color: _copied
                              ? Colors.green.shade300
                              : Colors.white70,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _copied ? 'Copied!' : 'Copy',
                          style: TextStyle(
                            color: _copied
                                ? Colors.green.shade300
                                : Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Code body
          Padding(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              widget.code,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                color: Color(0xFFADD8E6),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});
  @override
  Widget build(BuildContext context) =>
      Container(width: 10, height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color));
}

// ──────────────────────────────────────────────────────────────
// QUIZ UNLOCK WIDGET
// ──────────────────────────────────────────────────────────────
// class _QuizUnlockWidget extends StatelessWidget {
//   final bool quizEnabled;
//   final int secondsLeft;
//   final AnimationController controller;
//   final Animation<double> scaleAnim;
//   final VoidCallback onTap;
//   final bool isDark;
//
//   const _QuizUnlockWidget({
//     required this.quizEnabled,
//     // required this.secondsLeft,
//     required this.controller,
//     required this.scaleAnim,
//     required this.onTap,
//     required this.isDark,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     if (!quizEnabled) {
//       // Locked state — show countdown
//       return Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: isDark
//               ? const Color(0xFF1A1A1A)
//               : Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//               color: Colors.grey.withOpacity(0.2)),
//         ),
//         child: Row(
//           children: [
//             // Circular countdown
//             SizedBox(
//               width: 56,
//               height: 56,
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   CircularProgressIndicator(
//                     value: secondsLeft / 40,
//                     backgroundColor: Colors.grey.shade200,
//                     valueColor: const AlwaysStoppedAnimation(
//                         Color(0xFF5F9DF2)),
//                     strokeWidth: 4,
//                   ),
//                   Text(
//                     '$secondsLeft',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                       color: Color(0xFF5F9DF2),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Quiz unlocks in $secondsLeft sec',
//                     style: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 15),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     'Keep reading to unlock the quiz!',
//                     style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey.shade500),
//                   ),
//                 ],
//               ),
//             ),
//             const Icon(Icons.lock_rounded,
//                 color: Colors.grey, size: 22),
//           ],
//         ),
//       );
//     }
//
//     // Unlocked state — animated button
//     return ScaleTransition(
//       scale: scaleAnim,
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(vertical: 18),
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               colors: [Color(0xFF5F9DF2), Color(0xFF9C27B0)],
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//             ),
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xFF5F9DF2).withOpacity(0.4),
//                 blurRadius: 20,
//                 offset: const Offset(0, 8),
//               ),
//             ],
//           ),
//           child: const Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.lock_open_rounded,
//                   color: Colors.white, size: 22),
//               SizedBox(width: 10),
//               Text(
//                 'Take Quiz  🎯',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//
//
//   }
// }


class _QuizUnlockWidget extends StatelessWidget {
  final bool quizEnabled;
  final AnimationController controller;
  final Animation<double> scaleAnim;
  final VoidCallback onTap;
  final bool isDark;

  const _QuizUnlockWidget({
    required this.quizEnabled,
    required this.controller,
    required this.scaleAnim,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (!quizEnabled) {
      // Simple locked state — no countdown display
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_rounded,
                  color: Colors.grey, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quiz Locked',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('Read the notes to unlock the quiz',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Unlocked — animated button
    return ScaleTransition(
      scale: scaleAnim,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5F9DF2), Color(0xFF9C27B0)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5F9DF2).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_open_rounded,
                  color: Colors.white, size: 22),
              SizedBox(width: 10),
              Text('Take Quiz  🎯',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// COMPLETION CARD
// ──────────────────────────────────────────────────────────────
class _CompletionCard extends StatelessWidget {
  final bool isDark;
  const _CompletionCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lesson Completed! 🎉',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'You have already mastered this topic.',
                  style: TextStyle(
                      color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// COUNTDOWN BADGE (AppBar action)
// ──────────────────────────────────────────────────────────────
class _CountdownBadge extends StatelessWidget {
  final int secondsLeft;
  final AnimationController controller;

  const _CountdownBadge({
    required this.secondsLeft,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF5F9DF2).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: const Color(0xFF5F9DF2).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_rounded,
              color: Color(0xFF5F9DF2), size: 14),
          const SizedBox(width: 4),
          Text(
            '${secondsLeft}s',
            style: const TextStyle(
              color: Color(0xFF5F9DF2),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}