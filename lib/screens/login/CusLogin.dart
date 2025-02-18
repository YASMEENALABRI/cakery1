import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cakery/screens/home/Search.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase.instance.ref();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        if (userCredential.user != null) {
          // Check if the user is a customer in the database
          final snapshot = await _database
              .child('users')
              .child(userCredential.user!.uid)
              .get();

          if (snapshot.exists) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SearchPage()),
            );
          } else {
            await _auth.signOut();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('This account is not registered as a customer')));
          }
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Login failed';

        if (e.code == 'user-not-found') {
          errorMessage = 'No account found with this email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Incorrect password.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Please provide a valid email address.';
        } else if (e.code == 'user-disabled') {
          errorMessage = 'This account has been disabled.';
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An error occurred during login')));
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
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
                      hintText: "Enter your email", enabled: !isLoading),
                ),
                if (isLoading)
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isLoading
                    ? null
                    : () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: isLoading
                    ? null
                    : () async {
                  String email = resetEmailController.text.trim();
                  if (email.isNotEmpty) {
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      await _auth.sendPasswordResetEmail(email: email);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Password reset email sent!')));
                    } on FirebaseAuthException catch (e) {
                      String errorMessage = 'Failed to send reset email';
                      if (e.code == 'user-not-found') {
                        errorMessage =
                        'No account found with this email.';
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage)));
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please enter your email')));
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

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool obscureText = false}) {
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          if (label == 'Email' && !value.contains('@')) {
            return 'Please enter a valid email';
          }
          return null;
        },
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
          title: Text(
            'Customer Login',
            style: TextStyle(color: Colors.black),
          ),
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
                              emailController, 'Email', Icons.email),
                          SizedBox(height: 12.0),
                          _buildTextField(
                              passwordController, 'Password', Icons.lock,
                              obscureText: true),
                          SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _isLoading
                                    ? null
                                    : _showForgotPasswordDialog,
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
                              backgroundColor: MaterialStateProperty.all(
                                  _isLoading ? Colors.grey : Colors.white),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      horizontal: 60, vertical: 10)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(27))),
                            ),
                            child: _isLoading
                                ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.grey[800]!),
                              ),
                            )
                                : Text(
                              "LOGIN",
                              style: TextStyle(
                                  fontSize: 23, color: Colors.grey[800]),
                            ),
                          ),
                          SizedBox(height: 22),
                          TextButton(
.om                            onPressed: _isLoading
                                ? null
                                : () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                                Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[500],
                                    fontSize: 18,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
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
