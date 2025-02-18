import 'package:cakery/screens/home/TypeOfUser.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        // Check user type in database
        final customerSnapshot =
            await _database.child('users').child(user.uid).get();

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          if (customerSnapshot.exists) {
            // User is a customer, navigate to menu
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TypeOfUser()),
            );
            return;
          }
        }
      } catch (e) {
        print("Error checking user type: $e");
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF69065D),
      appBar: AppBar(
        backgroundColor: Color(0xFF69065D),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 2),
                  ClipOval(
                    child: Image.asset(
                      'assets/logo.png',
                      width: 300,
                      height: 300,
                    ),
                  ),
                  const SizedBox(height: 1),
                  const Text(
                    'Cakery',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: Colors.white,
                      fontFamily: 'IndieFlower',
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Baking...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      letterSpacing: 2.0,
                      color: Colors.white,
                      fontFamily: 'IndieFlower',
                    ),
                  ),
                  const Text(
                    'Cakery will come to you right away ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      letterSpacing: 2.0,
                      color: Colors.white,
                      fontFamily: 'IndieFlower',
                    ),
                  ),
                  const SizedBox(height: 150),
                  Container(
                    alignment: Alignment.center,
                    child: FractionallySizedBox(
                      widthFactor: 0.4,
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TypeOfUser(),
                            ),
                          );
                        },
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            color: Color(0xFF69065D),
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
