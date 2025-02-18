import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cakery/screens/welcome.dart'; // Ensure this path is correct
import 'package:cakery/screens/profile/Cupdate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CakeOrderApp());
}

class CakeOrderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cake Order System',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      home: ChefHomePage(),
    );
  }
}

class ChefHomePage extends StatefulWidget {
  @override
  _ChefHomePageState createState() => _ChefHomePageState();
}

class _ChefHomePageState extends State<ChefHomePage> {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sample order details
  final List<Map<String, String>> _orders = [
    {'Order ID': '001', 'Cake Type': 'Chocolate', 'Quantity': '1', 'Customer': 'Alice'},
    {'Order ID': '002', 'Cake Type': 'Vanilla', 'Quantity': '2', 'Customer': 'Bob'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  void _showOrderNotification(String orderDetails) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'order_channel',
      'Order Notifications',
      channelDescription: 'Channel for order notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(0, 'New Order', orderDetails, platformChannelSpecifics, payload: 'order_id_1');
  }

  void _acceptOrder(String orderId) {
    _showOrderNotification('Order $orderId has been accepted!');
    // Implement further logic for accepting the order
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
          SnackBar(content: Text('Error signing out. Please try again.')));
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

  void _showNotificationDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification icon pressed! Implement your logic here.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE1BEE7),
        title: Text('👨‍🍳 Chef Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: _showNotificationDialog,
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CProfileManagement()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout_sharp),
            onPressed: () => _showSignOutDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Pending Orders',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order ID: ${_orders[index]['Order ID']}', style: TextStyle(fontSize: 18)),
                          Text('Cake Type: ${_orders[index]['Cake Type']}', style: TextStyle(fontSize: 18)),
                          Text('Quantity: ${_orders[index]['Quantity']}', style: TextStyle(fontSize: 18)),
                          Text('Customer: ${_orders[index]['Customer']}', style: TextStyle(fontSize: 18)),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => _acceptOrder(_orders[index]['Order ID']!),
                            child: Text('Accept Order'),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white, // Set text color to white
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}