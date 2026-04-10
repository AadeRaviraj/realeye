import 'dart:convert' show jsonDecode;

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';// For picking images
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../design/language_provider.dart';
import '../models/DailyStat.dart';
import 'signin_screen.dart';
import 'dart:io'; // For File
import 'package:navaveda/design/theme_provider.dart';// import theme class providr form services folder
import 'package:navaveda/generated/app_localizations.dart';
import '../models/dashboard_data.dart';
import '../services/api_service.dart';
import 'package:flutter/services.dart';





class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>


    // handle the click actions
    with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  String? get _firebaseUid => _auth.currentUser?.uid;
  final _dbRef = FirebaseDatabase.instance.ref().child('users');
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  String _selectedPlan = 'Pro';

  String _userName = '';
  String _userEmail = '';
  String _userRole = '';
  bool _isLoading = true;
  String? _profileImageUrl;


  int _selectedTab = 0;
  final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  final ScrollController _scrollController = ScrollController();

  ImageProvider get profileImageProvider {
    return _profileImageUrl != null
        ? NetworkImage(_profileImageUrl!)
        : const AssetImage('assets/images/angryp_cricle.png');
  }

  DashboardData? _dashboardData;
  bool _loadingDashboard = false;

  // load dashboard data
  Future<void> _loadDashboardData() async {
    final uid = _firebaseUid;
    if (uid == null) return;
    setState(() => _loadingDashboard = true);
    try {
      final data = await ApiService.fetchDashboard(uid);
      setState(() {
        _dashboardData = data;
        _loadingDashboard = false;
      });
    } catch (e) {
      print('Error loading dashboard: $e');
      setState(() => _loadingDashboard = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();



    final user = _auth.currentUser;
    if (user != null) {
      //  Listen for real-time changes in this user's data
      _dbRef.child(user.uid).onValue.listen((event) {
        final snap = event.snapshot;
        //  Check if data exists for this user
        if (snap.exists) {
          setState(() {
            //  Update the state variables with latest values from Firebase
            _userName = snap.child('full_name').value?.toString() ?? '';
            _userEmail = user.email ?? '';   // Email comes directly from FirebaseAuth
            _userRole = snap.child('role').value?.toString() ?? '';

            //  Once data is loaded, stop showing the loading indicator
            _isLoading = false;
          });
        }

      });
    }

// Load Dashboard data
    _loadDashboardData();



    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
  }


  void _loadUserData() async {

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(user.uid)
        .get();

    if (snapshot.exists) {
      final data = snapshot.value as Map;
      setState(() {
        _userName = data['full_name'] ?? 'Your Name';
        _userRole = data['role'] ?? 'User';
        _profileImageUrl = data['profile_image'];
      });
    }
  }


  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    _scrollController.dispose();
// _showEditProfileDialog();
    super.dispose();
  }



  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) =>  SignInScreen()),
    );
  }

  void _showAchievementCelebration() {
    _confettiController.play();
    Future.delayed(const Duration(seconds: 2), () {
      _confettiController.stop();
    });
  }

  void _showFullScreenProfile() {
    //Uses this function for when user click on the user profile
    //then it show the full image
    showDialog(

      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black.withOpacity(0.8),
              child: Center(
                child: Hero(
                  tag: 'profile-picture',
                  child:   _profileImageUrl != null
                ? Image.network(
                _profileImageUrl!,
                  fit: BoxFit.contain,
                )
                    :Image.asset(
                'assets/images/angryp_cricle.png',
                fit: BoxFit.contain,
              ),
                ),


              ),
            ),
          ),
        );
      },
    );
  }

  void _showSubscriptionDialog() {
    //It shows the subscription model
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? Colors.blue.shade800 : Colors.blue.shade600;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 20,
              insetPadding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
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
                        benefits: [
                          'All Features',
                          'Unlimited Interviews',
                          'Priority Support',
                          'Practice Tests'
                        ],
                        isRecommended: false,
                        selectedPlan: _selectedPlan,
                        onSelect: (plan) {
                          setState(() {
                            _selectedPlan = plan;
                          });
                          setStateDialog(() {});
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildPlanCard(
                        context,
                        title: 'Pro',
                        price: '₹499',
                        duration: '6 Months',
                        benefits: [
                          'All Features',
                          'Unlimited Interviews',
                          'Priority Support',
                          'Practice Tests'
                        ],
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
                        benefits: [
                          'All Pro Features',
                          'Team Access',
                          'Analytics Dashboard',
                          '24/7 Support'
                        ],
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
    final accentColor = isDark ? Colors.blueAccent.shade400 : Colors.blue.shade600;
    final bool isSelected = title == selectedPlan;

    Color cardColor = isSelected
        ? accentColor
        : (isDark ? Colors.grey.shade900 : Colors.white);


    Color textColor = isSelected ? Colors.white : Theme.of(context).textTheme.bodyLarge!.color!;

    Color buttonColor = isSelected ? Colors.white : accentColor;
    Color buttonTextColor = isSelected ? accentColor : Colors.white;

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
        ),
        child: Text(
          'Popular',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 1.2,
          ),
        ),
      ),
    )
        : null;

    return Material(
      borderRadius: BorderRadius.circular(16),
      color: cardColor,
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => onSelect(title),
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
                              color: textColor,
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
              if (popularTag != null) popularTag,
            ],
          ),
        ),
      ),
    );


  }


  void _showEditProfileDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? Colors.white : Colors.black;
    final picker = ImagePicker();
    File? _imageFile;
    String _name = _userName;
    bool _isUploading = false;
    bool _isModified = false; // if teh user change their name of phtoto

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            Future<void> _pickImage() async {
              final pickedFile = await picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                // Size check (1MB)
                final bytes = await pickedFile.readAsBytes();
                final sizeMB = bytes.length / (1024 * 1024);
                if (sizeMB > 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Image must be <= 1MB')),
                  );
                  return;
                }

                setStateDialog(() {
                  _imageFile = File(pickedFile.path);
                  _isModified = true; //  user change their  photo , mark as user change their photo
                });
              }
            }

            Future<void> _saveProfile() async {
              try {
                setStateDialog(() {
                  _isUploading = true;
                });

                final user = FirebaseAuth.instance.currentUser;
                if (user == null) return;

                String? imageUrl;

                // Upload to Flask backend (Cloudinary)
                if (_imageFile != null) {
                  final uri = Uri.parse('https://realeye.onrender.com/api/upload-profile');
                  final request = http.MultipartRequest('POST', uri)
                    ..files.add(await http.MultipartFile.fromPath('image', _imageFile!.path))
                    ..fields['user_id'] = user.uid;

                  final response = await request.send();
                  final respStr = await response.stream.bytesToString();

                  if (response.statusCode == 200) {
                    final data = jsonDecode(respStr);
                    imageUrl = data['secure_url'];
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Upload failed')),
                    );
                  }
                }

                //  Update in Firebase Realtime Database
                final updates = <String, dynamic>{};
                if (_name.isNotEmpty) updates['full_name'] = _name;
                if (imageUrl != null) updates['profile_image'] = imageUrl;

                await FirebaseDatabase.instance
                    .ref()
                    .child("users")
                    .child(user.uid)
                    .update(updates);

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully')),
                );
                //after upload teh image
                setState(() {
                  _profileImageUrl = imageUrl; // after upload
                });
              } catch (e) {
                print('Error updating profile: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update profile: $e')),
                );
              } finally {
                setStateDialog(() {
                  _isUploading = false;
                });
              }
            }
            TextEditingController _nameController = TextEditingController(text: _name);


            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 20,
              insetPadding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 48,
                            backgroundImage:
                            _imageFile != null ? FileImage(_imageFile!) : null,
                            child: _imageFile == null
                                ? Icon(Icons.camera_alt, size: 32, color: Colors.grey.shade900)
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),


                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _name = value.trim();
                          setStateDialog(() {
                            _isModified = true; // User changed their name
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      _isUploading
                          ? const Center(child: CircularProgressIndicator())
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.grey.shade900),
                            ),
                          ),
                          ElevatedButton(

                           // onPressed: _saveProfile,
                            //child: const Text('Save'),

                            onPressed: _isModified ? _saveProfile : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isModified
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade300,
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: _isModified ? Colors.white : Colors.grey.shade600,
                              ),
                            ),

                          ),
                        ],
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





  // Widget to handle the user profile image and username.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App Bar with user profile
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    final top = constraints.biggest.height;
                    final isCollapsed = top < 100;

                    return FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? [
                              Colors.blueGrey.shade900,
                              Colors.blueGrey.shade900,
                            ]
                                : [
                              Colors.blue.shade700,
                              Colors.lightBlue.shade500,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),



                        child: Align(
                          alignment: const FractionalOffset(0.5, 2.0), // X=0.5 (center horizontally), Y=0.7 (downward)
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: _showFullScreenProfile,
                                    child: Hero(
                                      tag: 'profile-picture',
                                      child: Container(
                                        width: isCollapsed ? 60 : 120,
                                        height: isCollapsed ? 60 : 120,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 3),
                                          image: DecorationImage(
                                            image: _profileImageUrl != null
                                                ? NetworkImage(_profileImageUrl!)
                                                : const AssetImage('assets/images/angryp_cricle.png') as ImageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (!isCollapsed)
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2),
                                        ),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                                          onPressed: () => _showEditProfileDialog(),
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                              if (!isCollapsed) const SizedBox(height: 12),

                              if (!isCollapsed)
                                Text(
                                  _userName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                ),

                              if (!isCollapsed) const SizedBox(height: 6),

                              if (!isCollapsed)
                                Text(
                                  _userRole,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                ),
                            ],
                          ),
                        ),




                      ),
                      title: isCollapsed
                          ? Text(
                        _userName,
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                          : null,
                      titlePadding: isCollapsed
                          ? const EdgeInsetsDirectional.only(start: 16, bottom: 16)
                          : EdgeInsets.zero,
                    );
                  },
                ),
              ),
              // Content Section
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Tabbed content
                        _buildTabBar(),
                        const SizedBox(height: 20),
                        // Content based on selected tab
                        _buildTabContent(),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
          // Confetti animation
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
      ),
    );
  }


  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
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
          _TabButton(
            icon: Icons.person,

            text: 'Profile',
            isSelected: _selectedTab == 0,
            onTap: () => setState(() => _selectedTab = 0),
          ),
          _TabButton(
            icon: Icons.analytics,
            text: 'Stats',

            isSelected: _selectedTab == 1,
            onTap: () => setState(() => _selectedTab = 1),
          ),
          _TabButton(
            icon: Icons.settings,
            text: 'Settings',

            isSelected: _selectedTab == 2,
            onTap: () => setState(() => _selectedTab = 2),
          ),
        ],
      ),
    );
  }


  Widget _buildTabContent() {
    return IndexedStack(
      index: _selectedTab,
      children: [
        _buildProfileTab(),
        _buildStatsTab(),
        _buildSettingsTab(),
      ],
    );
  }

  Widget _buildProfileTab() {
    if (_loadingDashboard) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_dashboardData == null) {
      return const Center(child: Text('Could not load progress'));
    }
    final data = _dashboardData!;
    return SingleChildScrollView(
      child: Column(
        children: [
          _UserInfoCard(email: _userEmail),
          const SizedBox(height: 24),
          _CustomProgressCard(
            progress: data.completionPercentage / 100,
            title: 'Learning Progress',
            subTitle: 'Completed ${data.completionPercentage.toStringAsFixed(1)}% of subtopics',
            onCelebrate: _showAchievementCelebration,
          ),
          const SizedBox(height: 24),
          _SubscriptionCard(
            daysLeft: 20,
            onManagePressed: _showSubscriptionDialog,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }


  Widget _buildStatsTab() {
    final uid = _firebaseUid;
    if (uid == null) return const Center(child: Text('User not logged in'));

    // Use cached data if available
    if (_dashboardData != null) {
      return _buildStatsContent(_dashboardData!);
    }

    // Otherwise fetch
    return FutureBuilder<DashboardData>(
      future: ApiService.fetchDashboard(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading stats: ${snapshot.error}'));
        }
        final data = snapshot.data!;
        // Cache for later
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _dashboardData = data;
            });
          }
        });
        return _buildStatsContent(data);
      },
    );
  }

  Widget _buildStatsContent(DashboardData data) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _RealStatsSection(data: data),
          const SizedBox(height: 24),
          _WeeklyActivityChart(firebaseUid: _firebaseUid!),
          const SizedBox(height: 24),
          _AchievementBadges(
            onBadgeUnlocked: _showAchievementCelebration,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }



  //in this Widget handle the setting tab  all actions  cards (eg...edit profile , setting , subscription,etc etc)
  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _ActionsGrid(
            onLogout: _logout,
            onSubscription: _showSubscriptionDialog,
            onEditProfile: _showEditProfileDialog,
          ),
          const SizedBox(height: 24),
        //  _AppSettings(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }


}

