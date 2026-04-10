

// lib/screens/study_screen.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:navaveda/screens/module_screen.dart';
import 'package:navaveda/screens/subtopics_screen.dart';
import 'package:navaveda/screens/topics_screen.dart';
// import 'package:Navaveda/widgets/ai_chat_fab.dart';
import '../services/api_service.dart';
import '../models/course.dart';

// ── Data models — unchanged ────────────────────────────────────
class JobReadyCourse {
  final int id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final List<JobReadyModule> modules;
  JobReadyCourse({required this.id, required this.title, required this.description, required this.icon, required this.color, required this.modules});
}

class JobReadyModule {
  final String title;
  final String description;
  final IconData icon;
  final double progress;
  final List<String> topics;
  JobReadyModule({required this.title, required this.description, required this.icon, required this.progress, required this.topics});
}

class ProgrammingCourse {
  final String name;
  final IconData icon;
  final Color color;
  ProgrammingCourse({required this.name, required this.icon, required this.color});
}

// ── Main Screen ────────────────────────────────────────────────
class StudyScreen extends StatefulWidget {
  @override
  _StudyScreenState createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  // ── Data — unchanged ─────────────────────────────────────────
  final List<JobReadyCourse> jobReadyCourses = [
    JobReadyCourse(id: 10, title: "Computer Fundamental", description: "From basics to advanced programming", icon: Icons.code, color: const Color(0xFF8E54E9), modules: [
      // JobReadyModule(title: "Computer Fundamentals", description: "Basics of computing", icon: Icons.computer, progress: 0.2, topics: ["Intro to Computer", "Components", "MicroProcessor", "Storage"]),
      // JobReadyModule(title: "Programming Basics", description: "Start coding journey", icon: Icons.terminal, progress: 0.1, topics: ["Intro to Programming", "Variables", "Loops", "Functions"]),
    ]),
    JobReadyCourse(id: 2, title: "Python Developer", description: "Master data analysis & visualization", icon: Icons.analytics, color: const Color(0xFF4776E6), modules: [
      JobReadyModule(title: "Data Fundamentals", description: "Basics of data analysis", icon: Icons.data_usage, progress: 0.2, topics: ["Data Types", "Collection", "Cleaning", "Statistics"]),
      JobReadyModule(title: "Visualization", description: "Charts and dashboards", icon: Icons.bar_chart, progress: 0.0, topics: ["Charts", "Graphs", "Dashboards", "Tools"]),
    ]),
    JobReadyCourse(id: 3, title: "Data Scientist", description: "Machine learning & AI expert", icon: Icons.science, color: const Color(0xFF11998E), modules: [
      JobReadyModule(title: "Python for DS", description: "Python essentials", icon: Icons.code, progress: 0.4, topics: ["Python Basics", "Pandas", "NumPy", "Data Manipulation"]),
      JobReadyModule(title: "Machine Learning", description: "ML algorithms", icon: Icons.model_training, progress: 0.1, topics: ["Regression", "Classification", "Clustering", "Neural Networks"]),
    ]),
    JobReadyCourse(id: 4, title: "Prompt Engineer", description: "AI communication & prompt design", icon: Icons.smart_toy, color: const Color(0xFFF7971E), modules: [
      JobReadyModule(title: "AI Fundamentals", description: "How AI models work", icon: Icons.psychology, progress: 0.0, topics: ["AI Basics", "Model Types", "Capabilities", "Limitations"]),
    ]),
    JobReadyCourse(id: 5, title: "Cloud Engineer", description: "Cloud infrastructure & deployment", icon: Icons.cloud, color: const Color(0xFF38EF7D), modules: [
      JobReadyModule(title: "Cloud Basics", description: "Intro to cloud computing", icon: Icons.cloud_queue, progress: 0.6, topics: ["Providers", "Services", "Deployment", "Security"]),
    ]),
  ];

