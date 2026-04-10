// // ============================================================
// // File     : lib/screens/about_us_screen.dart
// // ============================================================
//
// import 'package:flutter/material.dart';
// import 'package:navaveda/generated/app_localizations.dart';
//
// class AboutUsScreen extends StatelessWidget {
//   const AboutUsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final loc = AppLocalizations.of(context);
//
//     return Scaffold(
//       backgroundColor: isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF5F7FA),
//       body: CustomScrollView(
//         slivers: [
//           // ── Header ─────────────────────────────────────────
//           SliverAppBar(
//             expandedHeight: 200,
//             pinned: true,
//             backgroundColor: Colors.transparent,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
//               onPressed: () => Navigator.pop(context),
//             ),
//             flexibleSpace: FlexibleSpaceBar(
//               background: Container(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: SafeArea(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(height: 30),
//                       // App Logo
//                       Container(
//                         width: 64,
//                         height: 64,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(18),
//                           gradient: const LinearGradient(
//                             colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
//                           ),
//                           boxShadow: [
//                             BoxShadow(color: const Color(0xFF4776E6).withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6)),
//                           ],
//                         ),
//                         child: const Icon(Icons.remove_red_eye_rounded, color: Colors.white, size: 34),
//                       ),
//                       const SizedBox(height: 12),
//                       const Text('Navaveda', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 1)),
//                       const SizedBox(height: 4),
//                       Text('AI-Powered Interview Preparation', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//
//           // ── Content ────────────────────────────────────────
//           SliverPadding(
//             padding: const EdgeInsets.all(16),
//             sliver: SliverList(
//               delegate: SliverChildListDelegate([
//
//                 // ── Mission ──────────────────────────────────
//                 _SectionCard(
//                   isDark: isDark,
//                   child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                     Row(children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(color: const Color(0xFF4776E6).withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
//                         child: const Icon(Icons.rocket_launch_rounded, color: Color(0xFF4776E6), size: 20),
//                       ),
//                       const SizedBox(width: 12),
//                       const Text('Our Mission', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
//                     ]),
//                     const SizedBox(height: 12),
//                     Text(
//                       'Navaveda is built to bridge the gap between learning and real-world interview performance. We combine AI-powered tools, structured study content, and emotion detection to help developers land their dream jobs with confidence.',
//                       style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.6),
//                     ),
//                   ]),
//                 ),
//                 const SizedBox(height: 16),
//
//                 // ── Creators ─────────────────────────────────
//                 const _SectionTitle('The Creators'),
//                 const SizedBox(height: 12),
//                 _DeveloperCard(
//                   isDark: isDark,
//                   initials: 'PB',
//                   gradientColors: [const Color(0xFFFF00D5), const Color(0xFF8E54E9)],
//                   name: 'Pooja Borgavi',
//                   role: loc.softwareDeveloper,
//                   tagline: 'Think. Code. Transform. ',
//                   skills: ['Java Spring Boot', 'REST APIs'],
//                   responsibility: 'Java Backend & API Integration',
//                   icon: Icons.code,
//                 ),
//                 const SizedBox(height: 12),
//
//                 _DeveloperCard(
//                   isDark: isDark,
//                   initials: 'RK',
//                   gradientColors: [const Color(0xFF11998E), const Color(0xFF38EF7D)],
//                   name: 'Rutvik Kamble',
//                   role: loc.softwareDeveloper,
//                   tagline: 'Behind every click, there’s logic',
//                   skills: ['Java Spring Boot','Python/Flask', 'REST APIs', 'Database Design'],
//                   responsibility: 'Java Backend & DB Design',
//                   icon: Icons.psychology_rounded,
//                 ),
//                 const SizedBox(height: 12),
//
//                 _DeveloperCard(
//                   isDark: isDark,
//                   initials: 'RA',
//                   gradientColors: [const Color(0xFF4776E6), const Color(0xFF8E54E9)],
//                   name: 'Raviraj Aade',
//                   role: " Software Developer",
//                   tagline: 'Code. Design. Repeat',
//                   skills: ['Flutter', 'UI/UX Design', 'Python/Flask','REST APIs',  'AI/ML','Firebase'],
//                   responsibility: loc.appConceptDesign,
//                   icon: Icons.phone_android_rounded,
//                 ),
//                 const SizedBox(height: 24),
//
//                 // ── Tech Stack ────────────────────────────────
//                 const _SectionTitle('Tech Stack'),
//                 const SizedBox(height: 12),
//                 _TechStackCard(isDark: isDark),
//                 const SizedBox(height: 24),
//
//                 // ── Version Info ──────────────────────────────
//                 Center(
//                   child: Column(children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         border: Border.all(color: Colors.grey.shade200),
//                       ),
//                       child: Text('Version 1.0.0', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
//                     ),
//                     const SizedBox(height: 8),
//                     Text('Made with ❤️ in India', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
//                     const SizedBox(height: 30),
//                   ]),
//                 ),
//               ]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Developer Card ─────────────────────────────────────────────
// class _DeveloperCard extends StatelessWidget {
//   final bool isDark;
//   final String initials, name, role, tagline, responsibility;
//   final List<String> skills;
//   final List<Color> gradientColors;
//   final IconData icon;
//
//   const _DeveloperCard({
//     required this.isDark,
//     required this.initials,
//     required this.gradientColors,
//     required this.name,
//     required this.role,
//     required this.tagline,
//     required this.skills,
//     required this.responsibility,
//     required this.icon,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.08), blurRadius: 16, offset: const Offset(0, 6))],
//       ),
//       child: Column(
//         children: [
//           // Top gradient bar
//           Container(
//             height: 6,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(colors: gradientColors),
//               borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     // Avatar with initials
//                     Container(
//                       width: 60,
//                       height: 60,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: LinearGradient(colors: gradientColors),
//                         boxShadow: [BoxShadow(color: gradientColors[0].withOpacity(0.35), blurRadius: 10, offset: const Offset(0, 4))],
//                       ),
//                       child: Center(
//                         child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
//                       ),
//                     ),
//                     const SizedBox(width: 14),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(name, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
//                           const SizedBox(height: 2),
//                           Text(role, style: TextStyle(fontSize: 13, color: gradientColors[0], fontWeight: FontWeight.w500)),
//                           const SizedBox(height: 2),
//                           Text(tagline, style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontStyle: FontStyle.italic)),
//                         ],
//                       ),
//                     ),
//                     Icon(icon, color: gradientColors[0].withOpacity(0.3), size: 32),
//                   ],
//                 ),
//
//                 const SizedBox(height: 16),
//                 Divider(color: Colors.grey.shade200),
//                 const SizedBox(height: 12),
//
//                 // Responsibility
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: gradientColors[0].withOpacity(0.08),
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: gradientColors[0].withOpacity(0.2)),
//                   ),
//                   child: Row(mainAxisSize: MainAxisSize.min, children: [
//                     Icon(Icons.star_rounded, color: gradientColors[0], size: 14),
//                     const SizedBox(width: 6),
//                     Text(responsibility, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: gradientColors[0])),
//                   ]),
//                 ),
//
//                 const SizedBox(height: 12),
//
//                 // Skills chips
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 6,
//                   children: skills.map((s) => Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                     decoration: BoxDecoration(
//                       color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(s, style: TextStyle(fontSize: 11, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700, fontWeight: FontWeight.w500)),
//                   )).toList(),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ── Tech Stack Card ────────────────────────────────────────────
// class _TechStackCard extends StatelessWidget {
//   final bool isDark;
//   const _TechStackCard({required this.isDark});
//
//   @override
//   Widget build(BuildContext context) {
//     final techs = [
//       _Tech('Flutter', Icons.phone_android_rounded, const Color(0xFF027DFD)),
//       _Tech('Firebase', Icons.local_fire_department, const Color(0xFFFF6D00)),
//       _Tech('Java Spring', Icons.coffee_rounded, const Color(0xFF5F9EA0)),
//       _Tech('Python Flask', Icons.code_rounded, const Color(0xFF3776AB)),
//       _Tech('Supabase', Icons.storage_rounded, const Color(0xFF3ECF8E)),
//       _Tech('Cloudinary', Icons.cloud_rounded, const Color(0xFF3448C5)),
//     ];
//
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)],
//       ),
//       child: GridView.count(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         crossAxisCount: 3,
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//         childAspectRatio: 1.4,
//         children: techs.map((t) => Container(
//           decoration: BoxDecoration(
//             color: t.color.withOpacity(0.08),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: t.color.withOpacity(0.15)),
//           ),
//           child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//             Icon(t.icon, color: t.color, size: 22),
//             const SizedBox(height: 4),
//             Text(t.name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: t.color)),
//           ]),
//         )).toList(),
//       ),
//     );
//   }
// }
//
// class _Tech {
//   final String name;
//   final IconData icon;
//   final Color color;
//   const _Tech(this.name, this.icon, this.color);
// }
//
// class _SectionCard extends StatelessWidget {
//   final bool isDark;
//   final Widget child;
//   const _SectionCard({required this.isDark, required this.child});
//
//   @override
//   Widget build(BuildContext context) => Container(
//     padding: const EdgeInsets.all(18),
//     decoration: BoxDecoration(
//       color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
//       borderRadius: BorderRadius.circular(16),
//       boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3))],
//     ),
//     child: child,
//   );
// }
//
// class _SectionTitle extends StatelessWidget {
//   final String text;
//   const _SectionTitle(this.text);
//   @override
//   Widget build(BuildContext context) => Text(text, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold));
// }



