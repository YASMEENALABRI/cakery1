import 'package:flutter/material.dart';

class HelpModulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
        backgroundColor: Color(0xFFE1BEE7),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Message
            Text(
              'Welcome to Our Help Module! 🍰',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'How Can We Assist You Today?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.0),

            // Help Section Description
            Text(
              'The Help Module makes it a piece of cake to reach our supportive team 📞, ensuring you receive quick assistance whenever you run into any hiccups while ordering your favorite cake! 🎂💬',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 30.0),

            // Contact Options Section
            Text(
              'Contact Support:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 16.0),

            // Email Support Button
            _buildContactButton(
              context,
              title: '📧 Email Support',
              description: 'Reach out to our support team via email.',
              onPressed: () {
                // Navigate to Email Support page
              },
            ),
            SizedBox(height: 16.0),

            // Phone Support Button
            _buildContactButton(
              context,
              title: '📞 Phone Support',
              description: 'Call our support team for immediate assistance.',
              onPressed: () {
                // Navigate to Phone Support page
              },
            ),
            SizedBox(height: 16.0),

            // FAQ Section Button
            _buildContactButton(
              context,
              title: '❓ Frequently Asked Questions (FAQ)',
              description: 'Find answers to common questions.',
              onPressed: () {
                // Navigate to FAQ page
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton(BuildContext context, {required String title, required String description, required VoidCallback onPressed}) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                description,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}