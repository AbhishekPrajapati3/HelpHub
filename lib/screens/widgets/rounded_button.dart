import 'package:flutter/material.dart';


import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final List<Color> gradientColors;
  final double borderRadius;

  const GradientButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.gradientColors = const [Color(0xFF6C63FF), Color(0xFFFF6584)],
    this.borderRadius = 30.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: InkWell(
        onTap: onPressed,
        splashColor: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: 200.0,
          height: 50.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: gradientColors.last.withOpacity(0.4),
                offset: const Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
