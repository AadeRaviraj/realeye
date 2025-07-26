/*

Author Name : Raviraj Aaade

File : profile_screen.dart

Date : 09-06-2025

Program : To develop the Profile Screen

 */


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'signin_screen.dart';


class ProfileScreen extends StatefulWidget {

  // Call the Constructor For Add the realtime Data when Profile scrren is open
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  final _dbRef = FirebaseDatabase.instance.ref().child('users');
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  String _selectedPlan = 'Pro';

  String _userName = '';  // declare  the userneme
  String _userEmail = '';
  String _userRole = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snap = await _dbRef.child(user.uid).get();
      if (snap.exists) {
        setState(() {
          _userName = snap.child('full_name').value?.toString() ?? ''; // user name is shown
          _userEmail = user.email ?? '';
          _userRole = snap.child('role').value?.toString() ?? '';
          _isLoading = false;
        });
      }
    }
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) =>  SignInScreen()),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final top = constraints.biggest.height;
                final avatarSize = top > 200 ? 120.0 : 40.0;
                final left = top > 200
                    ? MediaQuery.of(context).size.width / 2 - avatarSize / 2
                    : 16.0;
                final bottom = top > 200 ? 80.0 : (kToolbarHeight - 40) / 2;

                return Stack(
                  children: [
                    // Gradient background
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [Colors.blueGrey.shade800, Colors.blueGrey.shade900]
                              : [Colors.blue.shade600, Colors.lightBlue.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    // Avatar
                    Positioned(
                      left: left,
                      bottom: bottom,
                      child: Hero(
                        tag: 'profile-picture',
                        child: Container(
                          width: avatarSize,
                          height: avatarSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/angryp_cricle.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Username
                    if (top > 200)
                      Positioned(
                        bottom: 45,
                        left: 0,
                        right: 0,
                        child: Text(
                          _userName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )
                    else
                      Positioned(
                        left: avatarSize + 24,
                        bottom: (kToolbarHeight - 20) / 2,
                        child: Text(
                          _userName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            leading: const SizedBox(),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _UserInfoTile(
                      icon: Icons.email,
                      title: 'Email',
                      value: _userEmail,
                    ),
                    const SizedBox(height: 20),
                    _StatsGrid(
                      completed: 15,
                      ongoing: 3,
                      points: 420,
                    ),
                    const SizedBox(height: 30),
                    _ProgressCard(
                      progress: 0.6,
                      title: 'Learning Progress',
                      subTitle: 'Completed 60% of your goals',
                    ),
                    const SizedBox(height: 30),
                    _SubscriptionCard(
                      daysLeft: 20,
                      onManagePressed: _showSubscriptionDialog,
                    ),
                    const SizedBox(height: 30),
                    _ActionGrid(
                      onLogout: _logout,
                      onSubscription: _showSubscriptionDialog,
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }



  //  code for the subscription plan

  void _showSubscriptionDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? Colors.blue.shade200 : Colors.blue.shade600;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [Colors.blueGrey.shade900, Colors.grey.shade800]
                        : [Colors.white, Colors.blue.shade50],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Choose Your Plan',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildPlanCard(
                        context,
                        title: 'Basic',
                        price: '₹99',
                        duration: '1 Month',
                        benefits: ['All Features', 'Unlimited Interviews', 'Priority Support', 'Practice Tests'],
                        isRecommended: false,
                        selectedPlan: _selectedPlan,
                        onSelect: (plan) {
                          setState(() {
                            _selectedPlan = plan;
                          });
                          setStateDialog(() {}); // Update dialog state
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildPlanCard(
                        context,
                        title: 'Pro',
                        price: '₹499',
                        duration: '6 Months',
                        benefits: ['All Features', 'Unlimited Interviews', 'Priority Support', 'Practice Tests'],
                        isRecommended: true,
                        selectedPlan: _selectedPlan,
                        onSelect: (plan) {
                          setState(() {
                            _selectedPlan = plan;
                          });
                          setStateDialog(() {});
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildPlanCard(
                        context,
                        title: 'Enterprise',
                        price: '₹1499',
                        duration: '1 Year',
                        benefits: ['All Pro Features', 'Team Access', 'Analytics Dashboard', '24/7 Support'],
                        isRecommended: false,
                        selectedPlan: _selectedPlan,
                        onSelect: (plan) {
                          setState(() {
                            _selectedPlan = plan;
                          });
                          setStateDialog(() {});
                        },
                      ),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Not now',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }



}


Widget _buildPlanCard(
    BuildContext context, {
      required String title,
      required String price,
      required String duration,
      required List<String> benefits,
      required bool isRecommended,
      required String? selectedPlan,
      required Function(String) onSelect,
    }) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final accentColor = isDark ? Colors.blue.shade200 : Colors.blue.shade600;
  final bool isSelected = title == selectedPlan;

  // Card color logic: Blue for selected card, default (white/grey) for others
  Color cardColor = isSelected
      ? accentColor  // Selected card color
      : (isDark ? Colors.grey.shade800 : Colors.white);

  // Text color for selected/unselected state
  Color textColor = isSelected
      ? Colors.white
      : (isDark ? Colors.white : Colors.black87);

  // Button color when selected/unselected
  Color buttonColor = isSelected ? Colors.white : accentColor;
  Color buttonTextColor = isSelected ? accentColor : Colors.white;




  // Add the 'Popular Plan' text for the Pro plan

  Widget? popularTag = (title == 'Pro' && isRecommended)
      ? Positioned(
    right: 8,
    top: 8,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade300, Colors.green.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade200.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2), // shadow position
          ),
        ],
      ),
      child: Text(
        'Popular',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 1.2, // Slight letter spacing for elegance
        ),
      ),
    ),
  )
      : null;
  // Widget? popularTag = (title == 'Pro' && isRecommended)
  //     ? Positioned(
  //   right: -12,
  //   top: -12,
  //   child: Transform.rotate(
  //     angle: 0.1,
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
  //       decoration: BoxDecoration(
  //         gradient: LinearGradient(
  //           colors: [Colors.cyanAccent, Colors.purpleAccent],
  //           stops: [0.1, 0.9],
  //         ),
  //         borderRadius: BorderRadius.circular(16),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.purple.withOpacity(0.3),
  //             spreadRadius: 8,
  //             blurRadius: 16,
  //             offset: Offset(0, 4),
  //           ),
  //         ],
  //       ),
  //       child: Row(
  //         children: [
  //           Icon(Icons.auto_awesome, size: 18, color: Colors.white),
  //           SizedBox(width: 8),
  //           Text(
  //             'HOT DEAL',
  //             style: GoogleFonts.poppins(
  //               color: Colors.white,
  //               fontWeight: FontWeight.w800,
  //               fontSize: 14,
  //               shadows: [
  //                 Shadow(
  //                   color: Colors.black.withOpacity(0.2),
  //                   blurRadius: 4,
  //                   offset: Offset(1, 1),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   ),
  // )
  //     : null;








  return Material(
    borderRadius: BorderRadius.circular(16),
    color: cardColor,
    elevation: 4,
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        onSelect(title); // Select the plan and update the state
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? accentColor : Colors.transparent,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: price,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      TextSpan(
                        text: ' $duration',
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected
                              ? Colors.white.withOpacity(0.8)
                              : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ...benefits.map((benefit) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: isSelected ? Colors.white : Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          benefit,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : (isDark ? Colors.white : Colors.black87),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      isSelected ? 'Selected' : 'Choose Plan',
                      style: TextStyle(
                        color: buttonTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (popularTag != null) popularTag, // Show 'Popular Plan' if it's Pro
          ],
        ),
      ),
    ),
  );
}










class _UserInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _UserInfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade400),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}






class _StatsGrid extends StatelessWidget {
  final int completed;
  final int ongoing;
  final int points;

  const _StatsGrid({
    required this.completed,
    required this.ongoing,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 0.8,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: [
        _StatItem(
          value: completed,
          label: 'Completed',
          color: Colors.green,
          icon: Icons.check_circle,
        ),
        _StatItem(
          value: ongoing,
          label: 'Ongoing',
          color: Colors.orange,
          icon: Icons.hourglass_top,
        ),
        _StatItem(
          value: points,
          label: 'Points',
          color: Colors.purple,
          icon: Icons.star,
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final int value;
  final String label;
  final Color color;
  final IconData icon;

  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
      ), // Added missing comma here
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 10),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );

  }
}

class _ProgressCard extends StatelessWidget {
  final double progress;
  final String title;
  final String subTitle;

  const _ProgressCard({
    required this.progress,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade400,
            Colors.lightBlue.shade300,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subTitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 20),
          Stack(
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) => AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: constraints.maxWidth * progress,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final int daysLeft;
  final VoidCallback onManagePressed;

  const _SubscriptionCard({
    required this.daysLeft,
    required this.onManagePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.workspace_premium, color: Colors.orange),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Premium Plan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Expires in $daysLeft days',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: onManagePressed,
          ),
        ],
      ),
    );
  }
}

