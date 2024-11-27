
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_hub/screens/welcome_screen.dart';

import '../screens/homepage.dart';
import '../screens/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Listen for auth state changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Show a loader while waiting
        }

        if (snapshot.hasData) {
          print(snapshot.data.toString());
          // User is signed in
          return HomePage(userId: snapshot.data!.uid);
        } else {
          // User is not signed in
          return WelcomeScreen();
        }
      },
    );
  }
}
