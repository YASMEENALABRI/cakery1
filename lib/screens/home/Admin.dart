import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cakery/screens/welcome.dart'; // Ensure this path is correct
import 'package:cakery/screens/profile/Aupdate.dart';
import 'package:cakery/screens/home/Report.dart'; // Ensure this path is correct

class AdminModulePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize Firebase Auth
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin(); // Initialize notifications

  AdminModulePage() {
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      // Navigate to main page and remove all previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out. Please try again.')));
    }
  }

  Future<void> _showSignOutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Out'),
          content: Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Sign Out'),
              onPressed: () {
                Navigator.of(context).pop();
                _signOut(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showNotificationDialog(BuildContext context) {
    // Logic to show notifications when the icon is pressed
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification icon pressed!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Color(0xFFE1BEE7),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications), // Notification icon
            onPressed: () => _showNotificationDialog(context), // Handle notification icon press
          ),
          IconButton(
            icon: Icon(Icons.person), // Icon for Profile
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ADProfileManagement()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout_sharp),
            onPressed: () => _showSignOutDialog(context),
          ),
        ],
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // User Management Section
              _buildManagementCard(
                context,
                title: 'User Management',
                description: 'Add, edit, or delete user accounts.',
                icon: Icons.people,
                color: Colors.teal,
                onPressed: () {
                  // Navigate to User Management page
                },
              ),
              SizedBox(height: 20.0),

              // Content Management Section
              _buildManagementCard(
                context,
                title: 'Content Management',
                description: 'Create, edit, or remove products.',
                icon: Icons.content_paste,
                color: Colors.orange,
                onPressed: () {
                  // Navigate to Content Management page
                },
              ),
              SizedBox(height: 20.0),

              // Report Section
              _buildManagementCard(
                context,
                title: 'Report',
                description: 'View and manage reports.',
                icon: Icons.report, // Report icon
                color: Colors.red,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReportModulePage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManagementCard(BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color,
                child: Icon(icon, color: Colors.white, size: 30),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      description,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}