class _ActionGrid extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onSubscription;

  const _ActionGrid({
    required this.onLogout,
    required this.onSubscription,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: [
        _ActionButton(
          icon: Icons.edit,
          label: 'Edit Profile',
          // color: Colors.blue,
          color:Color(0xFF780C28),
          onTap: () {},
        ),
        _ActionButton(
          icon: Icons.settings,
          label: 'Settings',
          // color: Colors.grey,
          color:Color(0xFF000957),
          onTap: () {},
        ),
        _ActionButton(
          icon: Icons.credit_card,
          label: 'Subscription',
          // color: Colors.purple,
          color:Color(0xFF059212),
          onTap: onSubscription,
        ),
        _ActionButton(
          icon: Icons.logout,
          label: 'Log Out',
          // color: Colors.red,
          color:Color(0xFFFF1700),
          onTap: onLogout,
        ),
        _ActionButton(
          icon: Icons.person,
          label: 'About Us',
          // color: Colors.deepOrange,
          color: Color(0xFF8E05C2),
          // onTap: () {},
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUsScreen()),
              );
            }
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: color.withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


//About us Screen Section

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [Colors.indigo.shade900, Colors.purple.shade900]
                : [Colors.blue.shade50, Colors.purple.shade50],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBar(
                title: const Text('Dream Team'),
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              _buildTeamMemberCard(
                context,
                name: 'Pooja Borgavi',
                role: 'UI Designer ',
                image: 'assets/images/pooja.jpeg',
                color: Colors.pink,
                info: 'Pixel Perfectionist\nCreative Visionary\nUI/UX Alchemist\n - realeye',
                quote: '"Design is intelligence made visible"',
              ),
              _buildTeamMemberCard(
                context,
                name: 'Vikaskumar Chaurasiya',
                role: 'QA Analyst ',
                image: 'assets/images/vikas.jpg',
                color: Colors.blueAccent,
                info: 'Bug Hunter Extraordinaire\nQuality Guardian\nTesting Maestro\n - realeye',
                quote: '"Quality is not an act, it\'s a habit"',
              ),
              _buildTeamMemberCard(
                context,
                name: 'Raviraj Aade',
                role: 'Backend Developer',
                image: 'assets/images/raviraj.jpg',
                color: Colors.purple,
                // color: Theme.of(context).colorScheme.onSurface, // Adaptive color
              // Specific role color
                info: 'Code Architect\nServer Wizard\nDatabase\n - realeye',
                quote: '"First solve the problem, then write the code"',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMemberCard(
      BuildContext context, {
        required String name,
        required String role,
        required String image,
        required Color color,
        required String info,
        required String quote,
        Color? roleColor
      }) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(image),
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(2, 2),
                      )
                    ],
                  ),
                ),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 18,
                    // color: color.withOpacity(0.8),
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                Divider(color: color.withOpacity(0.3)),
                const SizedBox(height: 16),
                Text(
                  info,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  quote,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                    fontStyle: FontStyle.italic,
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

