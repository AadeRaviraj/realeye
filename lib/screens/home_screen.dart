// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signin_screen.dart';
import 'InterviewPrep_screen.dart';
import 'faceDetection_screen.dart';
import 'package:realeyes/features/profile/screens/profile_screen.dart';
import 'study_screen.dart';
import 'package:realeyes/screens/exit_review_handler.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // ── State ───────────────────────────────────────────────────
  String _username = '';
  String? _profileImageUrl;
  int _selectedIndex = 0;
  bool _showFaceDetection = false;
  final ScrollController _scrollController = ScrollController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // ── Fixed motivational quote ────────────────────────────────
  static const String _quote =
      '"The future belongs to those who believe in the beauty of their dreams."';
  static const String _quoteAuthor = '— Eleanor Roosevelt';

  // ── Lifecycle ───────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _loadUserProfileImage();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ── Data fetching — unchanged logic ─────────────────────────
  void _loadUserProfileImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final snapshot = await FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(user.uid)
        .get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      if (mounted) {
        setState(() => _profileImageUrl = data['profile_image']);
      }
    }
  }

  void _fetchUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;
    final snapshot =
    await _database.child('users').child(user.uid).get();
    if (snapshot.exists) {
      final name = snapshot.child('full_name').value.toString();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('username', name);
      if (mounted) setState(() => _username = name);
    }
  }

  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
        _showFaceDetection = false;
      });
    }
  }

  String _getGreeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning ☀️';
    if (h < 17) return 'Good Afternoon 🌤️';
    return 'Good Evening 🌙';
  }

  // ── Build ────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final screens = [
      _buildHomeBody(isDark),
      StudyScreen(),
      InterviewPrepScreen(),
      const ProfileScreen(),
    ];

    return ExitReviewHandler(
      child: Scaffold(
        backgroundColor:
        isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF2F4F8),
        appBar: _selectedIndex != 0
            ? AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'Real',
                  style: TextStyle(
                    color: Colors.orange,
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: 'Eye',
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        )
            : null,
        body: _showFaceDetection
            ? FaceDetectionScreen(
          onBackToHome: () => setState(() {
            _showFaceDetection = false;
            _selectedIndex = 0;
          }),
        )
            : screens[_selectedIndex],
        bottomNavigationBar: _buildBottomNav(isDark),
      ),
    );
  }

  // ── Home Body ────────────────────────────────────────────────
  Widget _buildHomeBody(bool isDark) {
    final ImageProvider profileImg = _profileImageUrl != null
        ? NetworkImage(_profileImageUrl!)
        : const AssetImage('assets/images/angryp_cricle.png');

    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Sliver App Bar ──────────────────────────────────
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          floating: false,
          snap: false,
          backgroundColor:
          isDark ? const Color(0xFF0A0A0A) : const Color(0xFF4776E6),
          leading: const SizedBox.shrink(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 6, right: 14),
              child: GestureDetector(
                onTap: () => setState(() => _selectedIndex = 3),
                child: _CollapsingProfileImage(
                  scrollController: _scrollController,
                  image: profileImg,
                  size: 20,
                  visibilityTrigger: 0.5,
                ),
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            titlePadding:
            const EdgeInsets.only(left: 16, bottom: 14),
            title: _CollapsingTitleBuilder(
              scrollController: _scrollController,
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Real',
                      style: TextStyle(
                        color: Colors.orange,
                        fontStyle: FontStyle.italic,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: 'Eye',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            background: _HeroBanner(
              username: _username,
              profileImg: profileImg,
              greeting: _getGreeting(),
              isDark: isDark,
              onProfileTap: () => setState(() => _selectedIndex = 3),
            ),
          ),
        ),

        // ── Quote Card ──────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: _QuoteCard(
              quote: _quote,
              author: _quoteAuthor,
              isDark: isDark,
            ),
          ),
        ),

        // ── Feature Cards ───────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: _SectionTitle(title: 'Explore Features', isDark: isDark),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: _FeatureCards(
              onInterviewTap: () =>
                  setState(() => _selectedIndex = 2),
              onFaceTap: () =>
                  setState(() => _showFaceDetection = true),
              onStudyTap: () =>
                  setState(() => _selectedIndex = 1),
              isDark: isDark,
            ),
          ),
        ),

        // ── Quick Actions ───────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: _SectionTitle(title: 'Quick Actions', isDark: isDark),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final actions = _quickActions(context);
                return _ActionCard(
                  icon: actions[index]['icon'] as IconData,
                  label: actions[index]['label'] as String,
                  color: actions[index]['color'] as Color,
                  onTap: actions[index]['onTap'] as VoidCallback,
                );
              },
              childCount: _quickActions(context).length,
            ),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.25,
            ),
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _quickActions(BuildContext context) => [
    {
      'icon': Icons.description_rounded,
      'label': 'Resume Review',
      'color': const Color(0xFF2DD4BF),
      'onTap': () => _snack(context, 'Resume Review coming soon!'),
    },
    {
      'icon': Icons.mic_rounded,
      'label': 'Mock Interview',
      'color': const Color(0xFF8B5CF6),
      'onTap': () => setState(() => _selectedIndex = 2),
    },
    {
      'icon': Icons.quiz_rounded,
      'label': 'Daily Quiz',
      'color': const Color(0xFF4F46E5),
      'onTap': () => setState(() => _selectedIndex = 1),
    },
    {
      'icon': Icons.track_changes_rounded,
      'label': 'Goal Tracker',
      'color': const Color(0xFFFB7185),
      'onTap': () => _snack(context, 'Goal Tracker coming soon!'),
    },
    {
      'icon': Icons.psychology_rounded,
      'label': 'AI Coach',
      'color': const Color(0xFF10B981),
      'onTap': () => setState(() => _selectedIndex = 1),
    },
    {
      'icon': Icons.face_retouching_natural_rounded,
      'label': 'Face Detection',
      'color': const Color(0xFFFC5C7D),
      'onTap': () => setState(() => _showFaceDetection = true),
    },
    {
      'icon': Icons.school_rounded,
      'label': 'Study Hub',
      'color': const Color(0xFF6366F1),
      'onTap': () => setState(() => _selectedIndex = 1),
    },
    {
      'icon': Icons.people_rounded,
      'label': 'Community',
      'color': const Color(0xFFF97316),
      'onTap': () => _snack(context, 'Community coming soon!'),
    },
  ];

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    ));
  }

  // ── Bottom Navigation ────────────────────────────────────────
  Widget _buildBottomNav(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111111) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                selected: _selectedIndex == 0,
                isDark: isDark,
                onTap: () => _onItemTapped(0),
              ),
              _NavItem(
                icon: Icons.menu_book_rounded,
                label: 'Study',
                selected: _selectedIndex == 1,
                isDark: isDark,
                onTap: () => _onItemTapped(1),
              ),
              _NavItem(
                icon: Icons.record_voice_over_rounded,
                label: 'Interview',
                selected: _selectedIndex == 2,
                isDark: isDark,
                onTap: () => _onItemTapped(2),
              ),
              _NavItem(
                icon: Icons.account_circle_rounded,
                label: 'Profile',
                selected: _selectedIndex == 3,
                isDark: isDark,
                onTap: () => _onItemTapped(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// HERO BANNER
// ──────────────────────────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  final String username;
  final String greeting;
  final ImageProvider profileImg;
  final bool isDark;
  final VoidCallback onProfileTap;

  const _HeroBanner({
    required this.username,
    required this.greeting,
    required this.profileImg,
    required this.isDark,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF1a1a2e), const Color(0xFF16213e)]
              : [const Color(0xFF4776E6), const Color(0xFF8E54E9)],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -40, top: -40,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            left: -20, bottom: -40,
            child: Container(
              width: 130, height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Positioned(
            right: 60, bottom: 20,
            child: Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: onProfileTap,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white.withOpacity(0.6),
                                width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundImage: profileImg,
                            backgroundColor: Colors.white24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              greeting,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              username.isNotEmpty ? username : 'Learner',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Notification bell
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // App tagline chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.bolt_rounded,
                            color: Colors.amber, size: 14),
                        const SizedBox(width: 5),
                        Text(
                          'AI-Powered Interview Preparation',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// QUOTE CARD
// ──────────────────────────────────────────────────────────────
class _QuoteCard extends StatelessWidget {
  final String quote;
  final String author;
  final bool isDark;

  const _QuoteCard({
    required this.quote,
    required this.author,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF4776E6).withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4776E6).withOpacity(
                isDark ? 0.08 : 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.format_quote_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quote of the Day',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF4776E6),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  quote,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.55,
                    fontStyle: FontStyle.italic,
                    color: isDark
                        ? Colors.grey.shade300
                        : const Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  author,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                  ),
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
// SECTION TITLE
// ──────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;
  const _SectionTitle({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : const Color(0xFF1A1A2E),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// FEATURE CARDS — 3 cards in a row
// ──────────────────────────────────────────────────────────────
class _FeatureCards extends StatelessWidget {
  final VoidCallback onInterviewTap;
  final VoidCallback onFaceTap;
  final VoidCallback onStudyTap;
  final bool isDark;

  const _FeatureCards({
    required this.onInterviewTap,
    required this.onFaceTap,
    required this.onStudyTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _FeatItem(
        icon: Icons.record_voice_over_rounded,
        title: 'Interview\nPrep',
        sub: 'AI Questions',
        colors: [const Color(0xFF8E54E9), const Color(0xFF4776E6)],
        onTap: onInterviewTap,
      ),
      _FeatItem(
        icon: Icons.face_retouching_natural_rounded,
        title: 'Emotion\nDetect',
        sub: 'Face AI',
        colors: [const Color(0xFF11998E), const Color(0xFF38EF7D)],
        onTap: onFaceTap,
      ),
      _FeatItem(
        icon: Icons.menu_book_rounded,
        title: 'Study\nHub',
        sub: 'Learn & Grow',
        colors: [const Color(0xFFF7971E), const Color(0xFFFC5C7D)],
        onTap: onStudyTap,
      ),
    ];

    return Row(
      children: items.asMap().entries.map((entry) {
        final i = entry.key;
        final item = entry.value;
        return Expanded(
          child: GestureDetector(
            onTap: item.onTap,
            child: Container(
              margin: EdgeInsets.only(right: i < 2 ? 10 : 0),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: item.colors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: item.colors[0].withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.sub,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _FeatItem {
  final IconData icon;
  final String title, sub;
  final List<Color> colors;
  final VoidCallback onTap;
  const _FeatItem({
    required this.icon,
    required this.title,
    required this.sub,
    required this.colors,
    required this.onTap,
  });
}

// ──────────────────────────────────────────────────────────────
// ACTION CARD
// ──────────────────────────────────────────────────────────────
class _ActionCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1.0, end: 0.94)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Accent top bar
              Positioned(
                top: 0, left: 0, right: 0,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18)),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 18, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(widget.icon,
                          color: widget.color, size: 22),
                    ),
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? Colors.white
                            : const Color(0xFF1A1A2E),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// BOTTOM NAV ITEM
// ──────────────────────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF4776E6).withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: selected
                  ? const Color(0xFF4776E6)
                  : (isDark ? Colors.grey.shade500 : Colors.grey.shade400),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                selected ? FontWeight.bold : FontWeight.normal,
                color: selected
                    ? const Color(0xFF4776E6)
                    : (isDark
                    ? Colors.grey.shade500
                    : Colors.grey.shade400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// COLLAPSING PROFILE IMAGE — unchanged logic
// ──────────────────────────────────────────────────────────────
class _CollapsingProfileImage extends StatefulWidget {
  final ScrollController scrollController;
  final ImageProvider image;
  final double size;
  final double visibilityTrigger;

  const _CollapsingProfileImage({
    Key? key,
    required this.scrollController,
    required this.image,
    this.size = 20,
    this.visibilityTrigger = 0.5,
  }) : super(key: key);

  @override
  State<_CollapsingProfileImage> createState() =>
      _CollapsingProfileImageState();
}

class _CollapsingProfileImageState
    extends State<_CollapsingProfileImage> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_handleScroll);
    super.dispose();
  }

  void _handleScroll() {
    const expandedHeight = 220.0;
    const collapsedHeight = kToolbarHeight;
    const scrollRange = expandedHeight - collapsedHeight;
    final offset = widget.scrollController.offset;
    final newOpacity =
    ((offset / scrollRange - widget.visibilityTrigger) /
        (1 - widget.visibilityTrigger))
        .clamp(0.0, 1.0);
    if (newOpacity != _opacity) {
      setState(() => _opacity = newOpacity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacity,
      child: CircleAvatar(
        radius: widget.size,
        backgroundImage: widget.image,
        backgroundColor: Colors.white24,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// COLLAPSING TITLE BUILDER — unchanged logic
// ──────────────────────────────────────────────────────────────
class _CollapsingTitleBuilder extends StatefulWidget {
  final ScrollController scrollController;
  final Widget child;

  const _CollapsingTitleBuilder({
    Key? key,
    required this.scrollController,
    required this.child,
  }) : super(key: key);

  @override
  State<_CollapsingTitleBuilder> createState() =>
      _CollapsingTitleBuilderState();
}

class _CollapsingTitleBuilderState
    extends State<_CollapsingTitleBuilder> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_handleScroll);
    super.dispose();
  }

  void _handleScroll() {
    const expandedHeight = 220.0;
    const collapsedHeight = kToolbarHeight;
    const scrollRange = expandedHeight - collapsedHeight;
    final offset = widget.scrollController.offset;
    final newOpacity =
    ((offset / scrollRange - 0.3) / 0.7).clamp(0.0, 1.0);
    if (newOpacity != _opacity) {
      setState(() => _opacity = newOpacity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: _opacity, child: widget.child);
  }
}