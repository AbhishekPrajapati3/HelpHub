import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:help_hub/screens/postchore.dart';
import 'package:help_hub/screens/profile.dart';
import 'package:help_hub/screens/widgets/constant.dart';
import 'package:help_hub/screens/widgets/custom_drawer.dart';


import 'choreDetails.dart';
import 'jobs_page.dart';
import 'myChores.dart';

class HomePage extends StatefulWidget {
  static String id = 'home_screen';
  final String userId; // Add userId as a final variable

  // Update the constructor to accept userId
  HomePage({required this.userId}); // Use named parameter

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Index for BottomNavigationBar
  int _humanityPoints = 0; // Variable to store humanity points
  String name = '';
  String email = '';
  List<String> data = [];
  // List of pages for navigation
  final List<Widget> _pages = [
    JobsPage(),
    PostChorePage(),
    MyChoresPage(),
    //Profile(),
  ];

  @override
  void initState(){
    super.initState();
    _fetchHumanityPoints();// Fetch humanity points when the page initializes
     getUserData(widget.userId);
  }

  // Function to fetch humanity points from Firestore
  Future<void> _fetchHumanityPoints() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .get();
      if (userDoc.exists) {
        setState(() {
           name = userDoc['name'];
           email = userDoc['email'];
           print(name);
           print("this is email$email");
          _humanityPoints = userDoc['humanityPoints'] ?? 0; // Fetch points from the document
        });
      }
    } catch (e) {
      print("Error fetching humanity points: $e");
    }
  }

  // This function handles BottomNavigationBar item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColor4, // Background using the provided color scheme
      drawer: CustomDrawer(userId:widget.userId,name: name,email: email,imageUrl: ''),
      appBar: AppBar(
        leading: Builder(
        builder: (context) {
          return IconButton(
            icon: Icon(Icons.menu,color: Colors.white,),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
        title: Text(
          'Help Hub',
          style: TextStyle(color: kColor4, fontWeight: FontWeight.w800, fontFamily: "Poppins"),
        ),



        backgroundColor: kColor1,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Humanity Points Icon with Points Value
                Icon(Icons.star, color: kColor2), // Icon for humanity points
                SizedBox(width: 5),
                Text(
                  '$_humanityPoints', // Display humanity points
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/logowhite.png', height: 40), // Logo on the top right
          ),
        ],
      ),
      body: _pages[_selectedIndex], // Display the selected page here
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: kColor1, // Bottom navigation using primary color (kColor1)
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(0, 5),
              blurRadius: 15,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent, // Transparent background for custom design
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.work, color: _selectedIndex == 0 ? kColor2 : kColor3),
                label: 'Jobs',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add, color: _selectedIndex == 1 ? kColor2 : kColor3),
                label: 'Add',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assignment, color: _selectedIndex == 2 ? kColor2 : kColor3),
                label: 'My Chores',
              ),

            ],
            currentIndex: _selectedIndex,
            selectedItemColor: kColor2,
            unselectedItemColor: kColor3,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: _onItemTapped,
            selectedFontSize: 14,
            unselectedFontSize: 14,
          ),
        ),
      ),
    );
  }
    getUserData(String uid) async{
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    print(doc.data());
    if(doc.exists)
    {
      name = doc['name'];
      email = doc['email'];
    }
    else
    {
     name = 'User';
     email = "user@gmail.com";
    }

  }
}




