// ============================================================
// File     : lib/features/profile/screens/profile_screen.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:navaveda/features/profile/providers/profile_provider.dart';
import 'package:navaveda/features/profile/widgets/profile_tab.dart';
import 'package:navaveda/features/profile/widgets/stats_tab.dart';
import 'package:navaveda/features/profile/widgets/settings_tab.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the existing ProfileProvider from main.dart — do NOT create a new one here.
    // Creating a new one caused the profile screen to show stale/old user data.
    return const _ProfileScreenBody();
  }
}

class _ProfileScreenBody extends StatefulWidget {
  const _ProfileScreenBody();

  @override
  State<_ProfileScreenBody> createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<_ProfileScreenBody>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<ProfileProvider>().refreshUserProfile();
    // });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (provider.isLoadingUser) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnim,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            // ── Sliver App Bar ──────────────────────────────
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              floating: false,
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  final isCollapsed = constraints.biggest.height < 120;
                  return FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: _ProfileHeader(provider: provider, isDark: isDark),
                    title: isCollapsed
                        ? Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: provider.profileImageUrl != null
                              ? NetworkImage(provider.profileImageUrl!)
                          as ImageProvider
                              : const AssetImage('assets/images/angryp_cricle.png'),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            provider.userName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                        : null,
                    titlePadding:
                    const EdgeInsetsDirectional.only(start: 16, bottom: 14),
                  );
                },
              ),
            ),

            // ── Tab Bar ─────────────────────────────────────
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                selectedTab: _selectedTab,
                onTabSelected: (i) => setState(() => _selectedTab = i),
                isDark: isDark,
              ),
            ),
          ],
          body: IndexedStack(
            index: _selectedTab,
            children: const [
              ProfileTab(),
              StatsTab(),
              SettingsTab(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Profile Header ─────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  final ProfileProvider provider;
  final bool isDark;
  const _ProfileHeader({required this.provider, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1a1a2e), const Color(0xFF16213e)]
              : [const Color(0xFF2F7BDA), const Color(0xFF8E54E9)],
          // colors : isDark ? Colors.blueAccent.shade400 : Colors.blue.shade600,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _showFullPhoto(context),
              child: Hero(
                tag: 'profile-avatar',
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 10),
                    ],
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: provider.profileImageUrl != null
                          ? NetworkImage(provider.profileImageUrl!) as ImageProvider
                          : const AssetImage('assets/images/angryp_cricle.png'),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              provider.userName.isEmpty ? 'Your Name' : provider.userName,
              style: const TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              provider.userRole.isEmpty ? ' ' : provider.userRole,
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // When user click on the profile photo
  void _showFullPhoto(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            color: Colors.black.withOpacity(0.85),
            child: Center(
              child: Hero(
                tag: 'profile-avatar',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: provider.profileImageUrl != null
                      ? Image.network(provider.profileImageUrl!, fit: BoxFit.contain)
                      : Image.asset('assets/images/angryp_cricle.png', fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}

// ── Tab Bar Delegate ───────────────────────────────────────────
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final int selectedTab;
  final ValueChanged<int> onTabSelected;
  final bool isDark;

  const _TabBarDelegate(
      {required this.selectedTab,
        required this.onTabSelected,
        required this.isDark});

  static const _tabs = [
    {'icon': Icons.person_rounded, 'label': 'Profile'},
    {'icon': Icons.bar_chart_rounded, 'label': 'Stats'},
    {'icon': Icons.settings_rounded, 'label': 'Settings'},
  ];

  @override
  double get minExtent => 60;

  @override
  double get maxExtent => 60;

  @override
  bool shouldRebuild(_TabBarDelegate old) =>
      old.selectedTab != selectedTab || old.isDark != isDark;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: isDark ? const Color(0xFF1a1a2e) : Colors.white,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0D0D1A) : const Color(0xFFF0F3FF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final isSelected = selectedTab == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTabSelected(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF577FE7)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _tabs[i]['icon'] as IconData,
                        size: 25,
                        color: isSelected ? Colors.white : Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _tabs[i]['label'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
