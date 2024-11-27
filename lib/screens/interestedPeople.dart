import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:help_hub/screens/widgets/constant.dart';



class InterestedPeoplePage extends StatefulWidget {
  final String choreId;

  const InterestedPeoplePage({Key? key, required this.choreId}) : super(key: key);

  @override
  _InterestedPeoplePageState createState() => _InterestedPeoplePageState();
}

class _InterestedPeoplePageState extends State<InterestedPeoplePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _incrementHumanityPoints(String userId, int currentPoints) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'humanityPoints': currentPoints + 1,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Humanity points incremented!')),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColor4,
      appBar: AppBar(
        title: Text( // Removed 'const' here
          "Interested People",
          style: kTextPoppins.copyWith(color: Colors.white), // Set text color to white
        ),
        backgroundColor: kColor1,
        iconTheme: IconThemeData(color: Colors.white), // Set icon color (back arrow) to white
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('interestedChores')
            .where('choreId', isEqualTo: widget.choreId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final interestedDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: interestedDocs.length,
            itemBuilder: (context, index) {
              final doc = interestedDocs[index];
              final String userName = doc['userName'] ?? 'Not available';
              final String phoneNumber = doc['phoneNumber'] ?? 'Not available';
              final int humanityPoints = doc['humanityPoints'] ?? 0;
              final String idProofUrl = doc['idProofUrl'] ?? 'Not available';
              final String userId = doc['userId'];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person, color: kColor1),
                          const SizedBox(width: 8.0),
                          Text(userName, style: kTextPoppins.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.phone, color: kColor1),
                          const SizedBox(width: 8.0),
                          Text(phoneNumber, style: kTextPoppins),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.star, color: kColor2),
                          const SizedBox(width: 8.0),
                          Text("Humanity Points: $humanityPoints", style: kTextPoppins),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Show the ID proof URL
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("ID Proof", style: kTextPoppins),
                                  content: Text(idProofUrl, style: kTextPoppins),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Close", style: TextStyle(color: kColor1)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kColor1,
                              foregroundColor: kColor4,
                            ),
                            child: const Text("View ID Proof", style: kTextPoppins),
                          ),
                          ElevatedButton(
                            onPressed: () => _incrementHumanityPoints(userId, humanityPoints),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kColor2,
                              foregroundColor: kColor4,
                            ),
                            child: const Text("Give Humanity Point", style: kTextPoppins),
                          ),
                        ],
                      ),
                    ],
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
