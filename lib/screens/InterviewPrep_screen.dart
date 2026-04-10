import 'package:flutter/material.dart';
import 'package:navaveda/screens/recording_screen.dart';

class InterviewPrepScreen extends StatefulWidget {
  @override
  _InterviewPrepScreenState createState() => _InterviewPrepScreenState();
}

class _InterviewPrepScreenState extends State<InterviewPrepScreen> {
  // State variables to hold user data and UI content
  int practiceStreak = 5; // Number of consecutive practice days
  int userLevel = 3; // User's current level
  double xpProgress = 0.65; // Experience progress as a percentage
  String dailyChallenge = 'Answer 5 technical questions today!';
  String questionOfTheDay = 'What are the four pillars of OOP?';
  String motivationalQuote =
      'Success is not final, failure is not fatal. It is the courage to continue that counts.';
  String weeklyChallenge = 'Complete 3 mock interviews this week!';
  String activeStatus = 'Active for 7 days straight!';

  // To track which card is selected (for expanded view)
  String? selectedCard;

  @override
  Widget build(BuildContext context) {
    //return Scaffold(


      return  SingleChildScrollView(

        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            // Build header section
            SizedBox(height: 20),
            _buildProgressBar(),
            // Build progress bar section
            SizedBox(height: 20),
            _buildIconRow(),
            // Build row of action icons
            if (selectedCard != null) _buildExpandedCard(selectedCard!),
            // Display expanded card when an icon is selected
            SizedBox(height: 20),
            _buildActionCard(),
            // Build AI interview section
            SizedBox(height: 20),
            _buildFeedbackCard(),
            // Build AI feedback section
          ],
        ),
      );
   // );
  }

  // ===========================
  // Header Section
  // ===========================

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal, Colors.purple], // Gradient effect
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(2, 4), // Shadow effect
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lightbulb_outline, color: Colors.white, size: 28), // Icon for more context
          SizedBox(width: 10), // Spacing between icon and text
          Expanded(
            child: Text(
              'Prepare with AI-generated questions and improve your interview skills!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.4, // Line height for better readability
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /* Old Design  of top bar
  // Widget _buildHeader() {
  //   return Container(
  //     padding: EdgeInsets.all(12),
  //     decoration: BoxDecoration(
  //       color: Colors.deepPurple.withOpacity(0.1), // Light purple background
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Text(
  //       'Prepare with AI-generated questions and improve your interview skills!',
  //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //       textAlign: TextAlign.center,
  //     ),
  //   );
  // }

  // ===========================
  // Progress Bar Section
  // ===========================
  */


  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Level $userLevel', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        // Shows progress towards next level
        LinearProgressIndicator(
          value: xpProgress,
          backgroundColor: Colors.grey[300],
          color: Colors.green,
          minHeight: 10,
          borderRadius: BorderRadius.circular(5),
        ),
        SizedBox(height: 4),
        Text('Practice Streak: $practiceStreak days',
            style: TextStyle(fontSize: 12)),
      ],
    );
  }

  // ===========================
  // Icon Row Section
  // ===========================
  Widget _buildIconRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Enable horizontal scrolling
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildIcon(Icons.flash_on, 'Daily', 'daily'),
          SizedBox(width: 12),
          _buildIcon(Icons.question_answer, 'QOTD', 'question'),
          SizedBox(width: 12),
          _buildIcon(Icons.event, 'Weekly', 'weekly'),
          SizedBox(width: 12),
          _buildIcon(Icons.check_circle, 'Active', 'active'),
          SizedBox(width: 12),
          _buildIcon(Icons.bookmark, 'Bookmark', 'bookmark'),
          SizedBox(width: 12),
          _buildIcon(Icons.track_changes, 'Attempts', 'tracker'),
        ],
      ),
    );
  }

  // ===========================
  // Icon Builder
  // ===========================
  Widget _buildIcon(IconData icon, String label, String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Update selected card when icon is tapped
          selectedCard = value;
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.deepPurple.withOpacity(0.2),
            child: Icon(icon, color: Colors.deepPurple, size: 30),
          ),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // ===========================
  // Expanded Card Section
  // ===========================


  Widget _buildExpandedCard(String type) {
    String title = '';
    String content = '';

    // Set title and content based on selected type
    switch (type) {
      case 'daily':
        title = ' Daily Challenge';
        content = dailyChallenge;
        break;
      case 'question':
        title = ' Question of the Day';
        content = questionOfTheDay;
        break;
      case 'weekly':
        title = ' Weekly Challenge';
        content = weeklyChallenge;
        break;
      case 'active':
        title = ' Active Status';
        content = activeStatus;
        break;
      case 'bookmark':
        title = ' Bookmarked Questions';
        content = 'You have 5 bookmarked questions.';
        break;
      case 'tracker':
        title = ' Question Attempts Tracker';
        content = 'Correct: 10, Incorrect: 3';
        break;
    }

    return Column(
      children: [
        SizedBox(height: 20), //  Add space between teh card and hoeizontal bar
        Center(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95, // Increased width
              height: MediaQuery.of(context).size.height * 0.2, // Added height
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // Center content vertically
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), // Slightly bigger font
                  ),
                  SizedBox(height: 24), // Increased spacing
                  Text(
                    content,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16), // Slightly bigger font
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildActionCard() {
    return Center(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.9,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('AI-Powered Interview',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Open the recording screen while keeping the bottom navigation visible
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecordingScreen()),
                  );
                }, //  Screen re cording logic is pending

                icon: Icon(Icons.videocam),
                label: Text('Start Recording'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: () {}, //
                child: Text('View Past Results'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================
  // Feedback Card Section
  // ===========================

  Widget _buildFeedbackCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' AI Feedback Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCircularFeedback('👀 Eye Contact', 0.75, Colors.green),
                _buildCircularFeedback('🗣️ Speech Clarity', 0.80, Colors.blue),
              ],
            ),
            SizedBox(height: 16),
            Text(
              '🔎 Suggested Improvement:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Maintain consistent eye contact and improve speech clarity.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

// Build circular feedback using CircularProgressIndicator
  Widget _buildCircularFeedback(String label, double score, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: score,
                backgroundColor: Colors.grey[300],
                color: color,
                strokeWidth: 6,
              ),
            ),
            Text(
              '${(score * 100).toInt()}%',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}