  final List<ProgrammingCourse> programmingCourses = [
    ProgrammingCourse(name: "C", icon: Icons.settings, color: const Color(0xFF4776E6)),
    ProgrammingCourse(name: "C++", icon: Icons.settings_applications, color: const Color(0xFF8E54E9)),
    ProgrammingCourse(name: "Java", icon: Icons.coffee, color: const Color(0xFFF7971E)),
    ProgrammingCourse(name: "Python", icon: Icons.auto_awesome, color: const Color(0xFF11998E)),
    ProgrammingCourse(name: "JavaScript", icon: Icons.web, color: const Color(0xFFFC5C7D)),
    ProgrammingCourse(name: "Dart", icon: Icons.phone_android, color: const Color(0xFF5F9DF2)),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
    );
    _slideAnimation = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: const Interval(0.2, 1.0, curve: Curves.easeOut)),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isWeb = kIsWeb;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF2F4F8),
      // floatingActionButton: const AIChatFab(),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // ── Top Greeting Banner ─────────────────────
                  SliverToBoxAdapter(child: _GreetingBanner(isDark: isDark)),

                  // ── Career Paths ────────────────────────────
                  SliverToBoxAdapter(
                    child: _SectionHeader(
                      title: 'Career Paths',
                      subtitle: 'Choose your learning track',
                      icon: Icons.rocket_launch_rounded,
                      isDark: isDark,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _CareerPathCarousel(
                      courses: jobReadyCourses,
                      isWeb: isWeb,
                      isDark: isDark,
                    ),
                  ),

                  // ── Continue Learning ───────────────────────
                  SliverToBoxAdapter(
                    child: _SectionHeader(
                      title: 'Continue Learning',
                      subtitle: 'Pick up where you left off',
                      icon: Icons.play_circle_rounded,
                      isDark: isDark,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) => _CourseListCard(
                          course: jobReadyCourses[index],
                          isDark: isDark,
                        ),
                        childCount: jobReadyCourses.length,
                      ),
                    ),
                  ),

                  // ── Programming Languages ───────────────────
                  SliverToBoxAdapter(
                    child: _SectionHeader(
                      title: 'Programming Languages',
                      subtitle: 'Master a language from scratch',
                      icon: Icons.terminal_rounded,
                      isDark: isDark,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) => _ProgrammingCard(
                          course: programmingCourses[index],
                          isDark: isDark,
                        ),
                        childCount: programmingCourses.length,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.95,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// GREETING BANNER
// ──────────────────────────────────────────────────────────────
class _GreetingBanner extends StatelessWidget {
  final bool isDark;
  const _GreetingBanner({required this.isDark});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning ☀️';
    if (hour < 17) return 'Good Afternoon 🌤️';
    return 'Good Evening 🌙';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4776E6).withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Ready to learn\nsomething new?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt_rounded,
                          color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Start Learning',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Decorative icon
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// SECTION HEADER
// ──────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isDark;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF4776E6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF4776E6), size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// CAREER PATH CAROUSEL
// ──────────────────────────────────────────────────────────────
class _CareerPathCarousel extends StatefulWidget {
  final List<JobReadyCourse> courses;
  final bool isWeb;
  final bool isDark;

  const _CareerPathCarousel({
    required this.courses,
    required this.isWeb,
    required this.isDark,
  });

  @override
  State<_CareerPathCarousel> createState() => _CareerPathCarouselState();
}

class _CareerPathCarouselState extends State<_CareerPathCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayCurve: Curves.easeInOut,
            aspectRatio: widget.isWeb ? 21 / 7 : 16 / 7,
            enlargeCenterPage: true,
            enlargeFactor: 0.15,
            viewportFraction: widget.isWeb ? 0.5 : 0.85,
            onPageChanged: (index, _) =>
                setState(() => _currentIndex = index),
          ),
          items: widget.courses.map((course) {
            return _CarouselCard(course: course, isDark: widget.isDark);
          }).toList(),
        ),
        const SizedBox(height: 12),
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.courses.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentIndex == entry.key ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentIndex == entry.key
                    ? const Color(0xFF4776E6)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CarouselCard extends StatelessWidget {
  final JobReadyCourse course;
  final bool isDark;

  const _CarouselCard({required this.course, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ModuleScreen(courseId: course.id)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: [
              course.color,
              course.color.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: course.color.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background decoration
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              left: -10,
              bottom: -30,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(course.icon,
                            color: Colors.white, size: 22),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Explore →',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// COURSE LIST CARD (Continue Learning section)
// ──────────────────────────────────────────────────────────────
class _CourseListCard extends StatelessWidget {
  final JobReadyCourse course;
  final bool isDark;

  const _CourseListCard({required this.course, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ModuleScreen(courseId: course.id)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: course.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(course.icon, color: course.color, size: 26),
            ),
            const SizedBox(width: 14),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    course.description,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey.shade500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Module count chips
                  Row(
                    children: [
                      _InfoChip(
                        // label: '${course.modules.length} modules',
                        color: course.color,
                      ),
                      const SizedBox(width: 6),
                      _InfoChip(
                        // label: 'Job Ready',
                        color: const Color(0xFF11998E),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Arrow
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: course.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_forward_rounded,
                  color: course.color, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  // final String label;
  final Color color;
  const _InfoChip({
    // required this.label,
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      // child: Text(
      //   // label,
      //   style: TextStyle(
      //       fontSize: 10,
      //       color: color,
      //       fontWeight: FontWeight.w600),
      // ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// PROGRAMMING LANGUAGE CARD
// ──────────────────────────────────────────────────────────────
class _ProgrammingCard extends StatelessWidget {
  final ProgrammingCourse course;
  final bool isDark;

  const _ProgrammingCard({required this.course, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${course.name} course coming soon!'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: course.color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(course.icon, color: course.color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              course.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isDark ? Colors.white : const Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Learn',
              style: TextStyle(
                fontSize: 10,
                color: course.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Kept for backward compatibility ────────────────────────────
class JobReadyCourseCard extends StatelessWidget {
  final JobReadyCourse course;
  const JobReadyCourseCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _CarouselCard(
        course: course,
        isDark: Theme.of(context).brightness == Brightness.dark);
  }
}

class ProgrammingCourseCard extends StatelessWidget {
  final ProgrammingCourse course;
  const ProgrammingCourseCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ProgrammingCard(
        course: course,
        isDark: Theme.of(context).brightness == Brightness.dark);
  }
}

class CourseModulesScreen extends StatelessWidget {
  final JobReadyCourse course;
  const CourseModulesScreen({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        // foregroundColor: isDark ? Colors.white : Colors.black87,
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
      body: const Center(child: Text('Module details')),
    );
  }
}

class ModuleDetailScreen extends StatelessWidget {
  final JobReadyModule module;
  const ModuleDetailScreen({Key? key, required this.module}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(module.title)),
      body: const Center(child: Text('Topic details')),
    );
  }
}

class JobReadyModuleCard extends StatelessWidget {
  final JobReadyModule module;
  const JobReadyModuleCard({Key? key, required this.module}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(title: Text(module.title)),
    );
  }
}