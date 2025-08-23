import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'signin_screen.dart';
import 'InterviewPrep_screen.dart';
import 'faceDetection_screen.dart';
import 'profile_screen.dart';
import 'study_screen.dart';

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
  String motivationalQuote = 'The future begins with knowledge';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DataSnapshot snapshot = await _database.child("users").child(user.uid).get();
      if (snapshot.exists) {
        setState(() {
          _username = snapshot.child("full_name").value.toString();
        });
      }
    }
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showFaceDetection = false;
    });
  }

  Future<bool> _onWillPop() async {
    if (_showFaceDetection) {
      setState(() {
        _showFaceDetection = false;
        _selectedIndex = 0;
      });
      return false;
    }
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final List<Widget> screens = [
      _buildMainScreen(),
      StudyScreen(),
      InterviewPrepScreen(),
      ProfileScreen(),
    ];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Real',
                  style: TextStyle(
                    color: Colors.orange,
                    fontStyle: FontStyle.italic,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: 'Eye',
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
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

  // ---------------- NEW UI COMPONENTS ----------------

  Widget _buildWelcomeHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 600;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment:
          isWide ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: AssetImage('assets/images/angryp_cricle.png'),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment:
              isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                Text(
                  "Hello, $_username 👋",
                  style: TextStyle(
                    fontSize: isWide ? 28 : 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Ready to prepare for your next interview?",
                  style: TextStyle(fontSize: isWide ? 18 : 14),
                ),
              ],
            ),
          ],
        );
      },
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

  // Widget _buildProgressTracker() {
  //   double progress = 0.4;
  //   return Card(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text("📊 Your Interview Prep: ${(progress * 100).toStringAsFixed(0)}% complete"),
  //           SizedBox(height: 8),
  //           LinearProgressIndicator(
  //             value: progress,
  //             minHeight: 8,
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           SizedBox(height: 4),
  //           Text("Keep going, you're doing great! 💪"),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildQuickActions() {
    List<Map<String, dynamic>> actions = [
      {"icon": Icons.description, "label": "Resume Review"},
      {"icon": Icons.mic, "label": "Mock Interview"},
      {"icon": Icons.menu_book, "label": "Daily Quiz"},
      {"icon": Icons.track_changes, "label": "Goal Tracker"},
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 600;
        return GridView.count(
          shrinkWrap: true,
          crossAxisCount: isWide ? 6 : 2,
          physics: NeverScrollableScrollPhysics(),
          children: actions.map((a) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 25,
                  child: Icon(a['icon'], size: 28),
                ),
                SizedBox(height: 6),
                Text(a['label']),
              ],
            );
          }).toList(),
        );
      },
    );
  }



  Widget _buildMainScreen() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildWelcomeHeader(), // welcoem header widget
          SizedBox(height: 20),
          _buildMotivationalQuote(),
          SizedBox(height: 20,),
         // _buildProgressTracker(), // progress tracker widget
          SizedBox(height: 20),
          _buildQuickActions(), // Quick acation widget
          SizedBox(height: 20),

          SizedBox(height: 20),
          // _buildCard(
          //   icon: Icons.person,
          //   title: 'Interview Preparation',
          //   description: 'Practice your interview skills with AI-generated questions.',
          //   gradientColors: [Colors.purple, Colors.deepPurple],
          //   buttonText: 'Start Practice',
          //   onPressed: () {
          //     setState(() {
          //       _selectedIndex = 2;
          //     });
          //   },
          // ),
          // SizedBox(height: 20),
          // _buildCard(
          //   icon: Icons.face,
          //   title: 'Face Emotion Detection',
          //   description: 'Detect your emotions in real-time using AI.',
          //   gradientColors: [Colors.blue, Colors.indigo],
          //   buttonText: 'Start Detection',
          //   onPressed: () {
          //     setState(() {
          //       _showFaceDetection = true;
          //     });
          //   },
          // ),
          // SizedBox(height: 20),
          // _buildCard(
          //   icon: Icons.book,
          //   title: 'Study',
          //   description: 'Enhance your knowledge with study materials and practice tests.',
          //   gradientColors: [Colors.orange, Colors.red],
          //   buttonText: 'Start Studying',
          //   onPressed: () {
          //     setState(() {
          //       _selectedIndex = 1;
          //     });
          //   },
          // ),

          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                // for web  side by side (Row)
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
                        setState(() {
                          _selectedIndex = 2;
                        });
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
                        setState(() {
                          _showFaceDetection = true;
                        });
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
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                    )),
                  ],
                );
              } else {
                // for mobile screen vertically (Column)
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
                        setState(() {
                          _selectedIndex = 2;
                        });
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
                        setState(() {
                          _showFaceDetection = true;
                        });
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
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                    ),
                  ],
                );
              }
            },
          ),

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
