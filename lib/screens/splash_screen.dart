import 'package:flutter/material.dart';
import 'dart:async';

import 'package:help_hub/screens/homepage.dart'; // For the timer

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the home screen after 3 seconds
    Timer(Duration(seconds: 3), () {
     // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/splash.png', // Splash screen image
              width: 200,          // Adjust size as needed
              height: 200,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(), // Loading spinner
          ],
        ),
      ),
    );
  }
}
