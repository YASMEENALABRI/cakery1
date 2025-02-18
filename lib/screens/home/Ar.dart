import 'package:flutter/material.dart';

class ARVisualizationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualize Custom Cakes in AR'),
        backgroundColor: Color(0xFFE1BEE7),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction Section
            Text(
              'Visualize Your Custom Cake',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '"✨ Experience your custom cake designs in real life with AR technology! 🎂 See how they look in your space before you order!".',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 10.0),

            // AR Preview Area
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'AR Preview Area',
                  style: TextStyle(fontSize: 20, color: Colors.purple),
                ),
              ),
            ),
            SizedBox(height: 10.0),

            // Instructions Section
            Text(
              'Instructions:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            Container(
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.white, // Background color for the box
                border: Border.all(color: Colors.purple, width: 4), // Border color and width
                borderRadius: BorderRadius.circular(10), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(4.0, 2.0),
                  ),
                ],
              ),
              child: Text(
                '🌟 How to Visualize Your Pre-Made Cake in AR:\n\n'
                    '📍 1. Point your camera at a flat surface.\n'
                    '🎂 2. Select a pre-made cake design.\n'
                    '👀 3.Tap "Visualize" to see it in your space!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black, // Text color
                  height: 2,
                  // Line height for better readability
                ),
                textAlign: TextAlign.left, // Align text to the left
              ),
            ),


            // Visualize Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Functionality to launch AR visualization
                },
                child: Text('Visualize in AR'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white, // Set text color to white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}