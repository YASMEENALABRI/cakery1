import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileManagement extends StatefulWidget {
  @override
  _ProfileManagementState createState() => _ProfileManagementState();
}

class _ProfileManagementState extends State<ProfileManagement> {
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase.instance.ref();

  User? user;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController userEmailController = TextEditingController();
  final TextEditingController userPhoneController = TextEditingController();
  String selectedAddress = '';

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    if (user != null) {
      _fetchUserData();
    }
  }

  Future<void> _fetchUserData() async {
    final userSnapshot = await _database.child('users').child(user!.uid).once();
    final userData = userSnapshot.snapshot.value as Map<dynamic, dynamic>;

    setState(() {
      userNameController.text = userData['name'] ?? '';
      userEmailController.text = userData['email'] ?? '';
      userPhoneController.text = userData['phoneNumber'] ?? '';
      selectedAddress = userData['address'] ?? '';
    });
  }

  Future<void> _updateUserData() async {
    // Validate name
    if (userNameController.text.isEmpty || userNameController.text.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid name (at least 3 characters).')),
      );
      return;
    }

    // Validate phone number
    if (userPhoneController.text.isEmpty || !validatePhoneNumber(userPhoneController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid phone number starting with 9 or 7 and exactly 8 digits long.')),
      );
      return;
    }

    // Validate address selection
    if (selectedAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an address.')),
      );
      return;
    }

    if (user != null) {
      await _database.child('users').child(user!.uid).update({
        'name': userNameController.text,
        'email': userEmailController.text,
        'phoneNumber': userPhoneController.text,
        'address': selectedAddress,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  void _showForgotPasswordDialog() {
    TextEditingController resetEmailController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text("Reset Password"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: resetEmailController,
                  decoration: InputDecoration(
                      hintText: "Enter your email", enabled: !isLoading),
                ),
                if (isLoading)
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: isLoading
                    ? null
                    : () async {
                  String email = resetEmailController.text.trim();
                  if (email.isNotEmpty) {
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      await _auth.sendPasswordResetEmail(email: email);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Password reset email sent!')));
                    } on FirebaseAuthException catch (e) {
                      String errorMessage = 'Failed to send reset email';
                      if (e.code == 'user-not-found') {
                        errorMessage =
                        'No account found with this email.';
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage)));
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please enter your email')));
                  }
                },
                child: Text("Send"),
              ),
            ],
          );
        });
      },
    );
  }

  // Phone number validation method
  bool validatePhoneNumber(String phone) {
    final regex = RegExp(r'^(9|7)\d{7}$');
    return regex.hasMatch(phone);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile Management'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User Name', style: TextStyle(fontSize: 16)),
                TextField(
                  controller: userNameController,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                SizedBox(height: 16),
                Text('Email', style: TextStyle(fontSize: 16)),
                TextField(
                  controller: userEmailController,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  readOnly: true,
                ),
                SizedBox(height: 16),
                Text('Phone Number', style: TextStyle(fontSize: 16)),
                TextField(
                  controller: userPhoneController,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                SizedBox(height: 16),
                Text('Address', style: TextStyle(fontSize: 16)),
                DropdownButtonFormField<String>(
                  value: selectedAddress.isNotEmpty ? selectedAddress : null,
                  hint: Text('Select Address'),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedAddress = newValue!;
                    });
                  },
                  items: <String>[
                    'Muscat',
                    'Rustaq',
                    'Sohar',
                    'Sur',
                    'Nizwa',
                    'Salalah',
                    'Bahla',
                    'Ibri',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: _updateUserData,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.purple),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                      shadowColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)),
                      elevation: MaterialStateProperty.all(5),
                    ),
                    child: Container(
                      width: 200,
                      child: Text(
                        "Update Profile",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _showForgotPasswordDialog,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                      shadowColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.3)),
                      elevation: MaterialStateProperty.all(5),
                    ),
                    child: Container(
                      width: 200,
                      child: Text(
                        "Reset Password",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}