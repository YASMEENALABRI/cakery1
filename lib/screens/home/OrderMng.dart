import 'package:flutter/material.dart';
import 'package:cakery/screens/home/Payment.dart'; // Ensure the import is correct
import 'package:cakery/screens/home/ChatBot.dart';

class OrderManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Management'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // View Current Order Button
            _buildOrderButton(
              context,
              title: 'View Current Order',
              description: 'Users can view details of their current orders.',
              onPressed: () {
                // Navigate to the Current Order page
              },
            ),
            SizedBox(height: 20.0),

            // Add to Cart Button
            _buildOrderButton(
              context,
              title: 'Add to Cart',
              description: 'Select multiple cakes and add them to basket.',
              onPressed: () {
                // Navigate to the Add to Cart page
              },
            ),
            SizedBox(height: 20.0),



            // Chat Bot Button
            _buildOrderButton(
              context,
              title: 'Chat Bot',
              description: 'Get assistance from our chat bot.',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatBotPage()),
                );
              },
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderButton(BuildContext context, {required String title, required String description, required VoidCallback onPressed}) {
    return Card(
      elevation: 4,
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
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
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

// Placeholder for PaymentModulePage
class PaymentModulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Module'),
      ),
      body: Center(child: Text('Payment Module Page')),
    );
  }
}

// Placeholder for ChatBotPage
class ChatBotPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Bot'),
      ),
      body: Center(child: Text('Chat Bot Page')),
    );
  }
}

// Placeholder for ARVisualizationPage
class ARVisualizationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AR Visualization'),
      ),
      body: Center(child: Text('AR Visualization Page')),
    );
  }
}