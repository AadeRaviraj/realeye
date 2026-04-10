// ============================================================
// File     : lib/features/profile/widgets/profile_tab.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import 'package:navaveda/features/profile/providers/profile_provider.dart';
import 'package:navaveda/features/profile/screens/subscription_screen.dart';
import 'package:navaveda/models/dashboard_data.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _celebrate() => _confettiController.play();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    if (provider.isLoadingDashboard && provider.dashboardData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.dashboardError != null && provider.dashboardData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 8),
            Text('Could not load data',
                style: TextStyle(color: Colors.grey.shade600)),
            TextButton(
                onPressed: provider.loadDashboard, child: const Text('Retry')),
          ],
        ),
      );
    }

    final data = provider.dashboardData;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _EmailCard(email: provider.userEmail),
              const SizedBox(height: 20),
              if (data != null)
                _ProgressCard(
                  progress: data.completionPercentage / 100,
                  completionPercentage: data.completionPercentage,
                  onCelebrate: _celebrate,
                ),
              const SizedBox(height: 20),
              if (data != null) _QuickStatsRow(data: data),
              const SizedBox(height: 20),
              // _SubscriptionCard(
              //   onManagePressed: () => Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) => const SubscriptionScreen()),
              //   ),
              // ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
          ),
        ),
      ],
    );
  }
}

// ── Email Card ─────────────────────────────────────────────────
class _EmailCard extends StatelessWidget {
  final String email;
  const _EmailCard({required this.email});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withOpacity(0.12),
              ),
              child: Icon(Icons.email_rounded,
                  color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade600)),
                  const SizedBox(height: 4),
                  Text(email,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.copy_rounded,
                  color: Theme.of(context).colorScheme.primary, size: 20),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: email));
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email copied!')));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Progress Card ──────────────────────────────────────────────
class _ProgressCard extends StatelessWidget {
  final double progress;
  final double completionPercentage;
  final VoidCallback onCelebrate;

  const _ProgressCard({
    required this.progress,
    required this.completionPercentage,
    required this.onCelebrate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4776E6).withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      // padding: const EdgeInsets.all(20),
      // child: Row(
      //   children: [
      //     SizedBox(
      //       width: 90,
      //       height: 90,
      //       child: Stack(
      //         alignment: Alignment.center,
      //         children: [
      //           CircularProgressIndicator(
      //             value: progress,
      //             strokeWidth: 8,
      //             backgroundColor: Colors.white.withOpacity(0.25),
      //             valueColor:
      //                 const AlwaysStoppedAnimation(Colors.white),
      //           ),
      //           Text(
      //             '${completionPercentage.toInt()}%',
      //             style: const TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 18,
      //                 fontWeight: FontWeight.bold),
      //           ),
      //         ],
      //       ),
      //     ),
      //     const SizedBox(width: 20),
      //     // Expanded(
      //     //   child: Column(
      //     //     crossAxisAlignment: CrossAxisAlignment.start,
      //     //     children: [
      //     //       const Text('Learning Progress',
      //     //           style: TextStyle(
      //     //               color: Colors.white,
      //     //               fontSize: 17,
      //     //               fontWeight: FontWeight.bold)),
      //     //       const SizedBox(height: 6),
      //     //       Text(
      //     //         'Completed ${completionPercentage.toStringAsFixed(1)}% of all subtopics',
      //     //         style: TextStyle(
      //     //             color: Colors.white.withOpacity(0.85),
      //     //             fontSize: 13),
      //     //       ),
      //     //       const SizedBox(height: 12),
      //     //       GestureDetector(
      //     //         onTap: onCelebrate,
      //     //         child: Container(
      //     //           padding: const EdgeInsets.symmetric(
      //     //               horizontal: 14, vertical: 6),
      //     //           decoration: BoxDecoration(
      //     //             color: Colors.white.withOpacity(0.2),
      //     //             borderRadius: BorderRadius.circular(20),
      //     //           ),
      //     //           child: const Row(
      //     //             mainAxisSize: MainAxisSize.min,
      //     //             children: [
      //     //               Icon(Icons.celebration,
      //     //                   color: Colors.white, size: 16),
      //     //               SizedBox(width: 6),
      //     //               Text('Celebrate!',
      //     //                   style: TextStyle(
      //     //                       color: Colors.white, fontSize: 13)),
      //     //             ],
      //     //           ),
      //     //         ),
      //     //       ),
      //     //     ],
      //     //   ),
      //     // ),
      //   ],
      // ),
    );
  }
}

// ── Quick Stats Row ────────────────────────────────────────────
class _QuickStatsRow extends StatelessWidget {
  final DashboardData data;
  const _QuickStatsRow({required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatChip(
            icon: Icons.today,
            label: 'Today',
            value: '${data.todayMinutes}m',
            color: Colors.blue),
        const SizedBox(width: 10),
        _StatChip(
            icon: Icons.whatshot,
            label: 'Streak',
            value: '${data.streak}d',
            color: Colors.orange),
        const SizedBox(width: 10),
        _StatChip(
            icon: Icons.verified,
            label: 'Accuracy',
            value: '${data.accuracyPercentage.toInt()}%',
            color: Colors.green),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatChip(
      {required this.icon,
      required this.label,
      required this.value,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.09),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color)),
            Text(label,
                style: TextStyle(
                    fontSize: 11, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }
}

// ── Subscription Card ──────────────────────────────────────────
class _SubscriptionCard extends StatelessWidget {
  final VoidCallback onManagePressed;
  const _SubscriptionCard({required this.onManagePressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onManagePressed,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.orange.shade400, Colors.deepOrange.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.workspace_premium, color: Colors.white, size: 30),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Premium Plan',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  SizedBox(height: 3),
                  Text('Tap to manage subscription',
                      style:
                          TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}
