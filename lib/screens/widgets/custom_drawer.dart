import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:help_hub/controller/cloudinary_services.dart';
import 'package:help_hub/screens/welcome_screen.dart';
import '../profile.dart';
import 'constant.dart';

class CustomDrawer extends StatefulWidget {
  final String name;
  final String email;
  final String imageUrl;
  final String userId;

  const CustomDrawer({
    Key? key, required this.name, required this.email, required this.imageUrl, required this.userId,

  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late String url = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    url = Cloudinary.getProfileImageUrl(widget.userId);

  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Custom Drawer Header
          Container(
            color: kColor1,
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap:(){
                    Cloudinary.pickAndUploadImage(widget.userId);
                    setState(() {

                    });
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(url),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.email,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Drawer Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(
                  icon: Icons.home,
                  title: 'Home',
                  onTap: () {
                    Navigator.pop(context); // Close drawer
                  },
                ),
                _drawerItem(
                  icon: Icons.person,
                  title: 'Profile',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>Profile()));

                  },
                ),
                _drawerItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _drawerItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () async{
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
                );
                },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: kColor3),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }


}