// ============================================================
// File     : lib/screens/about_us_screen.dart
// ============================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:navaveda/generated/app_localizations.dart';

// ── NavaVeda Logo Painter ──────────────────────────────────────
// Draws the full NavaVeda icon: N letterform + Tripundra tilak +
// crescent moon + third eye — no external asset needed.
class _NavaVedaLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── N letterform (blue → purple gradient) ──
    final nGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [const Color(0xFF5B8AF5), const Color(0xFFA870F8)],
    ).createShader(Rect.fromLTWH(0, 0, w, h));

    final nPaint = Paint()
      ..shader = nGradient
      ..strokeWidth = w * 0.13
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    // N: left vertical, diagonal, right vertical
    final path = Path()
      ..moveTo(w * 0.22, h * 0.82)
      ..lineTo(w * 0.22, h * 0.26)
      ..lineTo(w * 0.78, h * 0.82)
      ..lineTo(w * 0.78, h * 0.26);
    canvas.drawPath(path, nPaint);

    // ── Tripundra tilak (3 white lines above N) ──
    final tilakPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = w * 0.055
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Top stripe (faintest)
    canvas.drawLine(
      Offset(w * 0.34, h * 0.165),
      Offset(w * 0.66, h * 0.165),
      tilakPaint..color = Colors.white.withOpacity(0.38),
    );
    // Middle stripe
    canvas.drawLine(
      Offset(w * 0.32, h * 0.205),
      Offset(w * 0.68, h * 0.205),
      tilakPaint..color = Colors.white.withOpacity(0.62),
    );
    // Bottom stripe (most defined)
    canvas.drawLine(
      Offset(w * 0.30, h * 0.245),
      Offset(w * 0.70, h * 0.245),
      tilakPaint..color = Colors.white.withOpacity(0.90),
    );

    // Bindi (red dot below tilak)
    canvas.drawCircle(
      Offset(w * 0.50, h * 0.285),
      w * 0.055,
      Paint()..color = const Color(0xFFFF4400),
    );
    canvas.drawCircle(
      Offset(w * 0.50, h * 0.285),
      w * 0.075,
      Paint()
        ..color = const Color(0xFFF5C518).withOpacity(0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.025,
    );

    // ── Crescent moon (top-right) ──
    // Draw full circle then clip an offset circle to make crescent
    final moonPaint = Paint()..color = const Color(0xFFF5C518).withOpacity(0.92);
    final moonCenter = Offset(w * 0.76, h * 0.16);
    final moonR = w * 0.13;

    canvas.saveLayer(null, Paint());
    canvas.drawCircle(moonCenter, moonR, moonPaint);
    // Erase offset circle to carve crescent
    canvas.drawCircle(
      Offset(moonCenter.dx + moonR * 0.42, moonCenter.dy - moonR * 0.05),
      moonR * 0.82,
      Paint()..blendMode = BlendMode.clear,
    );
    canvas.restore();

    // ── Stars near crescent ──
    final starPaint = Paint()..color = const Color(0xFFF5C518).withOpacity(0.55);
    canvas.drawCircle(Offset(w * 0.88, h * 0.10), w * 0.022, starPaint);
    canvas.drawCircle(Offset(w * 0.92, h * 0.20), w * 0.015,
        Paint()..color = const Color(0xFFF5C518).withOpacity(0.38));
    canvas.drawCircle(Offset(w * 0.83, h * 0.06), w * 0.017,
        Paint()..color = const Color(0xFFF5C518).withOpacity(0.32));

    // ── Third eye on diagonal midpoint ──
    // Midpoint of N diagonal ≈ (0.50, 0.54), angle ≈ 48.5°
    canvas.save();
    canvas.translate(w * 0.50, h * 0.54);
    canvas.rotate(48.5 * math.pi / 180);

    final eyeW = w * 0.18;
    final eyePath = Path()
      ..moveTo(-eyeW, 0)
      ..quadraticBezierTo(0, -eyeW * 0.58, eyeW, 0)
      ..quadraticBezierTo(0, eyeW * 0.58, -eyeW, 0)
      ..close();
    canvas.drawPath(
      eyePath,
      Paint()
        ..color = const Color(0xFFF5C518).withOpacity(0.90)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.028,
    );
    // Iris
    canvas.drawCircle(Offset.zero, w * 0.065,
        Paint()..color = const Color(0xFFFF7722).withOpacity(0.95));
    // Pupil
    canvas.drawCircle(Offset.zero, w * 0.032,
        Paint()..color = const Color(0xFF0C1023));

    canvas.restore();
  }

  @override
  bool shouldRepaint(_NavaVedaLogoPainter oldDelegate) => false;
}

