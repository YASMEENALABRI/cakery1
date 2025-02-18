import 'package:flutter/material.dart';
import 'package:cakery/screens/home/CakeDesign.dart';
import 'package:cakery/screens/profile/update.dart'; // Ensure this path is correct
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cakery/screens/welcome.dart';
import 'package:cakery/screens/home/PreviousOrder.dart'; // Ensure this path is correct
import 'package:cakery/screens/home/payment.dart'; // Ensure this path is correct

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController occasionController = TextEditingController();
  TextEditingController cakeController = TextEditingController();
  bool _isLoading = false;

  Future<void> performSearch() async {
    setState(() {
      _isLoading = true;
    });

    // Simulated search logic
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

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

  Future<void> _showNotificationDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notification'),
          content: Text('This is a notification dialog.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
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
        title: Text('Search Cakes'),
        backgroundColor: Color(0xFFE1BEE7),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Search Bar
            _buildSearchField(occasionController, 'What occasion are you having?'),
            SizedBox(height: 16.0),
            _buildSearchField(cakeController, 'Search by cake flavor or name'),
            SizedBox(height: 20.0),

            // Loading Indicator
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else
            // Make your own cake section
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage('assets/searchBackground.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              'Make your own cake!',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CakeDesignPage()),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.purple,
                            ),
                            padding: EdgeInsets.all(9),
                            child: Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0), // Space between the sections
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Navigate to the Previous Order screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PaymentPage()),
                          );
                        },
                        child: Text(
                          'Previous order',
                          style: TextStyle(
                            color: Colors.purple,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            SizedBox(height: 20.0),

            // Cake Collections Section
            _buildCakeCollectionSection(
              'Birthday Collection',
              ['b1', 'b2', 'b3', 'b4', 'b5'],
              ['The Festival', 'Faces', 'Aliens', 'Feeling Fine', 'White Bow'],
            ),
            _buildCakeCollectionSection(
              'Ribbons Collection',
              ['r1', 'r2', 'r3', 'r4', 'r5', 'r6'],
              ['Blue Ribbons and cherry', 'Blue Ribbons', 'Floral Ribbon', 'Black Ribbon', 'Purple Ribbon', 'Classic Gift'],
            ),
            _buildCakeCollectionSection(
              'Chill Vibes Collection',
              ['ch1', 'ch2', 'ch3', 'ch4', 'ch5', 'ch6', 'ch7'],
              ['Here for U', 'Wonderland', 'Winter Wings', 'Among the Clouds', 'Christmas Snow', 'Winter Love', 'Snowman'],
            ),
            _buildCakeCollectionSection(
              'She\'s The First Collection',
              ['m1', 'm2', 'm3', 'm4'],
              ['My Flower', 'Best Mom', 'The Butterfly', 'Love you mama'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      ),
    );
  }

  Widget _buildCakeCollectionSection(String title, List<String> imageNames, List<String> cakeNames) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.0),
        Container(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imageNames.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(right: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/${imageNames[index]}.jpg',
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      cakeNames[index],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0),
                    Text('Price: 15 OMR', style: TextStyle(color: Colors.green)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    occasionController.dispose();
    cakeController.dispose();
    super.dispose();
  }
}