// Tab Button Widget class
class _TabButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.icon,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: isSelected
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected
                  // ? Theme.of(context).primaryColorLight
                      ? Colors.blue //: Colors.pink
                      : Theme.of(context).textTheme.bodyLarge!.color,
                  size: 20,
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                       // ? Theme.of(context).primaryColorLight
                        ? Colors.blue
                        : Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// User Info Card Widget
class _UserInfoCard extends StatelessWidget {
  final String email;

  const _UserInfoCard({required this.email});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: Icon(Icons.email,
                  color: Theme.of(context).primaryColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.content_copy, color: Theme.of(context).primaryColor),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: email));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email copied')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Progress Card Widget
class _CustomProgressCard extends StatelessWidget {
  final double progress;
  final String title;
  final String subTitle;
  final VoidCallback onCelebrate;

  const _CustomProgressCard({
    required this.progress,
    required this.title,
    required this.subTitle,
    required this.onCelebrate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade400,
              Colors.lightBlue.shade300,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.celebration, color: Colors.white),
                    onPressed: onCelebrate,
                  ),
                ],
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
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                        strokeWidth: 8,
                      ),
                    ),
                    Text(
                      "${(progress * 100).toInt()}%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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

// Stats Section Widget
class _StatsSection extends StatelessWidget {
  final int completed;
  final int ongoing;
  final int points;

  const _StatsSection({
    required this.completed,
    required this.ongoing,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            value: completed,
            label: 'Completed',
            color: Colors.green,
            icon: Icons.check_circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatTile(
            value: ongoing,
            label: 'Ongoing',
            color: Colors.orange,
            icon: Icons.hourglass_top,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatTile(
            value: points,
            label: 'Points',
            color: Colors.purple,
            icon: Icons.star,
          ),
        ),
      ],
    );
  }
}

