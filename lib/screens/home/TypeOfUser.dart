import 'package:cakery/screens/login/AdminLogin.dart';
import 'package:cakery/screens/login/ChefLogin.dart';
import 'package:cakery/screens/register/register.dart';
import 'package:flutter/material.dart';
import 'details.dart';

class TypeOfUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF69065D),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back when the arrow is pressed
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 1),
            const Text(
              ' Who Are You in the Cake World?  ',
              style: TextStyle(
                fontSize: 23.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.white,
                fontFamily: 'IndieFlower',
                shadows: [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.black54,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/logo.png',
              height: 300,
              width: 300,
            ),
            SizedBox(height: 40),
            FractionallySizedBox(
              widthFactor: 0.4, // Set the width factor
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegisterUser(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Set the background color
                ),
                child: const Text(
                  'Customer',
                  style: TextStyle(
                    color: Colors.black, // Set the text color for contrast
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FractionallySizedBox(
              widthFactor: 0.4, // Set the width factor
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminLoginPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Set the background color
                ),
                child: const Text(
                  'Admin',
                  style: TextStyle(
                    color: Colors.black, // Set the text color for contrast
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            FractionallySizedBox(
              widthFactor: 0.4, // Set the width factor
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChefLoginPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Set the background color
                ),
                child: const Text(
                  'Chef',
                  style: TextStyle(
                    color: Colors.black, // Set the text color for contrast
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AdminLogin() {}

  CusLogin() {}
}
