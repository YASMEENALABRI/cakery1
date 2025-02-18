import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cakery/screens/home/Admin.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase.instance.ref();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        if (userCredential.user != null) {
          String email = emailController.text.trim();
          print('User Email: $email'); // Debug: print the email of the logged-in user

          // Query for admin by email
          final snapshot = await _database
              .child('admins')
              .orderByChild('email')
              .equalTo(email)
              .once();

          // Debugging: Print the snapshot data
          if (snapshot.snapshot.exists) {
            print('Admin snapshot data: ${snapshot.snapshot.value}');
            // Admin is valid, navigate to the admin dashboard
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminModulePage()),
            );
          } else {
            await _auth.signOut();
            _showSnackBar('This account is not registered as an admin');
          }
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = _getErrorMessage(e.code);
        _showSnackBar(errorMessage);
      } catch (e) {
        _showSnackBar('An error occurred during login');
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Please provide a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      default:
        return 'Login failed';
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showForgotPasswordDialog() {
    TextEditingController resetEmailController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text("Reset Password"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: resetEmailController,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    enabled: !isLoading,
                  ),
                ),
                if (isLoading) CircularProgressIndicator(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: isLoading ? null : () async {
                  String email = resetEmailController.text.trim();
                  if (email.isNotEmpty) {
                    setState(() => isLoading = true);
                    try {
                      await _auth.sendPasswordResetEmail(email: email);
                      Navigator.of(context).pop();
                      _showSnackBar('Password reset email sent!');
                    } on FirebaseAuthException catch (e) {
                      _showSnackBar(_getErrorMessage(e.code));
                    } finally {
                      setState(() => isLoading = false);
                    }
                  } else {
                    _showSnackBar('Please enter your email');
                  }
                },
                child: Text("Send"),
              ),
            ],
          );
        });
      },
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool obscureText = false, String? Function(String?)? validate}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(66),
      ),
      width: 300,
      height: 55,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        enabled: !_isLoading,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.black),
          labelText: label,
          border: InputBorder.none,
        ),
        validator: validate ?? (value) => null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.white,
          title: Text('Admin Login', style: TextStyle(color: Colors.black)),
        ),
        backgroundColor: Color(0xFF69065D),
        body: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 100),
                          ClipOval(
                            child: Image.asset(
                              'assets/logo.png',
                              width: 400,
                              height: 200,
                            ),
                          ),
                          SizedBox(height: 50),
                          _buildTextField(
                            emailController,
                            'Email',
                            Icons.email,
                            validate: _validateEmail,
                          ),
                          SizedBox(height: 12.0),
                          _buildTextField(
                            passwordController,
                            'Password',
                            Icons.lock,
                            obscureText: true,
                            validate: _validatePassword,
                          ),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _isLoading ? null : _showForgotPasswordDialog,
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 35),
                          ElevatedButton(
                            onPressed: _isLoading ? null : signIn,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(_isLoading ? Colors.grey : Colors.white),
                              padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 60, vertical: 10)),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
                            ),
                            child: _isLoading
                                ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[800]!)),
                            )
                                : Text("LOGIN", style: TextStyle(fontSize: 23, color: Colors.grey[800])),
                          ),
                          SizedBox(height: 22),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}