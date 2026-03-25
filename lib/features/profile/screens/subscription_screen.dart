// ============================================================
// File     : lib/features/profile/screens/subscription_screen.dart
// ============================================================

import 'package:flutter/material.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with SingleTickerProviderStateMixin {
  String _selectedPlan = 'Pro';
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  static const _plans = [
    _Plan(id: 'Basic', price: '₹99', duration: '/ month', tagline: 'Perfect to get started', color: Color(0xFF11998E), features: ['All Core Features', 'Unlimited Interviews', 'Basic Analytics', 'Email Support'], isPopular: false),
    _Plan(id: 'Pro', price: '₹499', duration: '/ 6 months', tagline: 'Most popular choice', color: Color(0xFF4776E6), features: ['Everything in Basic', 'Priority Support', 'Advanced Analytics', 'Practice Tests', 'AI Interview Coach'], isPopular: true),
    _Plan(id: 'Enterprise', price: '₹1499', duration: '/ year', tagline: 'For teams & organizations', color: Color(0xFF8E54E9), features: ['Everything in Pro', 'Team Access (up to 10)', 'Custom Analytics', '24/7 Priority Support', 'Account Manager'], isPopular: false),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        const Icon(Icons.workspace_premium, color: Colors.white, size: 44),
                        const SizedBox(height: 10),
                        const Text('Upgrade to Premium',
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text('Unlock your full potential',
                            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < _plans.length) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _PlanCard(
                        plan: _plans[index],
                        isSelected: _selectedPlan == _plans[index].id,
                        onSelect: (id) => setState(() => _selectedPlan = id),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _onSubscribe(context),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            backgroundColor: const Color(0xFF4776E6),
                          ),
                          child: Text('Subscribe to $_selectedPlan',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Not now', style: TextStyle(color: Colors.grey.shade500)),
                      ),
                      const SizedBox(height: 30),
                    ],
                  );
                },
                childCount: _plans.length + 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSubscribe(BuildContext context) {
    // TODO: Integrate Razorpay / Google Pay / Stripe
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Color(0xFF4776E6)),
            SizedBox(width: 10),
            Text('Coming Soon!'),
          ],
        ),
        content: Text('Payment for $_selectedPlan plan coming soon!'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final _Plan plan;
  final bool isSelected;
  final ValueChanged<String> onSelect;
  const _PlanCard({required this.plan, required this.isSelected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => onSelect(plan.id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? plan.color : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
          border: Border.all(color: isSelected ? plan.color : Colors.transparent, width: 2),
          boxShadow: isSelected
              ? [BoxShadow(color: plan.color.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))]
              : [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(plan.id,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(plan.price,
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : plan.color)),
                          const SizedBox(width: 4),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(plan.duration,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected ? Colors.white70 : Colors.grey.shade500)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(plan.tagline,
                      style: TextStyle(
                          fontSize: 13, color: isSelected ? Colors.white70 : Colors.grey.shade500)),
                  const SizedBox(height: 16),
                  ...plan.features.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_rounded,
                                color: isSelected ? Colors.white : plan.color, size: 18),
                            const SizedBox(width: 10),
                            Text(f,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: isSelected
                                        ? Colors.white
                                        : Theme.of(context).textTheme.bodyLarge?.color)),
                          ],
                        ),
                      )),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => onSelect(plan.id),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        side: BorderSide(color: isSelected ? Colors.white : plan.color, width: 1.5),
                        foregroundColor: isSelected ? Colors.white : plan.color,
                      ),
                      child: Text(isSelected ? '✓ Selected' : 'Select Plan',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
            if (plan.isPopular)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF11998E), Color(0xFF38EF7D)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('POPULAR',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Plan {
  final String id, price, duration, tagline;
  final Color color;
  final List<String> features;
  final bool isPopular;
  const _Plan({required this.id, required this.price, required this.duration, required this.tagline, required this.color, required this.features, required this.isPopular});
}
