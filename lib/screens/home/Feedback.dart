import 'package:flutter/material.dart';
import 'package:cakery/screens/home/Thanks.dart'; // Ensure this import is correct

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
        backgroundColor: Color(0xFFE1BEE7),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Feedback Submission Section
            _buildFeedbackSection(),
            SizedBox(height: 20.0),

            // Rating Section
            _buildRatingSection(),

            SizedBox(height: 20.0),

            ElevatedButton(
              onPressed: () {
                // Navigate back to the SearchPage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ThankYouPage()),
                );
              },
              child: Text('Submit Feedback'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple, // Background color
                foregroundColor: Colors.white, // Text color
                minimumSize: Size(150, 40), // Adjusted size for a smaller button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Feedback',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Your feedback is the icing on the cake! Share your thoughts! 🧁',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Share your feedback or sweet suggestions with us...! 📝',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rating',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '🎉 Rate your experience with our cakes! Your feedback matters!',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.yellow[600],
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1.0;
                    });
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _submitFeedback() {
    // Logic to handle feedback submission
    String feedback = _feedbackController.text;
    // Example: Send to server or save locally
    print('Feedback: $feedback');
    print('Rating: $_rating');

    // Clear input fields after submission
    _feedbackController.clear();
    setState(() {
      _rating = 0.0; // Reset rating
    });

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Thank you for your feedback!')),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Cakery App',
    home: FeedbackPage(),
    theme: ThemeData(
      primarySwatch: Colors.purple,
    ),
  ));
}