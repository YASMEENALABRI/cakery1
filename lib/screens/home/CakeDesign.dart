import 'package:flutter/material.dart';
import 'package:cakery/screens/home/OrderMng.dart';
import 'package:cakery/screens/home/Payment.dart';
import 'package:cakery/screens/home/Ar.dart' as arPage; // Use alias for ARVisualizationPage

class CakeDesignPage extends StatefulWidget {
  @override
  _CakeDesignPageState createState() => _CakeDesignPageState();
}

class _CakeDesignPageState extends State<CakeDesignPage> {
  String selectedColor = "Red";
  String selectedShape = "Round";
  String selectedFlavor = "Vanilla";
  String textOnCake = "";
  List<String> extraItems = [];

  final List<String> colors = [
    "Red", "Blue", "Green", "Yellow", "Pink", "Purple", "Orange", "Brown"
  ];
  final List<String> shapes = ["Round", "Square", "Heart"];
  final List<String> flavors = ["Vanilla", "Chocolate", "Strawberry"];
  final List<String> extraItemsList = ["Sprinkles", "Fruits", "Nuts"];

  double getPrice() {
    double basePrice = 30.0; // Base price for the cake
    if (selectedShape == "Square") basePrice += 5.0;
    if (selectedShape == "Heart") basePrice += 7.0;
    return basePrice + (extraItems.length * 2.0); // Additional cost for extra items
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customize Your Cake'),
        backgroundColor: Color(0xFFE1BEE7),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              // Navigate to ARVisualizationPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => arPage.ARVisualizationPage()),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar with options
          Container(
            width: 150,
            padding: EdgeInsets.all(8.0),
            color: Color(0xFFF3E5F5), // Background color for the sidebar
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDropdown(
                  '🔲 Shape',
                  shapes,
                  selectedShape,
                      (value) {
                    setState(() {
                      selectedShape = value!;
                    });
                  },
                ),
                _buildDropdown(
                  '🍓 Flavor',
                  flavors,
                  selectedFlavor,
                      (value) {
                    setState(() {
                      selectedFlavor = value!;
                    });
                  },
                ),
                _buildDropdown(
                  '🌈 Color',
                  colors,
                  selectedColor,
                      (value) {
                    setState(() {
                      selectedColor = value!;
                    });
                  },
                ),
                _buildToppingsDropdown(),
              ],
            ),
          ),

          // Cake preview and input area
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Cake Image Preview (Placeholder)
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: getColorFromString(selectedColor), // Use selected color
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.purple, width: 3),
                    ),
                    child: Center(child: Text('Cake Preview', style: TextStyle(color: Colors.white))),
                  ),

                  SizedBox(height: 16.0),

                  // Text Input
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Text on Cake',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        textOnCake = value;
                      });
                    },
                  ),

                  SizedBox(height: 16.0),

                  // Display Price
                  Text(
                    'Total Price: ${getPrice().toStringAsFixed(2)} OMR',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 20.0),

                  // Submit Button
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to PaymentPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PaymentPage()),
                      );
                    },
                    child: Text('Next'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, // Set text color
                      backgroundColor: Colors.purple,
                      minimumSize: Size(double.infinity, 40), // Full width button
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String selectedValue, ValueChanged<String?> onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButtonFormField<String>(
            value: selectedValue,
            onChanged: onChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildToppingsDropdown() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🍒 Toppings', style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButtonFormField<String>(
            value: null, // No default selection
            onChanged: (value) {
              setState(() {
                if (value != null && !extraItems.contains(value)) {
                  extraItems.add(value);
                }
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: extraItemsList.map<DropdownMenuItem<String>>((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color getColorFromString(String color) {
    switch (color) {
      case "Red":
        return Colors.red;
      case "Blue":
        return Colors.blue;
      case "Green":
        return Colors.green;
      case "Yellow":
        return Colors.yellow;
      case "Pink":
        return Colors.pink;
      case "Purple":
        return Colors.purple;
      case "Orange":
        return Colors.orange;
      case "Brown":
        return Colors.brown;
      default:
        return Colors.white;
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: CakeDesignPage(),
  ));
}