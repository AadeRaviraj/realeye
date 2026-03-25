// ============================================================
// File     : lib/screens/about_us_screen.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:realeyes/generated/app_localizations.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // ── Header ─────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
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
                    colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      // App Logo
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
                          ),
                          boxShadow: [
                            BoxShadow(color: const Color(0xFF4776E6).withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6)),
                          ],
                        ),
                        child: const Icon(Icons.remove_red_eye_rounded, color: Colors.white, size: 34),
                      ),
                      const SizedBox(height: 12),
                      const Text('Realeye', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 1)),
                      const SizedBox(height: 4),
                      Text('AI-Powered Interview Preparation', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Content ────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // ── Mission ──────────────────────────────────
                _SectionCard(
                  isDark: isDark,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFF4776E6).withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.rocket_launch_rounded, color: Color(0xFF4776E6), size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Text('Our Mission', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    ]),
                    const SizedBox(height: 12),
                    Text(
                      'Realeye is built to bridge the gap between learning and real-world interview performance. We combine AI-powered tools, structured study content, and emotion detection to help developers land their dream jobs with confidence.',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.6),
                    ),
                  ]),
                ),
                const SizedBox(height: 16),

                // ── Creators ─────────────────────────────────
                const _SectionTitle('The Creators'),
                const SizedBox(height: 12),

                _DeveloperCard(
                  isDark: isDark,
                  initials: 'RA',
                  gradientColors: [const Color(0xFF4776E6), const Color(0xFF8E54E9)],
                  name: 'Raviraj Aade',
                  role: loc.softwareDeveloper,
                  tagline: 'Code. Design. Repeat',
                  skills: ['Flutter', 'UI/UX Design', 'Python/Flask','REST APIs',  'AI/ML','Firebase'],
                  responsibility: loc.appConceptDesign,
                  icon: Icons.phone_android_rounded,
                ),
                const SizedBox(height: 12),

                _DeveloperCard(
                  isDark: isDark,
                  initials: 'RK',
                  gradientColors: [const Color(0xFF11998E), const Color(0xFF38EF7D)],
                  name: 'Rutvik Kamble',
                  role: loc.softwareDeveloper,
                  tagline: 'Behind every click, there’s logic',
                  skills: ['Java Spring Boot','Python/Flask', 'REST APIs', 'Database Design'],
                  responsibility: 'Java Backend & API Integration',
                  icon: Icons.psychology_rounded,
                ),
                const SizedBox(height: 24),

                // ── Tech Stack ────────────────────────────────
                const _SectionTitle('Tech Stack'),
                const SizedBox(height: 12),
                _TechStackCard(isDark: isDark),
                const SizedBox(height: 24),

                // ── Version Info ──────────────────────────────
                Center(
                  child: Column(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text('Version 1.0.0', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                    ),
                    const SizedBox(height: 8),
                    Text('Made with ❤️ in India', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                    const SizedBox(height: 30),
                  ]),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Developer Card ─────────────────────────────────────────────
class _DeveloperCard extends StatelessWidget {
  final bool isDark;
  final String initials, name, role, tagline, responsibility;
  final List<String> skills;
  final List<Color> gradientColors;
  final IconData icon;

  const _DeveloperCard({
    required this.isDark,
    required this.initials,
    required this.gradientColors,
    required this.name,
    required this.role,
    required this.tagline,
    required this.skills,
    required this.responsibility,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.08), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Column(
        children: [
          // Top gradient bar
          Container(
            height: 6,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Avatar with initials
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: gradientColors),
                        boxShadow: [BoxShadow(color: gradientColors[0].withOpacity(0.35), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Center(
                        child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text(role, style: TextStyle(fontSize: 13, color: gradientColors[0], fontWeight: FontWeight.w500)),
                          const SizedBox(height: 2),
                          Text(tagline, style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                    Icon(icon, color: gradientColors[0].withOpacity(0.3), size: 32),
                  ],
                ),

                const SizedBox(height: 16),
                Divider(color: Colors.grey.shade200),
                const SizedBox(height: 12),

                // Responsibility
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: gradientColors[0].withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: gradientColors[0].withOpacity(0.2)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.star_rounded, color: gradientColors[0], size: 14),
                    const SizedBox(width: 6),
                    Text(responsibility, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: gradientColors[0])),
                  ]),
                ),

                const SizedBox(height: 12),

                // Skills chips
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: skills.map((s) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(s, style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700, fontWeight: FontWeight.w500)),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tech Stack Card ────────────────────────────────────────────
class _TechStackCard extends StatelessWidget {
  final bool isDark;
  const _TechStackCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final techs = [
      _Tech('Flutter', Icons.phone_android_rounded, const Color(0xFF027DFD)),
      _Tech('Firebase', Icons.local_fire_department, const Color(0xFFFF6D00)),
      _Tech('Java Spring', Icons.coffee_rounded, const Color(0xFF5F9EA0)),
      _Tech('Python Flask', Icons.code_rounded, const Color(0xFF3776AB)),
      _Tech('Supabase', Icons.storage_rounded, const Color(0xFF3ECF8E)),
      _Tech('Cloudinary', Icons.cloud_rounded, const Color(0xFF3448C5)),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)],
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.4,
        children: techs.map((t) => Container(
          decoration: BoxDecoration(
            color: t.color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: t.color.withOpacity(0.15)),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(t.icon, color: t.color, size: 22),
            const SizedBox(height: 4),
            Text(t.name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: t.color)),
          ]),
        )).toList(),
      ),
    );
  }
}

class _Tech {
  final String name;
  final IconData icon;
  final Color color;
  const _Tech(this.name, this.icon, this.color);
}

class _SectionCard extends StatelessWidget {
  final bool isDark;
  final Widget child;
  const _SectionCard({required this.isDark, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3))],
    ),
    child: child,
  );
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);
  @override
  Widget build(BuildContext context) => Text(text, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold));
}
