import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:help_hub/screens/homepage.dart';
import 'package:help_hub/screens/login_screen.dart';
import 'package:help_hub/screens/registration_screen.dart';
import 'package:help_hub/screens/widgets/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  bool showAnimatedText = true;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purpleAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Hero(
                    tag: 'logo',
                    child: SizedBox(
                      height: 100.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                  Expanded(
                    child: showAnimatedText
                        ? AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Help Hub',
                          textStyle: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          speed: const Duration(milliseconds: 150),
                        ),
                      ],
                      isRepeatingAnimation: false,
                      onFinished: () {
                        setState(() {
                          showAnimatedText = false; // Stop animation
                        });
                      },
                    )
                        : const Text(
                      'Help Hub',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Where helping hands earn!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 50.0),
              GradientButton(
                title: 'Log In',
                gradientColors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                onPressed: () {
                  Navigator.pushReplacementNamed(context, LoginScreen.id);
                },
              ),
              GradientButton(
                title: 'Register',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, RegistrationScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
