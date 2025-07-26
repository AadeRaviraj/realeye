import 'package:flutter/material.dart';
import 'study_module_screen.dart'; // Import the StudyModuleScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey.shade900,
          elevation: 0,
        ),
      ),
      home: StudyScreen(),
    );
  }
}

class StudyScreen extends StatefulWidget {
  @override
  _StudyScreenState createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  final Map<String, String> programmingLanguages = {
    'Python': 'Versatile language for web, AI, and data analysis.',
    'Java': 'Object-oriented language for enterprise apps.',
    'Dart': 'Optimized for building mobile, desktop, and web apps.',
    'C++': 'High-performance language used in system and game development.',
    'JavaScript': 'Scripting language for dynamic web content.',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Programming Languages',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: programmingLanguages.length,
          itemBuilder: (context, index) {
            String language = programmingLanguages.keys.elementAt(index);
            return GestureDetector(
              onTap: () {
                // Navigate to StudyModuleScreen with the selected language
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudyModuleScreen(language: language),
                  ),
                );
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey.shade900, Colors.grey.shade800],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      language,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      programmingLanguages[language]!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
