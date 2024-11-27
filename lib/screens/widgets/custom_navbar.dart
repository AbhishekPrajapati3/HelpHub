import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart'; // Add glassmorphism package or mimic effect
import 'package:flutter_animate/flutter_animate.dart';

import 'constant.dart'; // Optional for animations

class CustomBottomNavBar extends StatefulWidget {
  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: GlassContainer(
        height: 70,
        blur: 20,
        borderRadius: BorderRadius.circular(30),
        shadowColor: Colors.black26,
        shadowStrength: 4,
        opacity: 0.15,
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 0.5),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent, // Glassmorphism effect
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            _buildBarItem(Icons.work, "Jobs", 0),
            _buildBarItem(Icons.add, "Add", 1),
            _buildBarItem(Icons.assignment, "My Chores", 2),
            _buildBarItem(Icons.person, "Profile", 3),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBarItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Animate(
        effects: index == _selectedIndex
            ? [
          ScaleEffect(
            begin: Offset(0,0),
            end:Offset(50, 50),
            duration: Duration(milliseconds: 200),
          )
        ]
            : null, // If no animation, use null
        child: Icon(
          icon,
          size: index == _selectedIndex ? 28 : 24, // Size changes based on selection
          color: index == _selectedIndex ? kColor2 : kColor3, // Change color based on selection
        ),
      ),

      label: label,
    );
  }
}
