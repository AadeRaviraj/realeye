// ============================================================
// File     : lib/features/profile/widgets/stats_tab.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realeyes/features/profile/providers/profile_provider.dart';
import 'package:realeyes/models/DailyStat.dart';
import 'package:realeyes/models/dashboard_data.dart';

class StatsTab extends StatelessWidget {
  const StatsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    if (provider.isLoadingDashboard && provider.dashboardData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.dashboardError != null && provider.dashboardData == null) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 8),
          const Text('Could not load stats'),
          TextButton(
              onPressed: provider.loadDashboard, child: const Text('Retry')),
        ]),
      );
    }

    final data = provider.dashboardData!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StatsGrid(data: data),
          const SizedBox(height: 24),
          _ActivityChart(provider: provider),
          const SizedBox(height: 24),
          const _AchievementSection(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ── Stats Grid ─────────────────────────────────────────────────
class _StatsGrid extends StatelessWidget {
  final DashboardData data;
  const _StatsGrid({required this.data});

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatItem(icon: Icons.today, label: 'Today', value: '${data.todayMinutes} min', color: const Color(0xFF4776E6)),
      _StatItem(icon: Icons.date_range, label: 'This Week', value: '${data.weeklyMinutes} min', color: const Color(0xFF11998E)),
      _StatItem(icon: Icons.calendar_month, label: 'Monthly', value: '${data.monthlyMinutes} min', color: const Color(0xFF8E54E9)),
      _StatItem(icon: Icons.check_circle_rounded, label: 'Completion', value: '${data.completionPercentage.toStringAsFixed(1)}%', color: const Color(0xFFF7971E)),
      _StatItem(icon: Icons.verified_rounded, label: 'Accuracy', value: '${data.accuracyPercentage.toStringAsFixed(1)}%', color: const Color(0xFFED213A)),
      _StatItem(icon: Icons.local_fire_department, label: 'Streak', value: '${data.streak} days', color: const Color(0xFFFF8C00)),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) => _StatCard(item: items[i]),
    );
  }
}

class _StatItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatItem({required this.icon, required this.label, required this.value, required this.color});
}

class _StatCard extends StatelessWidget {
  final _StatItem item;
  const _StatCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: item.color.withOpacity(0.08),
        border: Border.all(color: item.color.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: item.color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: item.color)),
                Text(item.label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Activity Chart ─────────────────────────────────────────────
class _ActivityChart extends StatefulWidget {
  final ProfileProvider provider;
  const _ActivityChart({required this.provider});

  @override
  State<_ActivityChart> createState() => _ActivityChartState();
}

class _ActivityChartState extends State<_ActivityChart> {
  String _range = 'week';
  late Future<List<DailyStat>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.provider.fetchDailyStats(_range);
  }

  String _formatDate(DateTime date) {
    if (_range == 'week') {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[date.weekday - 1];
    } else if (_range == 'month') {
      return '${date.day}';
    } else {
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return months[date.month - 1];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Activity',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _range,
                    isDense: true,
                    items: const [
                      DropdownMenuItem(value: 'week', child: Text('7 Days', style: TextStyle(fontSize: 13))),
                      DropdownMenuItem(value: 'month', child: Text('30 Days', style: TextStyle(fontSize: 13))),
                      DropdownMenuItem(value: 'year', child: Text('12 Months', style: TextStyle(fontSize: 13))),
                    ],
                    onChanged: (v) => setState(() {
                      _range = v!;
                      _future = widget.provider.fetchDailyStats(_range);
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<DailyStat>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()));
                }
                if (!snap.hasData || snap.data!.isEmpty) {
                  return Center(child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('No activity data', style: TextStyle(color: Colors.grey.shade500)),
                  ));
                }
                final stats = snap.data!;
                final maxMinutes = stats.map((e) => e.minutes).reduce((a, b) => a > b ? a : b);
                return SizedBox(
                  height: 140,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: stats.map((stat) {
                      final factor = maxMinutes == 0 ? 0.0 : stat.minutes / maxMinutes;
                      return _BarItem(label: _formatDate(stat.date), value: stat.minutes, heightFactor: factor.toDouble());
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  final String label;
  final int value;
  final double heightFactor;
  const _BarItem({required this.label, required this.value, required this.heightFactor});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final maxBarH = constraints.maxHeight * 0.65;
        final barH = (maxBarH * heightFactor).clamp(2.0, maxBarH);
        final primary = Theme.of(context).colorScheme.primary;
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('$value', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              width: 18,
              height: barH,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
                gradient: LinearGradient(
                  colors: [primary, primary.withOpacity(0.5)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
          ],
        );
      },
    );
  }
}

// ── Achievement Badges ─────────────────────────────────────────
class _AchievementSection extends StatelessWidget {
  const _AchievementSection();

  @override
  Widget build(BuildContext context) {
    final badges = [
      _Badge(icon: Icons.star_rounded, label: 'Beginner', achieved: true, color: Colors.amber),
      _Badge(icon: Icons.auto_awesome, label: 'Intermediate', achieved: true, color: Colors.blue),
      _Badge(icon: Icons.workspace_premium, label: 'Expert', achieved: false, color: Colors.purple),
      _Badge(icon: Icons.emoji_events, label: 'Master', achieved: false, color: Colors.orange),
    ];
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Achievements',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: badges.map((b) => _BadgeWidget(badge: b)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge {
  final IconData icon;
  final String label;
  final bool achieved;
  final Color color;
  const _Badge({required this.icon, required this.label, required this.achieved, required this.color});
}

class _BadgeWidget extends StatelessWidget {
  final _Badge badge;
  const _BadgeWidget({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: badge.achieved ? badge.color.withOpacity(0.15) : Colors.grey.shade200,
            border: Border.all(color: badge.achieved ? badge.color : Colors.grey.shade300, width: 2),
            boxShadow: badge.achieved
                ? [BoxShadow(color: badge.color.withOpacity(0.3), blurRadius: 8, spreadRadius: 1)]
                : null,
          ),
          child: Icon(badge.icon, color: badge.achieved ? badge.color : Colors.grey.shade400, size: 28),
        ),
        const SizedBox(height: 6),
        Text(badge.label,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: badge.achieved ? Colors.grey.shade800 : Colors.grey.shade400)),
      ],
    );
  }
}