// Stat Tile Widget
class _StatTile extends StatelessWidget {
  final int value;
  final String label;
  final Color color;
  final IconData icon;

  const _StatTile({
    required this.value,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 18,
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
      ),
    );
  }
}

class _WeeklyActivityChart extends StatefulWidget {
  final String firebaseUid;
  const _WeeklyActivityChart({required this.firebaseUid});

  @override
  __WeeklyActivityChartState createState() => __WeeklyActivityChartState();
}

class __WeeklyActivityChartState extends State<_WeeklyActivityChart> {
  String _selectedRange = 'week'; // 'week', 'month', 'year'
  late Future<List<DailyStat>> _statsFuture;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  void _fetchStats() {
    _statsFuture = ApiService.fetchDailyStats(widget.firebaseUid, range: _selectedRange);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedRange,
                  items: const [
                    DropdownMenuItem(value: 'week', child: Text('Last 7 days')),
                    DropdownMenuItem(value: 'month', child: Text('Last 30 days')),
                    DropdownMenuItem(value: 'year', child: Text('Last 12 months')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedRange = value!;
                      _fetchStats();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<DailyStat>>(
              future: _statsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final stats = snapshot.data!;
                if (stats.isEmpty) {
                  return const Center(child: Text('No activity yet'));
                }
                // Find max minutes for scaling
                int maxMinutes = stats.map((e) => e.minutes).reduce((a, b) => a > b ? a : b);
                return SizedBox(
                  height: 150,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: stats.map((stat) {
                      double factor = maxMinutes == 0 ? 0 : stat.minutes / maxMinutes;
                      return _ChartBar(
                        label: _formatDate(stat.date),
                        value: stat.minutes,
                        heightFactor: factor,
                      );
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

  String _formatDate(DateTime date) {
    if (_selectedRange == 'week') {
      // Show day of week
      const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return weekdays[date.weekday - 1];
    } else if (_selectedRange == 'month') {
      // Show day of month
      return '${date.day}';
    } else {
      // Show month abbreviation
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return months[date.month - 1];
    }
  }
}


// Chart Bar Widget
class _ChartBar extends StatelessWidget {
  final String label;
  final int value;
  final double heightFactor; // 0..1

  const _ChartBar({
    required this.label,
    required this.value,
    required this.heightFactor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final maxBarHeight = constraints.maxHeight * 0.6; // reserve 60% height for bar
        final barHeight = maxBarHeight * heightFactor;

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 20,
              height: barHeight,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.black,
              ),
            ),
          ],
        );
      },
    );
  }
}


// Achievement Badges Widget
class _AchievementBadges extends StatelessWidget {
  final VoidCallback onBadgeUnlocked;

  const _AchievementBadges({required this.onBadgeUnlocked});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Achievements',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _AchievementBadge(
                  icon: Icons.star,
                  title: 'Beginner',
                  achieved: true,
                  onTap: onBadgeUnlocked,
                ),
                _AchievementBadge(
                  icon: Icons.auto_awesome,
                  title: 'Intermediate',
                  achieved: true,
                  onTap: onBadgeUnlocked,
                ),
                _AchievementBadge(
                  icon: Icons.workspace_premium,
                  title: 'Expert',
                  achieved: false,
                  onTap: onBadgeUnlocked,
                ),
                _AchievementBadge(
                  icon: Icons.emoji_events,
                  title: 'Master',
                  achieved: false,
                  onTap: onBadgeUnlocked,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Achievement Badge Widget
class _AchievementBadge extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool achieved;
  final VoidCallback onTap;

  const _AchievementBadge({
    required this.icon,
    required this.title,
    required this.achieved,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: achieved
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
              boxShadow: achieved
                  ? [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ]
                  : null,
            ),
            child: Icon(
              icon,
              color: achieved ? Colors.white : Colors.grey.shade600,
              size: 30,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall!.color,
          ),
        ),
      ],
    );
  }


}