// ── NavaVeda Logo Widget ───────────────────────────────────────
class NavaVedaLogo extends StatelessWidget {
  final double size;
  const NavaVedaLogo({super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.27),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0C1023), Color(0xFF1A0A2E)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4776E6).withOpacity(0.45),
            blurRadius: size * 0.28,
            offset: Offset(0, size * 0.10),
          ),
          BoxShadow(
            color: const Color(0xFF8E54E9).withOpacity(0.20),
            blurRadius: size * 0.45,
            offset: Offset(0, size * 0.18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.27),
        child: CustomPaint(
          painter: _NavaVedaLogoPainter(),
          size: Size(size, size),
        ),
      ),
    );
  }
}

// ============================================================
// About Us Screen
// ============================================================
class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          // ── Header ───────────────────────────────────────
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
                    colors: [
                      Color(0xFF0F2027),
                      Color(0xFF203A43),
                      Color(0xFF2C5364),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),

                      // ── App Logo (NavaVeda CustomPainter) ──
                      const NavaVedaLogo(size: 64),

                      const SizedBox(height: 12),
                      const Text(
                        'Navaveda',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'AI-Powered Interview Preparation',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // ── Mission ────────────────────────────────
                _SectionCard(
                  isDark: isDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4776E6).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.rocket_launch_rounded,
                            color: Color(0xFF4776E6),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Our Mission',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ]),
                      const SizedBox(height: 12),
                      Text(
                        'Navaveda is built to bridge the gap between learning and real-world interview performance. We combine AI-powered tools, structured study content, and emotion detection to help developers land their dream jobs with confidence.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Tech Stack ─────────────────────────────
                const _SectionTitle('Tech Stack'),
                const SizedBox(height: 12),
                _TechStackCard(isDark: isDark),
                const SizedBox(height: 24),

                // ── Creators ───────────────────────────────
                const _SectionTitle('The Creators'),
                const SizedBox(height: 12),
                // _DeveloperCard(
                //   isDark: isDark,
                //   initials: 'PB',
                //   gradientColors: [
                //     const Color(0xFFFF00D5),
                //     const Color(0xFF8E54E9),
                //   ],
                //   name: 'Pooja Borgavi',
                //   role: loc.softwareDeveloper,
                //   tagline: 'Think. Code. Transform.',
                //   skills: ['Java Spring Boot', 'REST APIs'],
                //   responsibility: 'Java Backend & API Integration',
                //   icon: Icons.code,
                // ),
                const SizedBox(height: 12),

                _DeveloperCard(
                  isDark: isDark,
                  initials: 'RK',
                  gradientColors: [
                    const Color(0xFF22E3DC),
                    const Color(0xFF3A66B7),
                  ],
                  name: 'Rutvik Kamble',
                  role: loc.softwareDeveloper,
                  tagline: "Behind every click, there's logic",
                  skills: [
                    'Java Spring Boot',
                    'Python/Flask',
                    'REST APIs',
                    'Database Design',
                  ],
                  responsibility: 'Java Backend & DB Design',
                  icon: Icons.psychology_rounded,
                ),
                const SizedBox(height: 12),

                _DeveloperCard(
                  isDark: isDark,
                  initials: 'RA',
                  gradientColors: [
                    const Color(0xFF2E77E8),
                    const Color(0xFFBA22F3),
                  ],
                  name: 'Raviraj Aade',
                  role: 'Backend Developer',
                  tagline: 'Code. Design. Repeat',
                  skills: [
                    'Flutter',
                    'UI/UX Design',
                    'Python/Flask',
                    'REST APIs',
                    'AI/ML',
                    'Firebase',
                  ],
                  responsibility: loc.appConceptDesign,
                  icon: Icons.phone_android_rounded,
                ),
                const SizedBox(height: 28),

                // ── Contributors ───────────────────────────
                // Horizontal scroll section — sits between
                // Creators and Tech Stack.
                const _SectionTitle('Contributors'),
                const SizedBox(height: 4),
                Text(
                  'People who helped shape NavaVeda',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 14),
                _ContributorsRow(isDark: isDark),
                const SizedBox(height: 28),



                // ── Version Info ───────────────────────────
                Center(
                  child: Column(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E1E1E)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        'Version 1.0.0',
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Made with ❤️ in India',
                      style: TextStyle(
                          color: Colors.grey.shade400, fontSize: 13),
                    ),
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

// ── Contributors Row (Horizontal Scroll) ──────────────────────
class _ContributorsRow extends StatelessWidget {
  final bool isDark;

  const _ContributorsRow({required this.isDark});

  // ── Edit this list to add / remove contributors ──
  static const List<_Contributor> _data = [
    // _Contributor(
    //   initials: 'AA',
    //   name: 'Contributor Name',
    //   role: 'UI Designer',
    //   profileUrl: 'https://linkedin.com/in/yourprofile',
    //   gradientColors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
    //   platform: _ProfilePlatform.linkedin,
    // ),
    // _Contributor(
    //   initials: 'BB',
    //   name: 'Contributor Name',
    //   role: 'Backend Tester',
    //   profileUrl: 'https://github.com/yourprofile',
    //   gradientColors: [Color(0xFF11998E), Color(0xFF38EF7D)],
    //   platform: _ProfilePlatform.github,
    // ),
    _Contributor(
      initials: 'PB',
      name: 'Pooja Borgavi',
      role: 'Java Developer',
      // profileUrl: 'https://www.linkedin.com/in/pooja-borgavi/',
      gradientColors: [Color(0xFFFF00D5), Color(0xFFF5C518)],
      platform: _ProfilePlatform.linkedin,
    ),
    _Contributor(
      initials: 'SS',
      name: 'Shubham Suryawanshi ',
      role: 'Software Developer',
      // profileUrl: 'https://www.linkedin.com/in/shubham8551/',
      gradientColors: [Color(0xFF312E2E), Color(0xFFB216FF)],
      platform: _ProfilePlatform.linkedin,
    ),
    // ── Add more contributors here ──
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 178,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        // slight left indent to line up with section title
        padding: EdgeInsets.zero,
        itemCount: _data.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) =>
            _ContributorCard(c: _data[i], isDark: isDark),
      ),
    );
  }
}

