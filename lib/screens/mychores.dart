import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:help_hub/screens/widgets/constant.dart';
import 'choreDetails.dart';
import 'interestedPeople.dart';

const kPrimaryColor = Color(0xFF344955);

class MyChoresPage extends StatefulWidget {
  @override
  _MyChoresPageState createState() => _MyChoresPageState();
}

class _MyChoresPageState extends State<MyChoresPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  // Method to delete a chore
  void deleteChore(String choreId) async {
    await FirebaseFirestore.instance.collection('Chores').doc(choreId).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Chore deleted successfully!')),
    );
  }

  // Method to show confirmation dialog
  void showDeleteConfirmationDialog(String choreId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kColor1, // Set the background color
          title: Text(
            'Delete Chore',
            style: TextStyle(color: kColor4), // Change title text color
          ),
          content: Text(
            'Are you sure you want to delete this chore?',
            style: TextStyle(color: kColor4), // Change content text color
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: kColor4), // Change cancel button text color
              ),
            ),
            TextButton(
              onPressed: () {
                deleteChore(choreId); // Call delete method
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Delete',
                style: TextStyle(
                    color: kColor4), // Change delete button text color
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Chores'),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Chores')
            .where('userId', isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final Chores = snapshot.data?.docs;
          if (Chores == null || Chores.isEmpty){
            return Center(
              child: Text('No Chores found!'),
            );
          }
          return ListView.builder(
            itemCount: Chores.length,
            itemBuilder: (context, index) {
              final chore = Chores[index];
              final choreId = chore.id; // Get the chore ID
              return InkWell(onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ChoreDetailsPage(choreId: choreId),
                  ),
                );
              },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Chore Name
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.task_alt, color: kPrimaryColor),
                                  SizedBox(width: 8),
                                  Text(
                                    chore['choreName'] ?? 'No Chore Name',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              // Delete Icon
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    showDeleteConfirmationDialog(choreId),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          // Location
                          Row(
                            children: [
                              Icon(Icons.location_on, color: kColor1),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Location: ${chore['location'] ?? 'Unknown'}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          // Reward
                          Row(
                            children: [
                              Icon(Icons.currency_rupee_outlined, color: kColor2),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Reward: ${chore['reward'] ?? 'None'}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          // Urgency and Completion Status
                          Row(
                            children: [
                              Icon(Icons.warning, color: Colors.redAccent),
                              SizedBox(width: 8),
                              Text(
                                'Urgent: ${chore['isUrgent'] ? "Yes" : "No"}',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(width: 20),
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 8),
                              Text(
                                'Completed: ${chore['isCompleted'] ? "Yes" : "No"}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          // Owner Name
                          Row(
                            children: [
                              Icon(Icons.person, color: kColor3),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Owner: ${chore['ownerName'] ?? 'Unknown'}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          // Interested People Button
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisSize: MainAxisSize
                                  .min, // Minimize the row size to fit buttons
                              children: [
                                // New View Details Button
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Navigate to ChoreDetailsPage and pass the choreId
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChoreDetailsPage(choreId: choreId),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.info, color: Colors.white),
                                  label: Text('View Details'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor:
                                        Colors.white, // Text/Icon color
                                    backgroundColor: kColor2, // Background color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4), // Space between buttons
                                // Existing Interested People Button
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Navigate to InterestedPeoplePage and pass the choreId
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            InterestedPeoplePage(
                                                choreId: choreId),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.people, color: Colors.white),
                                  label: Text('Interested'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor:
                                        Colors.white, // Text/Icon color
                                    backgroundColor: kColor1, // Background color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Image (if available)
                          chore['imageUrl'] != null
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 16.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      chore['imageUrl'],
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(), // Show no image if imageUrl is not available
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