// Subscription Card Widget
class _SubscriptionCard extends StatelessWidget {
  final int daysLeft;
  final VoidCallback onManagePressed;

  const _SubscriptionCard({
    required this.daysLeft,
    required this.onManagePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange.shade100,
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
      ),
    );
  }
}

// App Settings Widget
// class _AppSettings extends StatelessWidget {
//   bool _isSwitched = true;
class _AppSettings extends StatefulWidget {
  @override
  State<_AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<_AppSettings> {
  bool _isSwitched = true;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // theme provider variable  it stores teh theme
    final languageProvider = Provider.of<LanguageProvider>(context); // language provider

//    final currentLocale = languageProvider.locale ?? Localizations.localeOf(context);
//     final currentLocale = languageProvider.locale;
    final currentLocale = Provider.of<LanguageProvider>(context).locale;
    print("ProfileScreen: currentLocale = $currentLocale");
    print("ProfileScreen: Localizations.localeOf(context) = ${Localizations.localeOf(context)}");
    print("ProfileScreen: AppLocalizations.of(context).changeLanguage = ${AppLocalizations.of(context).changeLanguage}");

    return Card(

      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1),
      ),
      child: Padding(

        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            _SettingsItem(
              icon: Icons.notifications,
              // title: 'Notifications',
              title: AppLocalizations.of(context).notifications,
              trailing: Switch(
                value: _isSwitched, // This should be a boolean variable in your state
                onChanged: (value) {
                  // setState(() {
                  //   _isSwitched = value;
                  // });
                },
              ),

            ),
            const Divider(),

            _SettingsItem(
              icon: Icons.dark_mode,
              // title: 'Dark Mode',
              title: AppLocalizations.of(context).darkMode,
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
              ),
            //     trailing: Switch(
            //       value: themeProvider.isDarkMode,
            //       onChanged: (value) => themeProvider.toggleTheme(value),
            //     ),
           ),
            const Divider(),

