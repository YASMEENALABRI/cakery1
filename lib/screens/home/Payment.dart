import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cakery/screens/home/Search.dart';
import 'package:cakery/screens/home/Feedback.dart';
import 'package:cakery/screens/home/Help.dart'; // Import your HelpModulePage
import 'package:cakery/screens/home/ChatBot.dart'; // Import your ChatBotPage

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Options'),
        backgroundColor: Color(0xFFE1BEE7),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline), // Help icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpModulePage()),
              );
            },
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.comments), // Chatbot icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatBotPage()), // Navigate to ChatBotPage
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPaymentHistorySection(),
            SizedBox(height: 20),
            Text('Select Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildPaymentMethodCard('UPI', 'upi-id@example.com', FontAwesomeIcons.mobileAlt), // UPI option
            _buildPaymentMethodCard('Visa/MasterCard', 'xxxx-1308', FontAwesomeIcons.ccVisa), // Combined option
            _buildPaymentMethodCard('Cash on Delivery', '', Icons.money),
            _buildPaymentMethodCard('Add New Card', '', Icons.add_card), // Add new card option
            SizedBox(height: 20),
            _buildDiscountNotification(),
            SizedBox(height: 20),
            Spacer(),
            _buildConfirmAndCancelButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text('No payment history available.', style: TextStyle(color: Colors.grey)),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard(String method, String cardNumber, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: _selectedPaymentMethod == method ? Colors.black.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 24),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(method, style: TextStyle(fontWeight: FontWeight.bold)),
                if (cardNumber.isNotEmpty)
                  Text(cardNumber, style: TextStyle(color: Colors.grey[700])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountNotification() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.yellow[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange),
      ),
      child: Row(
        children: [
          Icon(Icons.local_offer, color: Colors.orange),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Special discounts available! Check out our promotions.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmAndCancelButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            minimumSize: Size(150, 50),
          ),
          child: Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FeedbackPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            minimumSize: Size(150, 50),
          ),
          child: Text('Confirm Order', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PaymentPage(),
  ));
}