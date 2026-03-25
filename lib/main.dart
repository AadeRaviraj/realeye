import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:realeyes/screens/signin_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/signup_screen.dart'; // Import your login screen
import 'screens/home_screen.dart'; // Import your home screen (or any other screens)
import 'firebase_options.dart'; //  this is initilization of cli ,(using node js) firebase cli
import 'design/theme_provider.dart'; // theme provider
import 'design/language_provider.dart'; // language provider
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:realeyes/generated/app_localizations.dart';
import 'package:realeyes/services/notification_service.dart';




void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  print("Using renderer: ${ui.PlatformDispatcher.instance.implicitView?.renderingBackend}");

  final languageProvider = LanguageProvider();
  await languageProvider.loadLocale();


  try {
    print("Waiting For Initilize The Firebase");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized successfully");
    await NotificationService().initialize();
    runApp(
      // ChangeNotifierProvider(
      //   create: (_) => ThemeProvider(),
      //   child:  const MyApp(),
      // ),
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider<LanguageProvider>.value(value: languageProvider),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

extension on ui.FlutterView? {
  get renderingBackend => null;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context); // theme provider
    final languageProvider = Provider.of<LanguageProvider>(context); // language provider

    print("MyApp: Current locale is ${languageProvider.locale?.languageCode}");
    print("MyApp: MaterialApp rebuilding...");


    return MaterialApp(
     // key: ValueKey(languageProvider.locale?.languageCode),
      title: 'Realeye',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: themeProvider.themeMode, // Follow system theme
      locale: languageProvider.locale, // set teh locate


      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('mr'),
      ],

      home: SplashScreen(), // Set SplashScreen as the initial screen

      // Define your routes here
      routes: {
        '/login': (context) => SignInScreen(), // Define the /login route
        '/home': (context) => HomeScreen(), // Define the /home route (or any other routes)
      },
      // Optional: Handle unknown routes
      onGenerateRoute: (settings) {

        return MaterialPageRoute(
          builder: (context) => SplashScreen(), // Redirect to splash screen or show a 404 page
        );
      },
    );
  }
}