            // ListTile(
            //   leading: const Icon(Icons.language),
            //   title: Text(AppLocalizations.of(context)!.changeLanguage),
            // ),
            Consumer<LanguageProvider>(
              builder: (context, languageProvider, child) {
                return ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(AppLocalizations.of(context).changeLanguage),
                );
              },
            ),
            RadioListTile<Locale>(
              title: const Text("English"),
              value: const Locale('en'),
              groupValue: currentLocale,
              onChanged: (Locale? locale) {
                if (locale != null) languageProvider.setLocale(locale);
              },
            ),
            RadioListTile<Locale>(
              title: const Text("मराठी"),
              value: const Locale('mr'),
              groupValue: currentLocale,
              onChanged: (Locale? locale) {
                if (locale != null) languageProvider.setLocale(locale);
              },
            ),
            RadioListTile<Locale>(
              title: const Text("हिंदी"),
              value: const Locale('hi'),
              groupValue: currentLocale,
              onChanged: (Locale? locale) {
                if (locale != null) languageProvider.setLocale(locale);
              },
            ),

            const Divider(),
            _SettingsItem(
              icon: Icons.security,
              // title: 'Privacy & Security',
              title: AppLocalizations.of(context).privacySecurity,
              trailing: const Icon(Icons.arrow_forward),
            ),
            const Divider(),
            _SettingsItem(
              icon: Icons.help,
              // title: 'Help & Support',
              title: AppLocalizations.of(context).helpSupport,
              trailing: const Icon(Icons.arrow_forward),
            ),
            const Divider(),
            _SettingsItem(
                icon: Icons.star_rate,
                // title: "Rate Us",
                title: AppLocalizations.of(context).rateUs,
                trailing:const Icon( Icons.rate_review_rounded)
            ),
          ],
        ),
      ),
    );
  }
}

