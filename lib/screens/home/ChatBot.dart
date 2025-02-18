import 'package:flutter/material.dart';

class ChatBotPage extends StatefulWidget {
  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  List<String> messages = [];

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        // Add user message
        messages.add('👤 User: ${_controller.text}');

        // Simulated bot response
        messages.add('🌟 Welcome to Cakery! 🎂\n\n'
            'Hey there! 👋 We\'re excited to have you!\n\n'
            'Indulge in our delicious cakes, each made with love! 🍰✨\n\n'
            'Why Choose Cakery?\n'
            '- Fresh & Handcrafted: Daily baked with the finest ingredients.\n'
            '- Custom Cakes: Celebrate with a personalized creation! 🎉\n\n'
            'Let\'s make your celebrations sweeter! Explore our menu now! 🎉🍰\n\n'
            'Need help? Just ask! We\'re here for you! ❤️');

        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Bot'),
        backgroundColor: Color(0xFFE1BEE7),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Chat Messages List
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      messages[index],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black, // Set all messages to black
                      ),
                    ),
                  );
                },
              ),
            ),
            // Input Field
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Ask me anything...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.purple),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}