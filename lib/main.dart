import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:realeyes/screens/signin_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/signup_screen.dart'; // Import your login screen
import 'screens/home_screen.dart'; // Import your home screen (or any other screens)
import 'firebase_options.dart'; //  this is initilization of cli ,(using node js) firebase cli



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    print("Waiting For Initilize The Firebase");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
    runApp(MyApp());
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Realeye',
      theme: ThemeData.light(), // Light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: ThemeMode.system, // Follow system theme
      home: SplashScreen(), // Set SplashScreen as the initial screen
      debugShowCheckedModeBanner: false,
      // Define your routes here
      routes: {
        '/login': (context) => SignInScreen(), // Define the /login route
        '/home': (context) => HomeScreen(), // Define the /home route (or any other routes)
      },
      // Optional: Handle unknown routes
      onGenerateRoute: (settings) {
        // You can add logic here to handle unknown routes
        return MaterialPageRoute(
          builder: (context) => SplashScreen(), // Redirect to splash screen or show a 404 page
        );
      },
    );
  }
}