// Settings Item Widget
class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      trailing: trailing,
      onTap: () {},
    );
  }


}

// Actions Grid Widget ( when user clicks on the the card(action buttons) eg. Edit profile, Setting,Subscription....)
class _ActionsGrid extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onSubscription;
  final VoidCallback onEditProfile;

  const _ActionsGrid({
    required this.onLogout,
    required this.onSubscription,
    required this.onEditProfile
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: [
        _ActionButton(
          icon: Icons.edit,
          label: 'Edit Profile',
          color: const Color(0xFF780C28),
          onTap: onEditProfile,
        ),
        _ActionButton(
          icon: Icons.settings,
          label: 'Settings',
          color: const Color(0xFF000957),
          onTap: () {
            Navigator.push(
              context,
                MaterialPageRoute(builder: (context) => const SettingScreen()),
            );
          },
        ),
        _ActionButton(
          icon: Icons.credit_card,
          label: 'Subscription',
          color: const Color(0xFF059212),
          onTap: onSubscription,
        ),
        _ActionButton(
          icon: Icons.logout,
          label: 'Log Out',
          color: const Color(0xFFFF1700),
          onTap: onLogout,
        ),
        _ActionButton(
          icon: Icons.person,
          label: 'About Us',
          color: const Color(0xFF8E05C2),
          onTap: () {
            // Navigator.push(
            //   context,
            //   // MaterialPageRoute(builder: (context) => const AboutUsScreen()), // navigate the about screen
            // );
          },
        ),
        _ActionButton(
          icon: Icons.share,
          label: 'Share App',
          color: const Color(0xFF0466C8),
          onTap: () {},
        ),
      ],
    );
  }
}

// Action Button Widget
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




// Setting screen
class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    // Define the style
    final SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark, // dark icons if light theme
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,     // for iOS
      systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    );

    // Apply globally once per build
    SystemChrome.setSystemUIOverlayStyle(overlayStyle);

    return Scaffold(
      extendBodyBehindAppBar: true,  // to let background under status bar
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Very important: set the AppBar's systemOverlayStyle explicitly:
        systemOverlayStyle: overlayStyle,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        // Optionally use SafeArea so content doesn't go under notch, etc.
        child: Column(
          children: [
            const SizedBox(height: 16),
            _AppSettings(),
          ],
        ),
      ),
    );
  }
}

class _RealStatsSection extends StatelessWidget {
  final DashboardData data;

  const _RealStatsSection({required this.data});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          'Today',
          '${data.todayMinutes} min',
          Icons.today,
          Colors.blue,
        ),
        _buildStatCard(
          'Weekly',
          '${data.weeklyMinutes} min',
          Icons.date_range,
          Colors.green,
        ),
        _buildStatCard(
          'Monthly',
          '${data.monthlyMinutes} min',
          Icons.calendar_month,
          Colors.purple,
        ),
        _buildStatCard(
          'Completion',
          '${data.completionPercentage.toStringAsFixed(1)}%',
          Icons.check_circle,
          Colors.orange,
        ),
        _buildStatCard(
          'Accuracy',
          '${data.accuracyPercentage.toStringAsFixed(1)}%',
          Icons.verified,
          Colors.pink,
        ),
        _buildStatCard(
          'Streak',
          '${data.streak} days',
          Icons.whatshot,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}