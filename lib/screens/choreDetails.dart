import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart';
import 'package:help_hub/screens/widgets/constant.dart';
import 'package:intl/intl.dart';

import 'EditChore.dart';

class ChoreDetailsPage extends StatefulWidget {
  final String choreId;

  const ChoreDetailsPage({Key? key, required this.choreId}) : super(key: key);

  @override
  _ChoreDetailsPageState createState() => _ChoreDetailsPageState();
}

class _ChoreDetailsPageState extends State<ChoreDetailsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? choreDetails;
  bool isInterested = false;

  @override
  void initState() {
    super.initState();
    _fetchChoreDetails();
  }

  Future<void> _fetchChoreDetails() async {
    try {
      final docSnapshot =
          await _firestore.collection('Chores').doc(widget.choreId).get();
      if (docSnapshot.exists) {
        setState(() {
          choreDetails = docSnapshot.data();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _toggleInterest() async {
    final user = _auth.currentUser;
    if (user == null){
      print("user is not fond , during tap on interest");
      return;}

    try {
      final userDocRef = _firestore.collection('Users').doc(user.uid);
      final userDoc = await userDocRef.get();

      if (userDoc.exists) {
        print("user doc extists at interested");
        final int currentHumanityPoints =
            userDoc.data()?['humanityPoints'] ?? 0;
        final String? idProofUrl =
            userDoc.data()?['idProofUrl'] ?? 'Not available';
        final String? name = userDoc.data()?['name'] ?? 'Not available';
        final String? phoneNumber =
            userDoc.data()?['phoneNumber'] ?? 'Not available';

        final interestedChoresRef = _firestore.collection('interestedChores');

        if (!isInterested) {
          // Add the chore to interestedChores
          await interestedChoresRef.add({
            'choreId': widget.choreId,
            'choreName': choreDetails?['choreName'] ?? 'Not available',
            'description': choreDetails?['description'] ?? 'Not available',
            'location': choreDetails?['location'] ?? 'Not available',
            'ownerName': choreDetails?['ownerName'] ?? 'Not available',
            'reward': choreDetails?['reward'] ?? 'Not available',
            'contact': choreDetails?['contact'] ?? 'Not available',
            'isUrgent': choreDetails?['isUrgent'] ?? false,
            'userId': user.uid,
            'postedAt': choreDetails?['postedAt'] ?? DateTime.now(),
            'imageUrl': choreDetails?['imageUrl'],
            'humanityPoints': currentHumanityPoints,
            'idProofUrl': idProofUrl,
            'userName': name,
            'phoneNumber': phoneNumber,
          });
        } else {
          // Find and delete the document from interestedChores
          final querySnapshot = await interestedChoresRef
              .where('choreId', isEqualTo: widget.choreId)
              .where('userId', isEqualTo: user.uid)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            // Delete the document(s) related to the chore
            for (var doc in querySnapshot.docs) {
              await doc.reference.delete();
            }
          }
        }

        setState(() {
          isInterested = !isInterested; // Toggle interest status
        });
      }
    } catch (e) {
      print(e);
    }
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate(); // Convert Timestamp to DateTime
    final DateFormat formatter =
        DateFormat('MMMM dd, yyyy, h:mm a'); // Format as desired
    return formatter.format(date); // Return formatted date string
  }

  @override
  Widget build(BuildContext context) {
    if (choreDetails == null) {
      return Scaffold(
        backgroundColor: kColor4,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final userId = _auth.currentUser?.uid;
    final isOwner = userId == choreDetails!['userId'];

    return Scaffold(
      backgroundColor: kColor4,
      appBar: AppBar(
        title: Text(
          "Chore Details",
          style: kTextPoppins.copyWith(color: Colors.white),
        ),
        backgroundColor: kColor1,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Chore Image
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(choreDetails!['imageUrl'] ??
                      'https://via.placeholder.com/150'), // Default image URL
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Chore Details Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chore Name
                  Row(
                    children: [
                      Icon(Icons.task_alt, color: kColor1),
                      const SizedBox(width: 8.0),
                      Text(
                        choreDetails!['choreName'] ?? 'Not available',
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // Description
                  Row(
                    children: [
                      Icon(Icons.assignment, color: kColor1),
                      const SizedBox(width: 8.0),
                      Text(
                        choreDetails!['description'] ?? 'Not available',
                        style: kTextPoppins,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on, color: kColor1),
                      const SizedBox(width: 8.0),
                      Text(
                        choreDetails!['location'] ?? 'Not available',
                        style: kTextPoppins,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // Posted At
                  Row(
                    children: [
                      Icon(Icons.access_time, color: kColor1),
                      const SizedBox(width: 8.0),
                      Text(
                        choreDetails!['postedAt'] is Timestamp
                            ? _formatDate(choreDetails!['postedAt'])
                            : 'Not available',
                        style: kTextPoppins,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // Owner Name
                  Row(
                    children: [
                      Icon(Icons.person, color: kColor1),
                      const SizedBox(width: 8.0),
                      Text(
                        choreDetails!['ownerName'] ?? 'Not available',
                        style: kTextPoppins,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // Reward
                  Row(
                    children: [
                      Icon(Icons.currency_rupee_outlined, color: kColor1),
                      const SizedBox(width: 8.0),
                      Text(
                        choreDetails!['reward'] ?? 'Not available',
                        style: kTextPoppins,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // Contact
                  Row(
                    children: [
                      Icon(Icons.phone, color: kColor1),
                      const SizedBox(width: 8.0),
                      Text(
                        choreDetails!['contact'] ?? 'Not available',
                        style: kTextPoppins,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // Urgency Status
                  Row(
                    children: [
                      Icon(Icons.warning, color: kColor1),
                      const SizedBox(width: 8.0),
                      Text(
                        choreDetails!['isUrgent'] == true
                            ? "Urgent"
                            : "Not Urgent",
                        style: kTextPoppins,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),

                  // Edit Button (Only for owner)
                  if (isOwner) // Check if the user is the owner
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to EditChorePage
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditChorePage(choreId: widget.choreId),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                kColor1, // Use a color of your choice
                          ),
                          child: const Text(
                            "Edit Chore",
                            style: TextStyle(color: kColor4, fontFamily: "Poppins"),
                          ),
                        ),
                      ),
                    ),

                  // Interested Button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: isOwner?Container():Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _toggleInterest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isInterested ? kColor2 : kColor3,
                        ),
                        child: Text(
                          isInterested ? "Interested" : "Show interest",
                          style: TextStyle(color: kColor4, fontFamily: "Poppins"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
