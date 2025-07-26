import 'package:flutter/material.dart';
import 'package:realeyes/screens/BasicScreen.dart';  // Import the new Basic Screen

class StudyModuleScreen extends StatelessWidget {
  final String language;

  StudyModuleScreen({required this.language});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$language Study Modules'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Basics'),
              onTap: () {
                // Navigate to Basic Screen with the selected language
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BasicScreen(language: language),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Intermediate'),
              onTap: () {
                // Add logic for Intermediate (later)
              },
            ),
            ListTile(
              title: Text('Advanced'),
              onTap: () {
                // Add logic for Advanced (later)
              },
            ),
          ],
        ),
      ),
    );
  }
}
