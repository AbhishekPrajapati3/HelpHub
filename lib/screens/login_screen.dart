import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:help_hub/screens/widgets/constant.dart';
import 'package:help_hub/screens/widgets/rounded_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';


  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  get userPassword => password;
  get userEmail => email;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String? email ;
  String? password ;
  bool _isPasswordVisible = false;

  Future<void> _resetPassword() async {
    if (email == null || email!.isEmpty) {
      // Show error if the email is not entered
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter your email to reset password.'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColor4,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(height: 48.0),
              Text(
                "Welcome Back!",
                style: TextStyle(
                  color: kColor1,
                  fontFamily: "Poppins",
                  fontSize: 30.0,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30.0),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.left,
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  hintText: "Enter your email",
                  hintStyle: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14.0,
                    color: Colors.grey.shade500,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200, // Subtle background for the input
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Colors.greenAccent, width: 2.0),
                  ),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.greenAccent,
                  ),
                ),
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 15.0),


              TextField(
                obscureText: !_isPasswordVisible,
                textAlign: TextAlign.left,
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  hintText: "Enter your password",
                  hintStyle: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14.0,
                    color: Colors.grey.shade500,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200, // Subtle background for text input
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    child: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.blueAccent,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.blueAccent,
                  ),
                ),
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),


              const SizedBox(height: 24.0),
              GradientButton(
                //colour: kColor2,
                title: 'Log In',
                onPressed: () async {
                  setState(() {
                    showSpinner = true; // Show spinner while processing
                  });

                  try {
                    if (email == null ||
                        password == null ||
                        email!.isEmpty ||
                        password!.isEmpty) {
                      throw Exception("Email and password cannot be empty");
                    }
                    final userCredential =
                        await _auth.signInWithEmailAndPassword(
                      email: email!,
                      password: password!,
                    );

                    if (userCredential.user != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            userId: userCredential.user!.uid,
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    String errorMessage;
                    if (e is FirebaseAuthException) {
                      errorMessage = e.message ?? 'An unknown error occurred.';
                    } else {
                      errorMessage = e.toString();
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMessage),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  } finally {
                    setState(() {
                      showSpinner = false; // Hide spinner
                    });
                  }
                },
              ),
              const SizedBox(height: 16.0), // Add space between buttons
              Center(
                child: TextButton(
                  onPressed: _resetPassword,
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
