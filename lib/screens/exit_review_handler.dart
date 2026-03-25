// ============================================================
// File     : lib/widgets/exit_review_handler.dart
// Usage    : Wrap your HomeScreen Scaffold with ExitReviewHandler
//            instead of WillPopScope directly.
// ============================================================

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:realeyes/generated/app_localizations.dart';

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
      builder: (_) => const _ReviewBottomSheet(),
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

// ── Review Bottom Sheet ────────────────────────────────────────
class _ReviewBottomSheet extends StatefulWidget {
  const _ReviewBottomSheet();

  @override
  State<_ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<_ReviewBottomSheet>
    with SingleTickerProviderStateMixin {
  int _rating = 0;
  bool _submitted = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitReview() async {
    if (_rating == 0) return;
    setState(() => _submitted = true);
    // TODO: send rating to backend or Google Play API
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) Navigator.of(context).pop(true); // exit app
  }

  void _skipAndExit() => Navigator.of(context).pop(true);
  void _stayInApp() => Navigator.of(context).pop(false);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);

    return ScaleTransition(
      scale: _scaleAnim,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: _submitted ? _buildThankYou(loc) : _buildReviewForm(isDark, loc),
      ),
    );
  }

  Widget _buildReviewForm(bool isDark, AppLocalizations loc) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle
        Center(
          child: Container(
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 20),

        // App icon + title
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(colors: [Color(0xFF4776E6), Color(0xFF8E54E9)]),
          ),
          child: const Icon(Icons.remove_red_eye_rounded, color: Colors.white, size: 34),
        ),
        const SizedBox(height: 14),
        Text(loc.leaveReview, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(loc.reviewPrompt, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.5)),
        const SizedBox(height: 24),

        // Star rating
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) => GestureDetector(
            onTap: () => setState(() => _rating = i + 1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  i < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: i < _rating ? Colors.amber : Colors.grey.shade400,
                  size: 42,
                ),
              ),
            ),
          )),
        ),
        const SizedBox(height: 28),

        // Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _stayInApp,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(loc.no),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _rating > 0 ? _submitReview : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: const Color(0xFF4776E6),
                ),
                child: Text(loc.submitReview, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _skipAndExit,
          child: Text(loc.skip, style: TextStyle(color: Colors.grey.shade500)),
        ),
      ],
    );
  }

  Widget _buildThankYou(AppLocalizations loc) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        // Animated checkmark
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (_, v, __) => Transform.scale(
            scale: v,
            child: Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [Color(0xFF11998E), Color(0xFF38EF7D)]),
                boxShadow: [BoxShadow(color: const Color(0xFF11998E).withOpacity(0.4), blurRadius: 20, spreadRadius: 4)],
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 44),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(loc.thankYou, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(loc.thankYouMessage, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5)),
        const SizedBox(height: 24),
        // Stars display
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) => Icon(
            i < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
            color: i < _rating ? Colors.amber : Colors.grey.shade300,
            size: 30,
          )),
        ),
        const SizedBox(height: 30),
        const LinearProgressIndicator(),
        const SizedBox(height: 8),
        Text('Closing app...', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
        const SizedBox(height: 16),
      ],
    );
  }
}
