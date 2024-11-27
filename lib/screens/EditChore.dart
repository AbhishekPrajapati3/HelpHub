import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:help_hub/screens/widgets/constant.dart';

import 'choreDetails.dart';



class EditChorePage extends StatefulWidget {
  final String choreId;

  const EditChorePage({Key? key, required this.choreId}) : super(key: key);

  @override
  _EditChorePageState createState() => _EditChorePageState();
}

class _EditChorePageState extends State<EditChorePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? choreName;
  String? contact;
  String? location;
  String? reward;
  String? imageUrl;
  bool isCompleted = false;
  bool isUrgent = false;

  @override
  void initState() {
    super.initState();
    _fetchChoreDetails();
  }

  Future<void> _fetchChoreDetails() async {
    try {
      final docSnapshot = await _firestore.collection('Chores').doc(widget.choreId).get();
      if (docSnapshot.exists) {
        setState(() {
          final data = docSnapshot.data()!;
          choreName = data['choreName'];
          contact = data['contact'];
          location = data['location'];
          reward = data['reward'];
          imageUrl = data['imageUrl'];
          isCompleted = data['isCompleted'] ?? false;
          isUrgent = data['isUrgent'] ?? false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _updateChore() async {
    try {
      await _firestore.collection('Chores').doc(widget.choreId).update({
        'choreName': choreName,
        'contact': contact,
        'location': location,
        'reward': reward,
        'isCompleted': isCompleted,
        'isUrgent': isUrgent,
        'imageUrl': imageUrl,
      });
      // Navigate back to the ChoreDetailsPage after updating
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChoreDetailsPage(choreId: widget.choreId),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Edit Chore",style: kTextPoppins.copyWith(color: Colors.white),),
        backgroundColor: kColor1,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: kTextPoppins,
              decoration: kTextFieldDecoration.copyWith(labelText: 'Chore Name'),
              onChanged: (value) => choreName = value,
              controller: TextEditingController(text: choreName,),
            ),
            const SizedBox(height: 16.0),
            TextField(
              style: kTextPoppins,
              decoration: kTextFieldDecoration.copyWith(labelText: 'Contact'),
              onChanged: (value) => contact = value,
              controller: TextEditingController(text: contact),
            ),
            const SizedBox(height: 16.0),
            TextField(
              style: kTextPoppins,
              decoration: kTextFieldDecoration.copyWith(labelText: 'Location'),
              onChanged: (value) => location = value,
              controller: TextEditingController(text: location),
            ),
            const SizedBox(height: 16.0),
            TextField(
              style: kTextPoppins,
              decoration: kTextFieldDecoration.copyWith(labelText: 'Reward'),
              onChanged: (value) => reward = value,
              controller: TextEditingController(text: reward),
            ),
            const SizedBox(height: 16.0),

            // Toggle for isCompleted
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Is Completed',style: kTextPoppins,),
                Switch(
                  value: isCompleted,
                  onChanged: (value) {
                    setState(() {
                      isCompleted = value;
                    });
                  },
                  activeColor: kColor2,
                ),
              ],
            ),

            // Toggle for isUrgent
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Is Urgent', style: kTextPoppins,),
                Switch(
                  value: isUrgent,
                  onChanged: (value) {
                    setState(() {
                      isUrgent = value;
                    });
                  },
                  activeColor: kColor2,
                ),
              ],
            ),

            const SizedBox(height: 24.0),
            Container(
              width: double.infinity, // Set width to full
              child: ElevatedButton(
                onPressed: _updateChore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kColor2,
                  foregroundColor: kColor4,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text("Update Chore", style: kTextPoppins,),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
