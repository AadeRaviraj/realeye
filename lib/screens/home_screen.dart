import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'signin_screen.dart';
import 'InterviewPrep_screen.dart';
import 'faceDetection_screen.dart';
// import 'profile_screen.dart';
import 'package:realeyes/features/profile/screens/profile_screen.dart';
import 'study_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:realeyes/screens/exit_review_handler.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = "User";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  int _selectedIndex = 0;
  bool _showFaceDetection = false;
  String? _profileImageUrl;

  String motivationalQuote = 'The future begins with knowledge';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // This function runs once when the widget is created.
    // We use it to initialize data or start tasks, like fetching user data.
    super.initState();
   // _loadCachedUser();
    _fetchUserData(); // fetch the user data
    _loadUserProfileImage(); // fetch the user image
  }


  @override
  void dispose() {
    // This function runs when the widget is removed from the screen.
    // We use it to clean up resources like controllers to avoid memory leaks.
    _scrollController.dispose();
    super.dispose();
  }

//fetch teh user image from firebase , current reference id
  void _loadUserProfileImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(user.uid)
        .get();

    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      if (mounted) {
        setState(() {
          _profileImageUrl = data['profile_image'];
        });
      }
    }
  }


// fetch the  user name
  void _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DataSnapshot snapshot = await _database.child("users").child(user.uid).get();
      if (snapshot.exists) {
        String name = snapshot
            .child("full_name")
            .value
            .toString();

        // Save locally
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', name);
        if (mounted) {
          setState(() {
            _username = name;
          });
        }
      }
    }
  }

  // void _loadCachedUser() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? name = prefs.getString('username');
  //   if (name != null) {
  //     setState(() {
  //       _username = name;
  //     });
  //   }
  // }







  void _logout() async {
    // function is not used anywhere in this screen but future thinking uses
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

  // function is used for changing teh screen inside teh scafffold using index value
  void _onItemTapped(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
        _showFaceDetection = false;
      });
    }
  }

  // used future  class for implement the database(firebase fetch) handle
  Future<bool> _onWillPop() async {
    if (_showFaceDetection) {
      if (mounted) {
        setState(() {
          _showFaceDetection = false;
          _selectedIndex = 0;
        });
        return false;
      }
    }
    // if you try to logout then it will by wait the screen
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    ) ??
        false;
  }

  //main ui build here by using build calss
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final List<Widget> screens = [
      _buildMainScreen(),
      StudyScreen(  ),
      InterviewPrepScreen(),
      ProfileScreen(),
    ];


    return ExitReviewHandler(
      // child :
      // onWillPop: _onWillPop,
      child: Scaffold(
        // Add conditional AppBar for non-home screens
        appBar: _selectedIndex != 0
            ? AppBar(
          title: RichText(
            text: TextSpan(
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
          centerTitle: false,
        )
            : null,
        body: _showFaceDetection
            ? FaceDetectionScreen(
          onBackToHome: () {
            setState(() {
              _showFaceDetection = false;
              _selectedIndex = 0;
            });
          },
        )
            : screens[_selectedIndex],
        bottomNavigationBar: _buildBottomNavigationBar(isDarkMode),
      ),
    );


  }

  //Entry point of all widgets
  Widget _buildMainScreen() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        _buildCustomSliverAppBar(),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildMotivationalQuote(),
                SizedBox(height: 20),
                _buildProgressTracker(),
                SizedBox(height: 20),
                _buildDailyQuiz(),
                SizedBox(height: 20),
                _buildLearningStreak(),
                SizedBox(height: 20),
                _buildQuickActions(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),

        //Silver Box adapter , for create teh web and mobile base ui design ...
        //design the Card here
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildCard(
                        icon: Icons.person,
                        title: 'Interview Preparation',
                        description: 'Practice your interview skills with AI-generated questions.',
                        gradientColors: [Colors.purple, Colors.deepPurple],
                        buttonText: 'Start Practice',
                        onPressed: () {
                          setState(() { _selectedIndex = 2; });
                        },
                      )),
                      SizedBox(width: 16),
                      Expanded(child: _buildCard(
                        icon: Icons.face,
                        title: 'Face Emotion Detection',
                        description: 'Detect your emotions in real-time using AI.',
                        gradientColors: [Colors.blue, Colors.indigo],
                        buttonText: 'Start Detection',
                        onPressed: () {
                          setState(() { _showFaceDetection = true; });
                        },
                      )),
                      SizedBox(width: 16),
                      Expanded(child: _buildCard(
                        icon: Icons.book,
                        title: 'Study',
                        description: 'Enhance your knowledge with study materials and practice tests.',
                        gradientColors: [Colors.orange, Colors.red],
                        buttonText: 'Start Studying',
                        onPressed: () {
                          setState(() { _selectedIndex = 1; });
                        },
                      )),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildCard(
                        icon: Icons.person,
                        title: 'Interview Preparation',
                        description: 'Practice your interview skills with AI-generated questions.',
                        gradientColors: [Colors.purple, Colors.deepPurple],
                        buttonText: 'Start Practice',
                        onPressed: () {
                          setState(() { _selectedIndex = 2; });
                        },
                      ),
                      SizedBox(height: 20),
                      _buildCard(
                        icon: Icons.face,
                        title: 'Face Emotion Detection',
                        description: 'Detect your emotions in real-time using AI.',
                        gradientColors: [Colors.blue, Colors.indigo],
                        buttonText: 'Start Detection',
                        onPressed: () {
                          setState(() { _showFaceDetection = true; });
                        },
                      ),
                      SizedBox(height: 20),
                      _buildCard(
                        icon: Icons.book,
                        title: 'Study',
                        description: 'Enhance your knowledge with study materials and practice tests.',
                        gradientColors: [Colors.orange, Colors.red],
                        buttonText: 'Start Studying',
                        onPressed: () {
                          setState(() { _selectedIndex = 1; });
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  Widget _buildBottomNavigationBar(bool isDarkMode) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0, -3),
            blurRadius: 6,
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: isDarkMode ? Colors.blueAccent : Colors.orangeAccent,
        unselectedItemColor: isDarkMode ? Colors.white70 : Colors.black54,
        elevation: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Study'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Interview Prep'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
      ),
    );
  }


  Widget _buildMotivationalQuote() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.format_quote, color: Colors.green),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '"$motivationalQuote"',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildQuickActions() {
    final List<Map<String, dynamic>> actions = [
      {
        "icon": Icons.description,
        "label": "Resume Review",
        "color": const Color(0xFF2DD4BF) // Teal
      },
      {
        "icon": Icons.mic,
        "label": "Mock Interview",
        "color": const Color(0xFF8B5CF6) // Violet
      },
      {
        "icon": Icons.menu_book,
        "label": "Daily Quiz",
        "color": const Color(0xFF4F46E5) // Indigo
      },
      {
        "icon": Icons.track_changes,
        "label": "Goal Tracker",
        "color": const Color(0xFFFB7185) // Pink
      },
      {
        "icon": Icons.psychology,
        "label": "AI Coach",
        "color": const Color(0xFF10B981) // Emerald
      },
      {
        "icon": Icons.music_note,
        "label": "Mood Music",
        "color": const Color(0xFFF43F5E) // Rose
      },
      {
        "icon": Icons.school,
        "label": "Study Hub",
        "color": const Color(0xFF6366F1) // Indigo lighter
      },
      {
        "icon": Icons.people,
        "label": "Community",
        "color": const Color(0xFFF97316) // Orange
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final a = actions[index];
        return _ActionCard(
          icon: a['icon'],
          label: a['label'],
          color: a['color'],
          onTap: () {
            // TODO: Add navigation later
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${a['label']} clicked"),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        );
      },
    );
  }




//Silver App bar to implement teh userprofile screen
  SliverAppBar _buildCustomSliverAppBar() {

    ImageProvider profileImageProvider = _profileImageUrl != null
        ? NetworkImage(_profileImageUrl!)
        : const AssetImage('assets/images/angryp_cricle.png');


    return SliverAppBar(
      expandedHeight: 200.0,
      pinned: true,
      floating: false,
      snap: false,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,


      //action button to navigate to the profile screen
      actions: [
        SizedBox(
          width: 60,  // a little bigger than the image size
          height: 60,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 12.0),
            child: GestureDetector(
              //this is open the full screen or show teh full screen in inside teh scaffold widget
              onTap: () {
              //   Navigator.of(context).push(// it opens teh new screens
              //     MaterialPageRoute(builder: (context) => ProfileScreen()),
              //   );
                setState(() {
                    // it open the screen inside the scafffold widget
                    _selectedIndex = 3; // Switch to Profile tab
                  });
  },
            child: _CollapsingProfileImage(
              scrollController: _scrollController,
//              image: AssetImage('assets/images/angryp_cricle.png'),
              image:profileImageProvider , // set the image  when icon is small then

              size: 48,  // bigger image size here
              visibilityTrigger: 0.5,
            ),
          ),
        ),
        ),
      ],

      leading: SizedBox(),

      //  FlexibleSpaceBar with top-left title
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 16.0, bottom: 16.0), // aligns bottom-left when collapsed
        title: _CollapsingTitleBuilder(
          scrollController: _scrollController,
          child: RichText(
            text: TextSpan(
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
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade700,
                Colors.purple.shade700,
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // CircleAvatar(
                //   radius: 40,
                //   backgroundImage: AssetImage('assets/images/angryp_cricle.png'),
                // ),
                CircleAvatar(
                  radius: 48,
                  backgroundImage: _profileImageUrl != null
                      ? NetworkImage(_profileImageUrl!)
                      : const AssetImage('assets/images/angryp_cricle.png') as ImageProvider,
                ),

                SizedBox(height: 10),
                Text(
                  "Hello, $_username....!",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressTracker() {
    double progress = 0.6;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(" Interview Prep Progress"),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
            SizedBox(height: 6),
            Text("${(progress * 100).toStringAsFixed(0)}% complete - Keep going "),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyQuiz() {
    return Card(
      color: Colors.orange.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(Icons.quiz, color: Colors.orange, size: 32),
        title: Text("Daily 5-min Quiz"),
        subtitle: Text("Sharpen your skills with today's challenge"),
        trailing: ElevatedButton(
          onPressed: () {
            debugPrint("Go to quiz");
          },
          child: Text("Start"),
        ),
      ),
    );
  }

  Widget _buildLearningStreak() {
    int streak = 5;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green, Colors.teal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(" Learning Streak", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text("You've practiced $streak days in a row!", style: TextStyle(color: Colors.white70)),
            ],
          ),
          Icon(Icons.local_fire_department, color: Colors.white, size: 36),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String description,
    required List<Color> gradientColors,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 50, color: Colors.white),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                description,
                style: TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                    width: 2,
                  ),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(color: gradientColors.last, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

//Collapsing App bar  code and classes implemented here  without created new file
class _CollapsingProfileImage extends StatefulWidget {
  final ScrollController scrollController;
  final ImageProvider image;
  final double size;
  final double visibilityTrigger;

  const _CollapsingProfileImage({
    Key? key,
    required this.scrollController,
    required this.image,
    this.size = 36,
    this.visibilityTrigger = 0.5,
  }) : super(key: key);

  @override
  __CollapsingProfileImageState createState() => __CollapsingProfileImageState();
}

class __CollapsingProfileImageState extends State<_CollapsingProfileImage> {
  late double _opacity;

  @override
  void initState() {
    super.initState();
    _opacity = 0.0;
    widget.scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_handleScroll);
    super.dispose();
  }

  void _handleScroll() {
    final scrollOffset = widget.scrollController.offset;
    final expandedHeight = 200.0;
    final collapsedHeight = kToolbarHeight;
    final scrollRange = expandedHeight - collapsedHeight;

    double newOpacity = (scrollOffset / scrollRange - widget.visibilityTrigger) /
        (1 - widget.visibilityTrigger);
    newOpacity = newOpacity.clamp(0.0, 1.0);

    if (newOpacity != _opacity) {
      setState(() {
        _opacity = newOpacity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacity,
      child: Container(
        margin: EdgeInsets.all(8),
        child: CircleAvatar(
          radius: widget.size,
          backgroundImage: widget.image,
        ),
      ),
    );
  }
}

class _CollapsingTitleBuilder extends StatefulWidget {
  final ScrollController scrollController;
  final Widget child;

  const _CollapsingTitleBuilder({
    Key? key,
    required this.scrollController,
    required this.child,
  }) : super(key: key);

  @override
  __CollapsingTitleBuilderState createState() => __CollapsingTitleBuilderState();
}

class __CollapsingTitleBuilderState extends State<_CollapsingTitleBuilder> {
  late double _opacity;

  @override
  void initState() {
    super.initState();
    _opacity = 0.0;
    widget.scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_handleScroll);
    super.dispose();
  }

  void _handleScroll() {
    final scrollOffset = widget.scrollController.offset;
    final expandedHeight = 200.0;
    final collapsedHeight = kToolbarHeight;
    final scrollRange = expandedHeight - collapsedHeight;

    double newOpacity = (scrollOffset / scrollRange - 0.3) / 0.7;
    newOpacity = newOpacity.clamp(0.0, 1.0);

    if (newOpacity != _opacity) {
      setState(() {
        _opacity = newOpacity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacity,
      child: widget.child,
    );
  }
}





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
  __ActionCardState createState() => __ActionCardState();
}

class __ActionCardState extends State<_ActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = isDark ? Colors.grey[850]! : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.grey[800]!;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: isDark ? Border.all(color: Colors.white, width: 1) : Border.all(color: Colors.black38, width: 1),
            boxShadow: isDark
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ]
                : [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background gradient circle
              Positioned(
                top: -20,
                right: -20,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          widget.color.withOpacity(isDark ? 0.3 : 0.2),
                          widget.color.withOpacity(isDark ? 0.1 : 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Icon with subtle background
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(isDark ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.icon,
                        size: 24,
                        color: widget.color,
                      ),
                    ),

                    // Label text
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
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

/*

different design for build quick cards
  // Widget _buildQuickActions() {
  //   List<Map<String, dynamic>> actions = [
  //     {"icon": Icons.description, "label": "Resume Review"},
  //     {"icon": Icons.mic, "label": "Mock Interview"},
  //     {"icon": Icons.menu_book, "label": "Daily Quiz"},
  //     {"icon": Icons.track_changes, "label": "Goal Tracker"},
  //   ];
  //   return LayoutBuilder(
  //     builder: (context, constraints) {
  //       bool isWide = constraints.maxWidth > 600;
  //       return GridView.count(
  //         shrinkWrap: true,
  //         crossAxisCount: isWide ? 6 : 2,
  //         physics: NeverScrollableScrollPhysics(),
  //         children: actions.map((a) {
  //           return Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               CircleAvatar(
  //                 radius: 25,
  //                 child: Icon(a['icon'], size: 28),
  //               ),
  //               SizedBox(height: 6),
  //               Text(a['label']),
  //             ],
  //           );
  //         }).toList(),
  //       );
  //     },
  //   );
  // }


  // Widget _buildQuickActions() {
  //   // List of important actions shown to user
  //   // We can easily add/remove items here in future
  //   final List<Map<String, dynamic>> actions = [
  //     {"icon": Icons.description, "label": "Resume Review"},
  //     {"icon": Icons.mic, "label": "Mock Interview"},
  //     {"icon": Icons.menu_book, "label": "Daily Quiz"},
  //     {"icon": Icons.track_changes, "label": "Goal Tracker"},
  //     {"icon": Icons.psychology, "label": "AI Coach"}, // future feature
  //     {"icon": Icons.music_note, "label": "Mood Music"}, // future feature
  //     {"icon": Icons.school, "label": "Study Hub"}, // future feature
  //     {"icon": Icons.people, "label": "Community"}, // future feature
  //   ];
  //
  //   return LayoutBuilder(
  //     builder: (context, constraints) {
  //       bool isWide = constraints.maxWidth > 600;
  //
  //       return GridView.count(
  //         shrinkWrap: true,
  //         crossAxisCount: isWide ? 4 : 2, // responsive columns
  //         mainAxisSpacing: 16,
  //         crossAxisSpacing: 16,
  //         physics: const NeverScrollableScrollPhysics(),
  //         children: actions.map((a) {
  //           return GestureDetector(
  //             onTap: () {
  //               // TODO: Replace with real navigation later
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 SnackBar(content: Text("${a['label']} clicked")),
  //               );
  //             },
  //             child: Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(20),
  //                 gradient: LinearGradient(
  //                   colors: [Colors.blue.shade400, Colors.blue.shade700],
  //                   begin: Alignment.topLeft,
  //                   end: Alignment.bottomRight,
  //                 ),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.black26,
  //                     blurRadius: 8,
  //                     offset: const Offset(2, 4),
  //                   ),
  //                 ],
  //               ),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   CircleAvatar(
  //                     radius: 28,
  //                     backgroundColor: Colors.white.withOpacity(0.2),
  //                     child: Icon(
  //                       a['icon'],
  //                       size: 30,
  //                       color: Colors.white,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 10),
  //                   Text(
  //                     a['label'],
  //                     textAlign: TextAlign.center,
  //                     style: const TextStyle(
  //                       color: Colors.white,
  //                       fontWeight: FontWeight.w600,
  //                       fontSize: 14,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         }).toList(),
  //       );
  //     },
  //   );
  // }

//colorful carda
//   Widget _buildQuickActions() {
//     // Each action has its own professional color
//     final List<Map<String, dynamic>> actions = [
//       {
//         "icon": Icons.description,
//         "label": "Resume Review",
//         "color": [Colors.teal, Colors.tealAccent]
//       },
//       {
//         "icon": Icons.mic,
//         "label": "Mock Interview",
//         "color": [Colors.deepPurple, Colors.purpleAccent]
//       },
//       {
//         "icon": Icons.menu_book,
//         "label": "Daily Quiz",
//         "color": [Colors.indigo, Colors.blueAccent]
//       },
//       {
//         "icon": Icons.track_changes,
//         "label": "Goal Tracker",
//         "color": [Colors.orange, Colors.deepOrangeAccent]
//       },
//       {
//         "icon": Icons.psychology,
//         "label": "AI Coach",
//         "color": [Colors.green, Colors.lightGreenAccent]
//       },
//       {
//         "icon": Icons.music_note,
//         "label": "Mood Music",
//         "color": [Colors.pink, Colors.pinkAccent]
//       },
//       {
//         "icon": Icons.school,
//         "label": "Study Hub",
//         "color": [Colors.blueGrey, Colors.grey]
//       },
//       {
//         "icon": Icons.people,
//         "label": "Community",
//         "color": [Colors.red, Colors.redAccent]
//       },
//     ];
//
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         bool isWide = constraints.maxWidth > 600;
//
//         return GridView.count(
//           shrinkWrap: true,
//           crossAxisCount: isWide ? 4 : 2, // Responsive columns
//           mainAxisSpacing: 16,
//           crossAxisSpacing: 16,
//           physics: const NeverScrollableScrollPhysics(),
//           children: actions.map((a) {
//             return GestureDetector(
//               onTap: () {
//                 // TODO: Replace with real navigation
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text("${a['label']} clicked")),
//                 );
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   gradient: LinearGradient(
//                     colors: a['color'], // Different color for each card
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 6,
//                       offset: const Offset(2, 3),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircleAvatar(
//                       radius: 26,
//                       backgroundColor: Colors.white.withOpacity(0.2),
//                       child: Icon(
//                         a['icon'],
//                         size: 28,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       a['label'],
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }

//only black and white
//   Widget _buildQuickActions() {
//     // Defining quick action items
//     final List<Map<String, dynamic>> actions = [
//       {"icon": Icons.description, "label": "Resume Review"},
//       {"icon": Icons.mic, "label": "Mock Interview"},
//       {"icon": Icons.menu_book, "label": "Daily Quiz"},
//       {"icon": Icons.track_changes, "label": "Goal Tracker"},
//       {"icon": Icons.psychology, "label": "AI Coach"}, // future
//       {"icon": Icons.music_note, "label": "Mood Music"}, // future
//       {"icon": Icons.school, "label": "Study Hub"}, // future
//       {"icon": Icons.people, "label": "Community"}, // future
//     ];
//
//     return ListView.separated(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: actions.length,
//       separatorBuilder: (_, __) => const SizedBox(height: 12),
//       itemBuilder: (context, index) {
//         final a = actions[index];
//         return GestureDetector(
//           onTap: () {
//             // TODO: Add navigation
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text("${a['label']} clicked")),
//             );
//           },
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white, // clean background
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 8,
//                   offset: const Offset(2, 4),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 // Icon container with black circular background
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: Colors.black,
//                   ),
//                   child: Icon(
//                     a['icon'],
//                     size: 28,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 // Text Section
//                 Expanded(
//                   child: Text(
//                     a['label'],
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 // Small forward arrow → feels like "next screen"
//                 const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black54),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

  //
  // Widget _buildQuickActions() {
  //   // List of actions with their custom colors
  //   final List<Map<String, dynamic>> actions = [
  //     {
  //       "icon": Icons.description,
  //       "label": "Resume Review",
  //       "color": Colors.teal
  //     },
  //     {
  //       "icon": Icons.mic,
  //       "label": "Mock Interview",
  //       "color": Colors.deepPurple
  //     },
  //     {
  //       "icon": Icons.menu_book,
  //       "label": "Daily Quiz",
  //       "color": Colors.indigo
  //     },
  //     {
  //       "icon": Icons.track_changes,
  //       "label": "Goal Tracker",
  //       "color": Colors.orange
  //     },
  //     {
  //       "icon": Icons.psychology,
  //       "label": "AI Coach",
  //       "color": Colors.green
  //     },
  //     {
  //       "icon": Icons.music_note,
  //       "label": "Mood Music",
  //       "color": Colors.pink
  //     },
  //     {
  //       "icon": Icons.school,
  //       "label": "Study Hub",
  //       "color": Colors.blueGrey
  //     },
  //     {
  //       "icon": Icons.people,
  //       "label": "Community",
  //       "color": Colors.red
  //     },
  //   ];
  //
  //   return ListView.separated(
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     itemCount: actions.length,
  //     separatorBuilder: (_, __) => const SizedBox(height: 14),
  //     itemBuilder: (context, index) {
  //       final a = actions[index];
  //       return GestureDetector(
  //         onTap: () {
  //           // TODO: Add navigation later
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text("${a['label']} clicked")),
  //           );
  //         },
  //         child: Container(
  //           padding: const EdgeInsets.all(16),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(18),
  //             gradient: LinearGradient(
  //               colors: [
  //                 (a['color'] as Color).withOpacity(0.8),
  //                 (a['color'] as Color).withOpacity(0.5),
  //               ],
  //               begin: Alignment.topLeft,
  //               end: Alignment.bottomRight,
  //             ),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: (a['color'] as Color).withOpacity(0.3),
  //                 blurRadius: 10,
  //                 offset: const Offset(2, 6),
  //               ),
  //             ],
  //           ),
  //           child: Row(
  //             children: [
  //               // Icon with background glow
  //               Container(
  //                 padding: const EdgeInsets.all(14),
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   color: Colors.white.withOpacity(0.25),
  //                 ),
  //                 child: Icon(
  //                   a['icon'],
  //                   size: 28,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //               const SizedBox(width: 16),
  //               // Title text
  //               Expanded(
  //                 child: Text(
  //                   a['label'],
  //                   style: const TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w700,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //               // Subtle action arrow
  //               const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white70),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  //

 */