import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signin_screen.dart';
import 'home_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    //check teh function to  user is current present or not
    _checkUserLoginStatus();

    // Fade animation init
    _controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward(); // Start fade animation
    _checkUserLoginStatus(); // Continue with login check

  }

  void _checkUserLoginStatus() async {
    // Wait for 20 seconds  splash screen duration
    await Future.delayed(Duration(seconds: 20));

    // Check if the user is already logged in
    User? user = _auth.currentUser;

    if (user != null) {
      // User is logged in, navigate to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // User is not logged in, navigate to SignInScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Cleanup
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A9CFA),
      body: Stack(
        children: [
          Align(
            alignment: Alignment(0, -0.6),
            // to arrange teh image  position in the screen
            child:
            Image.asset(
              'assets/images/eye.png',
              width: 100,
              height: 100,
            ),
          ),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const SizedBox(height: 20),

                // Fixed-height wrapper for rotating text
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    const SizedBox(width: 12.0),
                    // Fix jumping by wrapping in SizedBox
                    SizedBox(
                      height: 50, // Fixed height to prevent jumping
                      child: DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 40.0,
                          fontFamily: 'Horizon',
                          color: Colors.white,
                          fontWeight: FontWeight.bold, // to bold teh text
                        ),
                        child: AnimatedTextKit(
                          pause: Duration(seconds: 2),
                          animatedTexts: [
                            RotateAnimatedText('RealEyes'
                              // textStyle: TextStyle(
                              //   fontSize: 28,
                              //   fontWeight: FontWeight.bold,
                              //   color: Colors.white,
                              // ),
                            ),
                            RotateAnimatedText('Realize'),
                            RotateAnimatedText('Real-Lies'),

                            // FadeAnimatedText('do IT!'),
                            // FadeAnimatedText('do it RIGHT!!'),
                            // FadeAnimatedText('do it RIGHT NOW!!!'),

                            TypewriterAnimatedText(
                              'From Preparation to Perfection..',
                              textStyle: TextStyle(
                                fontSize: 22, //
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Raleway', // optional
                                color: Colors.white, // match your theme
                              ),
                              speed: Duration(milliseconds: 90),
                            ),

                            // TyperAnimatedText('- W.Edwards Deming'),


                            // ScaleAnimatedText('Think'),
                            // ScaleAnimatedText('Build'),

                            // WavyAnimatedText('Hello World'),

                          ],
                          // Set duration for each RotateAnimatedText (applies globally)
                          totalRepeatCount: 3,
                          repeatForever: false,
                          onTap: () {
                            print("Tap Event");
                          },
                          isRepeatingAnimation: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bottom Loading Indicator
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


