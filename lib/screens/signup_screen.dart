import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../design/custom_button.dart';
import '../design/custom_textfield.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _selectedGender;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  void _signUp(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String fullName = _usernameController.text.trim();
    String contact = _mobileController.text.trim();
    String? gender = _selectedGender;

    // Validate all fields
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty ||
        fullName.isEmpty || contact.isEmpty || gender == null) {
      _showSnackBar("️ Please fill all fields");
      return;
    }

    // Validate email format
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      _showSnackBar("️ Please enter a valid email");
      return;
    }

    // Validate mobile number (exactly 10 digits)
    if (contact.length != 10 || !RegExp(r"^[0-9]{10}$").hasMatch(contact)) {
      _showSnackBar("️ Mobile number must be 10 digits");
      return;
    }

    // Validate password match
    if (password != confirmPassword) {
      _showSnackBar("️ Passwords do not match");
      return;
    }

    // Validate password strength
    if (!RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$").hasMatch(password)) {
      _showSnackBar("️ Password must be at least 8 characters, include uppercase, lowercase, numbers, and special characters");
      return;
    }

    try {
      print(" Creating user with email: $email");

      // **Step 1: Create User in Firebase Authentication**
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;
      print(" User Created: $userId");

      // **Step 2: Store User Details in Firebase Realtime Database**
      await _database.child("users").child(userId).set({
        "full_name": fullName,
        "contact": contact,
        "email": email,
        "gender": gender,
        "created_at": DateTime.now().toUtc().toIso8601String(), // Timestamp
      }).then((_) {
        print(" User Data Stored Successfully");
        _showSnackBar(" Signup Successful!");

        Navigator.pushReplacementNamed(context, '/login');
      }).catchError((error) {
        print(" Database Error: $error");
        _showSnackBar(" Failed to store user data: $error");
      });

    } on FirebaseAuthException catch (e) {
      _showSnackBar(" Signup failed: ${e.message}");
      print(" FirebaseAuthException: ${e.message}");
    } catch (e) {
      _showSnackBar(" Error: $e");
      print(" General Error: $e");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    const fieldBorderRadius = 10.0;
    final borderColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create your Account',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            _buildSignupForm(borderColor, textColor, fieldBorderRadius),
            const SizedBox(height: 25),
            ElevatedButton(

              onPressed: () => _signUp(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black  // Dark mode, black background
                    : Colors.white, // Light mode, white background
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(20),
                // ),
                side: BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  width: 1,
                ),
              ),
              child: Text(
               'Sign-up',
                style: TextStyle(
                  color: Colors.purple, // First part in teal
                  //fontWeight: FontWeight.bold,
                  // fontStyle: FontStyle.italic,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,

                ),
              ),
            ),
            // CustomButton(
            //   text: 'Sign Up',
            //   onPressed: () => _signUp(context),
            //   borderColor: borderColor,
            //   backgroundColor: theme.colorScheme.primary,
            //   textColor: textColor,
            //   borderRadius: fieldBorderRadius,
            // ),
            const SizedBox(height: 25),
            _buildSocialLoginSection(theme, borderColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSignupForm(Color borderColor, Color textColor, double fieldBorderRadius) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextField(
              controller: _usernameController,
              hintText: 'Username',
              prefixIcon: Icons.person,
              borderColor: borderColor,
              borderRadius: fieldBorderRadius,
              textColor: textColor,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: _mobileController,
              hintText: 'Mobile Number',
              prefixIcon: Icons.phone,
              borderColor: borderColor,
              borderRadius: fieldBorderRadius,
              textColor: textColor,
              keyboardType: TextInputType.phone, // Use keyboardType
              maxLength: 10, // Restrict to 10 digits
            ),
            const SizedBox(height: 15),
            _buildGenderDropdown(borderColor),
            const SizedBox(height: 15),
            CustomTextField(
              controller: _emailController,
              hintText: 'Email',
              prefixIcon: Icons.email,
              borderColor: borderColor,
              borderRadius: fieldBorderRadius,
              textColor: textColor,
              keyboardType: TextInputType.emailAddress, // Use keyboardType
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: _passwordController,
              hintText: 'Password',
              prefixIcon: Icons.lock,
              obscureText: true,
              borderColor: borderColor,
              borderRadius: fieldBorderRadius,
              textColor: textColor,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: _confirmPasswordController,
              hintText: 'Confirm Password',
              prefixIcon: Icons.lock_reset,
              obscureText: true,
              borderColor: borderColor,
              borderRadius: fieldBorderRadius,
              textColor: textColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderDropdown(Color borderColor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.transgender, color: borderColor),
            hintText: 'Gender',
          ),
          items: ['Male', 'Female', 'Other'].map((gender) => DropdownMenuItem(
            value: gender,
            child: Text(gender),
          )).toList(),
          onChanged: (value) {
            setState(() {
              _selectedGender = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildSocialLoginSection(ThemeData theme, Color borderColor) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: borderColor)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text('Or sign up with', style: theme.textTheme.bodySmall),
            ),
            Expanded(child: Divider(color: borderColor)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialLoginButton('assets/images/google.png', () => print('Google Login')),
            _socialLoginButton('assets/images/facebook.png', () => print('Facebook Login')),
            _socialLoginButton('assets/images/twitter.png', () => print('Twitter Login')),
          ],
        ),
      ],
    );
  }

  Widget _socialLoginButton(String imagePath, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: IconButton(
        icon: Image.asset(imagePath, width: 40, height: 40),
        onPressed: onPressed,
      ),
    );
  }
}