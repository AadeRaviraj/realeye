import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../design/custom_button.dart';
import '../design/custom_textfield.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false; // Password visibility state
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  void initState() {// in this function we set the default values in the textfield
    super.initState();
    // Set the default values for email and password fields
    // _emailController.text = 'raviraj@gmail.com';
    // _passwordController.text = 'Avita@1234';
  }

  void _signIn(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Validation
    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("️ Please fill all fields");
      return;
    }

    if (!_isValidEmail(email)) {
      _showSnackBar("️ Please enter a valid email");
      return;
    }

    try {
      print(" Attempting to sign in with email: $email");

      // Sign in with Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print(" User Signed In: ${userCredential.user!.uid}");

      // Navigate to Home Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showSnackBar(" No user found for this email");
      } else if (e.code == 'wrong-password') {
        _showSnackBar(" Incorrect password");
      } else {
        _showSnackBar(" Sign-in failed: ${e.message}");
      }
      print(" FirebaseAuthException: ${e.message}");
    } catch (e) {
      _showSnackBar(" Error: $e");//Show the Error
      print(" General Error: $e");
    }
  }

  // Email Validation
  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final borderColor = isDarkMode
        ? Colors.white.withOpacity(0.7)
        : colorScheme.onSurface.withOpacity(0.5);

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Login to your Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onBackground,
                        ),
                      ),
                      SizedBox(height: 20),
                      // Image.asset(
                      //   'assets/images/eyeblink.gif',
                      //   width: 100,
                      //   height: 100,
                      // ),
                      SvgPicture.asset(
                        'assets/images/navaveda_splash_screen.svg',
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(height: 20),
                      Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: borderColor),
                        ),
                        color: colorScheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: _emailController,
                                hintText: 'Email',
                                prefixIcon: Icons.email,
                                borderColor: borderColor,
                                textColor: isDarkMode ? Colors.white : Colors.black,
                                borderRadius: 10.0,
                              ),
                              SizedBox(height: 20),
                              CustomTextField(
                                controller: _passwordController,
                                hintText: 'Password',
                                prefixIcon: Icons.lock,
                                suffixIcon: _isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                obscureText: !_isPasswordVisible,
                                borderColor: borderColor,
                                textColor: isDarkMode ? Colors.white : Colors.black,
                                borderRadius: 10.0,
                                onSuffixIconPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: _showForgotPasswordDialog,

                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              CustomButton(
                                text: 'Sign in',
                                onPressed: () => _signIn(context),
                                gradient: isDarkMode
                                    ? null
                                    : LinearGradient(
                                  colors: [colorScheme.primary, colorScheme.secondary],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                backgroundColor: isDarkMode ? Colors.black : colorScheme.primary,
                                borderColor: borderColor,
                                borderRadius: 10.0,
                                elevation: 5.0,
                                isOutlined: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          // Expanded(child: Divider(color: borderColor)),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 10),
                          //   child: Text('Or sign in with', style: theme.textTheme.bodySmall),
                          // ),
                          // Expanded(child: Divider(color: borderColor)),
                        ],
                      ),
                      // SizedBox(height: 20),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     // IconButton(
                      //     //   icon: Image.asset('assets/images/google.png', width: 40, height: 40),
                      //     //   onPressed: () => print('Sign in with Google'),
                      //     // ),
                      //     // SizedBox(width: 20),
                      //     // IconButton(
                      //     //   icon: Image.asset('assets/images/facebook.png', width: 40, height: 40),
                      //     //   onPressed: () => print('Sign in with Facebook'),
                      //     // ),
                      //     // SizedBox(width: 20),
                      //     // IconButton(
                      //     //   icon: Image.asset('assets/images/twitter.png', width: 40, height: 40),
                      //     //   onPressed: () => print('Sign in with Twitter'),
                      //     // ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                child: Text.rich(
                  TextSpan(
                    text: 'Don’t have an account? ',
                    style: TextStyle(),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _forgotPassword() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      _showSnackBar("Please enter your email first");
      return;
    }

    if (!_isValidEmail(email)) {
      _showSnackBar("Enter a valid email");
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);

      _showSnackBar("Password reset link sent to your email 📩");
    } on FirebaseAuthException catch (e) {
      _showSnackBar("Error: ${e.message}");
    } catch (e) {
      _showSnackBar("Something went wrong");
    }
  }

  void _showForgotPasswordDialog() {
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Reset Password"),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(hintText: "Enter your email"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String email = emailController.text.trim();

                if (email.isEmpty) {
                  _showSnackBar("Enter email");
                  return;
                }

                try {
                  await _auth.sendPasswordResetEmail(email: email);
                  Navigator.pop(context);
                  _showSnackBar("Reset link sent 📩");
                } catch (e) {
                  _showSnackBar("Error: $e");
                }
              },
              child: Text("Send"),
            ),
          ],
        );
      },
    );
  }

}