enum _ProfilePlatform { linkedin, github }

class _Contributor {
  final String initials;
  final String name;
  final String role;
  // final String profileUrl;
  final List<Color> gradientColors;
  final _ProfilePlatform platform;

  const _Contributor({
    required this.initials,
    required this.name,
    required this.role,
    // required this.profileUrl,
    required this.gradientColors,
    required this.platform,
  });
}

class _ContributorCard extends StatelessWidget {
  final _Contributor c;
  final bool isDark;

  const _ContributorCard({required this.c, required this.isDark});

  // Future<void> _openUrl() async {
  //   final uri = Uri.parse(c.profileUrl);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final isLinkedIn = c.platform == _ProfilePlatform.linkedin;

    return Container(
      width: 148,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.28 : 0.07),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Gradient top bar
          Container(
            height: 5,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: c.gradientColors),
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(18)),
            ),
          ),
          Expanded(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: c.gradientColors),
                      boxShadow: [
                        BoxShadow(
                          color: c.gradientColors[0].withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        c.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Name
                  Text(
                    c.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Role
                  Text(
                    c.role,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const Spacer(),

                  // Profile link button
                  // GestureDetector(
                  //   // onTap: _openUrl,
                  //   // child: Container(
                  //   //   padding: const EdgeInsets.symmetric(
                  //   //       horizontal: 10, vertical: 5),
                  //   //   decoration: BoxDecoration(
                  //   //     gradient: LinearGradient(
                  //   //       colors: isLinkedIn
                  //   //           ? [
                  //   //         const Color(0xFF0077B5),
                  //   //         const Color(0xFF00A0DC),
                  //   //       ]
                  //   //           : [
                  //   //         const Color(0xFF24292e),
                  //   //         const Color(0xFF586069),
                  //   //       ],
                  //   //     ),
                  //   //     borderRadius: BorderRadius.circular(20),
                  //   //   ),
                  //   //   child: Row(
                  //   //     mainAxisSize: MainAxisSize.min,
                  //   //     children: [
                  //   //       Icon(
                  //   //         isLinkedIn
                  //   //             ? Icons.link_rounded
                  //   //             : Icons.code_rounded,
                  //   //         color: Colors.white,
                  //   //         size: 12,
                  //   //       ),
                  //   //       const SizedBox(width: 4),
                  //   //       Text(
                  //   //         isLinkedIn ? 'LinkedIn' : 'GitHub',
                  //   //         style: const TextStyle(
                  //   //           color: Colors.white,
                  //   //           fontSize: 10,
                  //   //           fontWeight: FontWeight.w600,
                  //   //         ),
                  //   //       ),
                  //   //     ],
                  //   //   ),
                  //   // ),
                  // ),
                ],
              ),
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
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(20)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: gradientColors),
                        boxShadow: [
                          BoxShadow(
                            color:
                            gradientColors[0].withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            role,
                            style: TextStyle(
                              fontSize: 13,
                              color: gradientColors[0],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tagline,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      icon,
                      color: gradientColors[0].withOpacity(0.3),
                      size: 32,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: Colors.grey.shade200),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: gradientColors[0].withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: gradientColors[0].withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rounded,
                          color: gradientColors[0], size: 14),
                      const SizedBox(width: 6),
                      Text(
                        responsibility,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: gradientColors[0],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: skills
                      .map(
                        (s) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        s,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? Colors.grey.shade300
                              : Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                      .toList(),
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
      _Tech('Flutter', Icons.phone_android_rounded,
          const Color(0xFF027DFD)),
      _Tech('Firebase', Icons.local_fire_department,
          const Color(0xFFFF6D00)),
      _Tech('Java Spring', Icons.coffee_rounded,
          const Color(0xFF5F9EA0)),
      _Tech('Python Flask', Icons.code_rounded,
          const Color(0xFF3776AB)),
      _Tech('Supabase', Icons.storage_rounded,
          const Color(0xFF3ECF8E)),
      _Tech('Cloudinary', Icons.cloud_rounded,
          const Color(0xFF3448C5)),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
          ),
        ],
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.4,
        children: techs
            .map(
              (t) => Container(
            decoration: BoxDecoration(
              color: t.color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border:
              Border.all(color: t.color.withOpacity(0.15)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(t.icon, color: t.color, size: 22),
                const SizedBox(height: 4),
                Text(
                  t.name,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: t.color,
                  ),
                ),
              ],
            ),
          ),
        )
            .toList(),
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
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: child,
  );
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(fontWeight: FontWeight.bold),
  );
}
