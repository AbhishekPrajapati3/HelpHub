import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gap/gap.dart';
import 'package:help_hub/screens/widgets/constant.dart';

import 'login_screen.dart';


class Profile extends StatefulWidget {
   String  id = "profileScreen";
   Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Stream<DocumentSnapshot>? _stream;

  @override
  void initState() {
    super.initState();
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUid != null) {
      _stream = FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserUid)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColor4,
      body: _stream == null
          ? const Center(child: Text('No user data found.'))
          : Center(
            child: StreamBuilder<DocumentSnapshot>(
                    stream: _stream,
                    builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('No user data found.'));
            }

            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final name = userData['name'] ?? '';
            final email = userData['email'] ?? '';
            final phoneNumber = userData['phoneNumber'] ?? '';

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Gap(20),
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: kColor1,
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: kColor1,
                      ),
                    ),
                    const Gap(50),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 27.0),
                              child: Icon(
                                Icons.info_outline,
                                color: kColor1,
                              ),
                            ),
                            const Gap(3),
                            Text(
                              'About me',
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: kColor1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          margin:
                          const EdgeInsets.symmetric(horizontal: 24.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: kColor1), // Border color
                            borderRadius: BorderRadius.circular(13),
                            color: Colors.white, // Background color
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name: $name',
                                  style: kText1,
                                ),
                                const Gap(5),
                                Text(
                                  'Email: $email',
                                  style: kText1,
                                ),
                                const Gap(5),
                                Text(
                                  'Phone Number: $phoneNumber',
                                  style: kText1,
                                ),
                                const Gap(20),
                                Center(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditDetailsForm(
                                                  userData: userData),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kColor3,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 10.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(17),
                                      ),
                                    ),
                                    icon: Icon(Icons.edit,
                                        color: Colors.white),
                                    label: Text('Edit Details',
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            color: kColor4,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(100), // Gap between buttons


                      ],
                    ),
                  ],
                ),
              ),
            );
                    },
                  ),
          ),
    );
  }
}

class EditDetailsForm extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditDetailsForm({Key? key, required this.userData}) : super(key: key);

  @override
  _EditDetailsFormState createState() => _EditDetailsFormState();
}

class _EditDetailsFormState extends State<EditDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _email;
  late String _mobileNumber;

  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _name = widget.userData['name'] ?? '';
    _email = widget.userData['email'] ?? '';
    _mobileNumber = widget.userData['phoneNumber'] ?? '';
  }

  void _saveDetails() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserUid != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserUid)
            .update({
          'name': _name,
          'email': _email,
          'phoneNumber': _mobileNumber,
        });

        setState(() {
          _isSaved = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Details updated successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Details', style: kTextPoppins),
        backgroundColor: kColor1,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                style: kTextPoppins,
                initialValue: _name,
                decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Name', labelStyle: kTextPoppins),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              const Gap(10),
              TextFormField(
                style: kTextPoppins,
                initialValue: _email,
                decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Email', labelStyle: kTextPoppins),
                onSaved: (value) => _email = value!,
              ),
              const Gap(10),
              TextFormField(
                style: kTextPoppins,
                initialValue: _mobileNumber,
                decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Phone Number', labelStyle: kTextPoppins),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onSaved: (value) => _mobileNumber = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kColor1,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                ),
                child: Text('Save Changes',
                    style: kTextPoppins.copyWith(color: kColor4)),
              ),
              if (_isSaved)
                const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('Changes saved!', textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.green, fontFamily: "Poppins", ))),
            ],
          ),
        ),
      ),
    );
  }
}