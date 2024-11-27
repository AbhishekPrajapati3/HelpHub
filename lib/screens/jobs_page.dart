import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_hub/screens/widgets/constant.dart';

import 'choreDetails.dart';

class JobsPage extends StatefulWidget {
  @override
  _JobsPageState createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState(){
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search Chores by name or location',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Chores').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error loading data.'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasData) {
                final Chores = snapshot.data!.docs;

                // Filter Chores based on search query
                final filteredChores = Chores.where((chore) {
                  final choreName = chore['choreName']?.toString().toLowerCase() ?? '';
                  final location = chore['location']?.toString().toLowerCase() ?? '';
                  return choreName.contains(_searchText) || location.contains(_searchText);
                }).toList();

                if (filteredChores.isEmpty) {
                  return Center(child: Text('No Chores available.'));
                }

                return GridView.builder(
                  padding: EdgeInsets.all(16.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Two cards per row
                    childAspectRatio: 0.65, // Adjust the ratio to control height better
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: filteredChores.length,
                  itemBuilder: (context, index) {
                    var chore = filteredChores[index];
                    String choreName = chore['choreName'] ?? 'Unnamed Chore';
                    String contact = chore['contact'] ?? 'No Contact Info';
                    String location = chore['location'] ?? 'No Location';
                    String reward = chore['reward'] ?? 'No Reward';
                    String? imageUrl = chore['imageUrl']; // May be null
                    String choreId = chore['choreId'];
                    bool isUrgent = chore['isUrgent'] ?? false; // Default to false if not available

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image or icon placeholder
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            child: imageUrl != null
                                ? Image.network(
                              imageUrl,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                                : Container(
                              height: 100,
                              width: double.infinity,
                              color: kColor3,
                              child: Icon(Icons.work, size: 50, color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Chore name with optional urgent icon
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          choreName,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: kColor1,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (isUrgent) // Show urgent icon if isUrgent is true
                                        Icon(
                                          Icons.warning_amber_rounded,
                                          color: Colors.redAccent,
                                          size: 18,
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  // Contact
                                  Row(
                                    children: [
                                      Icon(Icons.phone, color: kColor2, size: 16),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          contact,
                                          style: TextStyle(fontSize: 12, color: Colors.black54),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  // Location
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, color: kColor3, size: 16),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          location,
                                          style: TextStyle(fontSize: 12, color: Colors.black54),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  // Reward
                                  Row(
                                    children: [
                                      Icon(Icons.currency_rupee_outlined, color: kColor2, size: 16),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          reward,
                                          style: TextStyle(fontSize: 12, color: Colors.black54),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChoreDetailsPage(choreId: choreId),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kColor1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12), // Adjust vertical padding for the button
                              ),
                              child: Text(
                                'View',
                                style: TextStyle(color: kColor4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }

              return Center(child: Text('No data available.'));
            },
          ),
        ),
      ],
    );
  }



  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
