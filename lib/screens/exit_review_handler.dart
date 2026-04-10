// ============================================================
// File     : lib/widgets/exit_review_handler.dart
// Usage    : Wrap your HomeScreen Scaffold with ExitReviewHandler
//            instead of WillPopScope directly.
// ============================================================
//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:navaveda/generated/app_localizations.dart';
//
// class ExitReviewHandler extends StatefulWidget {
//   final Widget child;
//   const ExitReviewHandler({Key? key, required this.child}) : super(key: key);
//
//   @override
//   State<ExitReviewHandler> createState() => _ExitReviewHandlerState();
// }
//
// class _ExitReviewHandlerState extends State<ExitReviewHandler> {
//   Future<bool> _onWillPop() async {
//     final result = await showModalBottomSheet<bool>(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (_) => const _ReviewBottomSheet(),
//     );
//     return result ?? false;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: widget.child,
//     );
//   }
// }
//
// // ── Review Bottom Sheet ────────────────────────────────────────
// class _ReviewBottomSheet extends StatefulWidget {
//   const _ReviewBottomSheet();
//
//   @override
//   State<_ReviewBottomSheet> createState() => _ReviewBottomSheetState();
// }
//
// class _ReviewBottomSheetState extends State<_ReviewBottomSheet>
//     with SingleTickerProviderStateMixin {
//   int _rating = 0;
//   bool _submitted = false;
//   late AnimationController _controller;
//   late Animation<double> _scaleAnim;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
//     _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
//     _controller.forward();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void _submitReview() async {
//     if (_rating == 0) return;
//     setState(() => _submitted = true);
//     // TODO: send rating to backend or Google Play API
//     await Future.delayed(const Duration(milliseconds: 1800));
//     if (mounted) Navigator.of(context).pop(true); // exit app
//   }
//
//   void _skipAndExit() => Navigator.of(context).pop(true);
//   void _stayInApp() => Navigator.of(context).pop(false);
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final loc = AppLocalizations.of(context);
//
//     return ScaleTransition(
//       scale: _scaleAnim,
//       child: Container(
//         decoration: BoxDecoration(
//           color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
//           borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
//         ),
//         padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
//         child: _submitted ? _buildThankYou(loc) : _buildReviewForm(isDark, loc),
//       ),
//     );
//   }
//
//   Widget _buildReviewForm(bool isDark, AppLocalizations loc) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         // Handle
//         Center(
//           child: Container(
//             width: 40, height: 4,
//             decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10)),
//           ),
//         ),
//         const SizedBox(height: 20),
//
//         // App icon + title
//         Container(
//           width: 64, height: 64,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(18),
//             gradient: const LinearGradient(colors: [Color(0xFF4776E6), Color(0xFF8E54E9)]),
//           ),
//           child: const Icon(Icons.remove_red_eye_rounded, color: Colors.white, size: 34),
//         ),
//         const SizedBox(height: 14),
//         Text(loc.leaveReview, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 8),
//         Text(loc.reviewPrompt, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.5)),
//         const SizedBox(height: 24),
//
//         // Star rating
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: List.generate(5, (i) => GestureDetector(
//             onTap: () => setState(() => _rating = i + 1),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 6),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 child: Icon(
//                   i < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
//                   color: i < _rating ? Colors.amber : Colors.grey.shade400,
//                   size: 42,
//                 ),
//               ),
//             ),
//           )),
//         ),
//         const SizedBox(height: 28),
//
//         // Buttons
//         Row(
//           children: [
//             Expanded(
//               child: OutlinedButton(
//                 onPressed: _stayInApp,
//                 style: OutlinedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//                 child: Text(loc.no),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               flex: 2,
//               child: ElevatedButton(
//                 onPressed: _rating > 0 ? _submitReview : null,
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   backgroundColor: const Color(0xFF4776E6),
//                 ),
//                 child: Text(loc.submitReview, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         TextButton(
//           onPressed: _skipAndExit,
//           child: Text(loc.skip, style: TextStyle(color: Colors.grey.shade500)),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildThankYou(AppLocalizations loc) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const SizedBox(height: 20),
//         // Animated checkmark
//         TweenAnimationBuilder<double>(
//           tween: Tween(begin: 0.0, end: 1.0),
//           duration: const Duration(milliseconds: 600),
//           curve: Curves.elasticOut,
//           builder: (_, v, __) => Transform.scale(
//             scale: v,
//             child: Container(
//               width: 80, height: 80,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: const LinearGradient(colors: [Color(0xFF11998E), Color(0xFF38EF7D)]),
//                 boxShadow: [BoxShadow(color: const Color(0xFF11998E).withOpacity(0.4), blurRadius: 20, spreadRadius: 4)],
//               ),
//               child: const Icon(Icons.check_rounded, color: Colors.white, size: 44),
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),
//         Text(loc.thankYou, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 8),
//         Text(loc.thankYouMessage, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5)),
//         const SizedBox(height: 24),
//         // Stars display
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: List.generate(5, (i) => Icon(
//             i < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
//             color: i < _rating ? Colors.amber : Colors.grey.shade300,
//             size: 30,
//           )),
//         ),
//         const SizedBox(height: 30),
//         const LinearProgressIndicator(),
//         const SizedBox(height: 8),
//         Text('Closing app...', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
//         const SizedBox(height: 16),
//       ],
//     );
//   }
// }


// ============================================================
// File     : lib/widgets/exit_review_handler.dart
//
// Data Firebase madhe store hoto:
// Path: /app_feedback/{userId}/{autoId}
//   rating: 4
//   feedback: "AI chatbot better kara"
//   timestamp: "2026-03-27T..."
//   appVersion: "1.0.0"
//   hasFeedback: true
// ============================================================

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ExitReviewHandler extends StatefulWidget {
  final Widget child;
  const ExitReviewHandler({Key? key, required this.child}) : super(key: key);

  @override
  State<ExitReviewHandler> createState() => _ExitReviewHandlerState();
}

class _ExitReviewHandlerState extends State<ExitReviewHandler> {
  Future<bool> _onWillPop() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: false,
      builder: (_) => const _ReviewSheet(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: widget.child,
    );
  }
}

class _ReviewSheet extends StatefulWidget {
  const _ReviewSheet();
  @override
  State<_ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends State<_ReviewSheet>
    with SingleTickerProviderStateMixin {
  int _rating = 0;
  bool _submitted = false;
  bool _isSaving = false;
  bool _showFeedbackBox = false;
  final TextEditingController _feedbackController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _slideAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic);
    _animController.forward();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _saveToFirebase() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid ?? 'anonymous_${DateTime.now().millisecondsSinceEpoch}';
      final feedback = _feedbackController.text.trim();

      await FirebaseDatabase.instance
          .ref()
          .child('app_feedback')
          .child(uid)
          .push()
          .set({
        'rating': _rating,
        'feedback': feedback,
        'timestamp': DateTime.now().toIso8601String(),
        'appVersion': '1.0.0',
        'hasFeedback': feedback.isNotEmpty,
      });
    } catch (e) {
      debugPrint('Feedback save error: \$e');
      // Error asla tari exit hoto - user la block nahi
    }
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a star rating first!'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    setState(() => _isSaving = true);
    await _saveToFirebase();
    if (mounted) setState(() { _isSaving = false; _submitted = true; });
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) Navigator.of(context).pop(true);
  }

  void _skipAndExit() => Navigator.of(context).pop(true);
  void _stayInApp() => Navigator.of(context).pop(false);

  void _onRatingSelected(int rating) {
    setState(() { _rating = rating; _showFeedbackBox = true; });
  }

  String _ratingLabel(int r) {
    const labels = ['', 'Poor', 'Fair', 'Good', 'Great', 'Excellent'];
    const emojis = ['', 'DART_SKIP', 'DART_SKIP', 'DART_SKIP', 'DART_SKIP', 'DART_SKIP'];
    return r > 0 ? labels[r] : '';
  }

  Color _ratingColor(int r) {
    if (r <= 1) return Colors.red;
    if (r == 2) return Colors.orange;
    if (r == 3) return Colors.blue;
    if (r == 4) return const Color(0xFF11998E);
    return const Color(0xFF4776E6);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _slideAnim,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, 60 * (1 - _slideAnim.value)),
        child: Opacity(opacity: _slideAnim.value, child: child),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, -4))],
        ),
        padding: EdgeInsets.only(top: 12, left: 24, right: 24, bottom: MediaQuery.of(context).viewInsets.bottom + 28),
        child: _submitted ? _buildThankYou(isDark) : _buildForm(isDark),
      ),
    );
  }

  Widget _buildForm(bool isDark) {
    return SingleChildScrollView(
      child:Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle bar
        Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)))),
        const SizedBox(height: 20),

        // Header row
        Row(
          children: [
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(colors: [Color(0xFF4776E6), Color(0xFF8E54E9)]),
              ),
              child: const Icon(Icons.school_rounded, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enjoying NavaVeda?', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                  Text('Help us improve!', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
            ),
            GestureDetector(onTap: _stayInApp, child: Icon(Icons.close_rounded, color: Colors.grey.shade400, size: 22)),
          ],
        ),
        const SizedBox(height: 22),

        // Star rating
        Text('Rate your experience', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            final selected = i < _rating;
            return GestureDetector(
              onTap: () => _onRatingSelected(i + 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 5),
                child: Icon(
                  selected ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: selected ? Colors.amber : Colors.grey.shade300,
                  size: selected ? 46 : 40,
                ),
              ),
            );
          }),
        ),
        if (_rating > 0) ...[
          const SizedBox(height: 8),
          Text(
            ['', 'Poor 😞', 'Fair 😐', 'Good 🙂', 'Great 😊', 'Excellent 🤩'][_rating],
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _ratingColor(_rating)),
          ),
        ],

        // Feedback box — rating dil'yavar dakhav
        AnimatedSize(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          child: _showFeedbackBox
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF252525) : const Color(0xFFF0F4FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF4776E6).withOpacity(0.25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFF4776E6), size: 16),
                        const SizedBox(width: 6),
                        const Text('What can we improve?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF4776E6))),
                        const Spacer(),
                        Text('Optional', style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _feedbackController,
                      maxLines: 3,
                      maxLength: 300,
                      decoration: InputDecoration(
                        hintText: 'e.g. More courses, faster AI, better UI...',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                        border: InputBorder.none,
                        counterStyle: TextStyle(fontSize: 10, color: Colors.grey.shade400),
                      ),
                      style: TextStyle(fontSize: 14, color: isDark ? Colors.white : Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: 22),

        // Buttons
        _isSaving
            ? const Center(child: SizedBox(height: 32, width: 32, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation(Color(0xFF4776E6)))))
            : Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4776E6),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: Text(
                  _rating > 0 ? 'Submit & Exit' : 'Select Rating to Submit',
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TextButton(
              onPressed: _skipAndExit,
              child: Text('Skip & Exit', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
            ),
          ],
        ),
      ],
    ),
    );
  }

  Widget _buildThankYou(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 24),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 700),
          curve: Curves.elasticOut,
          builder: (_, v, __) => Transform.scale(
            scale: v,
            child: Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [Color(0xFF11998E), Color(0xFF38EF7D)]),
                boxShadow: [BoxShadow(color: const Color(0xFF11998E).withOpacity(0.3), blurRadius: 20, spreadRadius: 4)],
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 44),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text('Thank You! 🎉', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
        const SizedBox(height: 8),
        Text(
          _feedbackController.text.trim().isNotEmpty
              ? 'Rating + feedback saved!\nWe will work on your suggestions.'
              : 'Rating saved!\nSee you next time!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade500, height: 1.5),
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) => Icon(
            i < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
            color: i < _rating ? Colors.amber : Colors.grey.shade300,
            size: 28,
          )),
        ),
        const SizedBox(height: 22),
        const SizedBox(width: 160, child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(0xFF4776E6)), backgroundColor: Color(0xFFE8EDFF))),
        const SizedBox(height: 8),
        Text('Closing app...', style: TextStyle(fontSize: 12, color: Colors.grey.shade400)),
        const SizedBox(height: 20),
      ],
    );
  }
}