import 'package:flutter/material.dart';
import 'package:cakery/screens/home/CakeDesign.dart';
import 'package:cakery/screens/profile/update.dart'; // Ensure this path is correct
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cakery/screens/welcome.dart';

class PreviousOrderPage extends StatefulWidget {
  @override
  _PreviousOrderPageState createState() => _PreviousOrderPageState();
}

class _PreviousOrderPageState extends State<PreviousOrderPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  // Sample data for previous orders
  List<Map<String, String>> previousOrders = [
    {
      'cakeName': 'Chocolate Delight',
      'occasion': 'Birthday',
      'date': '2023-12-20',
      'price': '20 OMR'
    },
    {
      'cakeName': 'Vanilla Dream',
      'occasion': 'Anniversary',
      'date': '2023-11-15',
      'price': '25 OMR'
    },
    {
      'cakeName': 'Red Velvet',
      'occasion': 'Graduation',
      'date': '2023-10-10',
      'price': '30 OMR'
    },
  ];

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out. Please try again.')),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.person), // Icon for Profile
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileManagement()), // Navigate to UpdatePage
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout_sharp),
            onPressed: () => _showSignOutDialog(context),
          ),
        ],
        title: Text('Previous Orders'),
        backgroundColor: Color(0xFFE1BEE7),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : previousOrders.isEmpty
            ? Center(child: Text('No previous orders found.'))
            : ListView.builder(
          itemCount: previousOrders.length,
          itemBuilder: (context, index) {
            final order = previousOrders[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['cakeName']!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text('Occasion: ${order['occasion']}'),
                    Text('Date: ${order['date']}'),
                    Text('Price: ${order['price']}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}