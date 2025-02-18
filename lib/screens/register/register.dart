import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:cakery/screens/login/CusLogin.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase.instance.ref();

  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPwdController = TextEditingController();
  TextEditingController confPwdController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String address = '';

  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  bool validatePhoneNumber(String phone) {
    final regex = RegExp(r'^(9|7)\d{7}$');
    return regex.hasMatch(phone);
  }

  bool validatePassword(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return regex.hasMatch(password);
  }

  bool validateEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  void _showInstructions(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.9),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: userEmailController.text.trim(),
          password: userPwdController.text,
        );

        // Send email verification
        await userCredential.user?.sendEmailVerification();

        if (userCredential.user != null) {
          // Hash the password before storing
          String hashedPassword = hashPassword(userPwdController.text);

          await _database.child('users').child(userCredential.user!.uid).set({
            'name': userNameController.text,
            'email': userEmailController.text,
            'phoneNumber': phoneController.text,
            'address': address,
            'password': hashedPassword,  // Save the hashed password
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration successful! Please verify your email.')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Registration failed';

        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'An account already exists for that email.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Please provide a valid email address.';
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred during registration')),
        );
      }
    }
  }

  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon, {bool obscureText = false, TextInputType keyboardType = TextInputType.text, String? Function(String?)? validate, String? hintText}) {
    return GestureDetector(
      onTap: () {
        String message = '';
        switch (labelText) {
          case 'User Name':
            message = 'Please enter your full name.';
            break;
          case 'User Email':
            message = 'Please enter a valid email address (e.g., example@mail.com).';
            break;
          case 'Password':
            message = 'Password must include upper and lower case letters, a number, and a special character.';
            break;
          case 'Confirm Password':
            message = 'Please confirm your password by entering it again.';
            break;
          case 'Phone Number':
            message = 'Phone number must be exactly 8 digits and start with 9 or 7.';
            break;
        }
        _showInstructions(context, message);
      },
      child: Container(
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
          keyboardType: keyboardType,
          decoration: InputDecoration(
            icon: Icon(icon, color: Colors.black),
            labelText: labelText,
            hintText: hintText,
            border: InputBorder.none,
          ),
          validator: validate ?? (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your $labelText';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildAddressDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(66),
      ),
      width: 300,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Select Address',
          border: InputBorder.none,
        ),
        value: address.isNotEmpty && [
          'Muscat',
          'Rustaq',
          'Sohar',
          'Sur',
          'Nizwa',
          'Salalah',
          'Bahla',
          'Ibri'
        ].contains(address) ? address : null,
        onChanged: (String? newValue) => setState(() => address = newValue!),
        items: <String>[
          'Muscat',
          'Rustaq',
          'Sohar',
          'Sur',
          'Nizwa',
          'Salalah',
          'Bahla',
          'Ibri'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        validator: (val) => val == null ? 'Please select an address' : null,
      ),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: registerUser,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 60, vertical: 10)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(27))),
      ),
      child: Text("REGISTER", style: TextStyle(fontSize: 20, color: Colors.grey[800])),
    );
  }

  Widget _buildLoginButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()), // Navigate to CusLogin
        );
      },
      child: Text(
        'Already have an account? Login here',
        style: TextStyle(color: Colors.white, fontSize: 16), // Style for the link
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
            onPressed: () {
              Navigator.pop(context); // Navigate back
            },
          ),
          backgroundColor: Colors.white, // Set AppBar background to white
          title: Text(
            'Register User',
            style: TextStyle(color: Colors.black), // Set title color to black
          ),
          iconTheme: IconThemeData(color: Colors.black), // Set icon color
        ),
        backgroundColor: Color(0xFF69065D),
        body: SizedBox(
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
                      SizedBox(height: 20),
                      ClipOval(
                        child: Image.asset(
                          'assets/logo.png', // Adjust the path to your logo image
                          width: 100, // Adjust the width as needed
                          height: 100, // Adjust the height as needed
                        ),
                      ),
                      SizedBox(height: 20),
                      // User Name Field
                      _buildTextField(userNameController, 'User Name', Icons.person),
                      SizedBox(height: 12.0),
                      // User Email Field with Validation
                      _buildTextField(userEmailController, 'User Email', Icons.email, validate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!validateEmail(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      }),
                      SizedBox(height: 12.0),
                      // Password Field
                      _buildTextField(
                        userPwdController,
                        'Password',
                        Icons.lock,
                        obscureText: true,
                        hintText: 'At least 8 characters including upper, lower, number, & special',
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (!validatePassword(value)) {
                            return 'Enter a valid password'; // Updated validation message
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12.0),
                      // Confirm Password Field
                      _buildTextField(confPwdController, 'Confirm Password', Icons.lock, obscureText: true, validate: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != userPwdController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      }),
                      SizedBox(height: 12.0),
                      // Phone Number Field
                      _buildTextField(
                        phoneController,
                        'Phone Number',
                        Icons.phone,
                        keyboardType: TextInputType.number,
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          if (value.length != 8) {
                            return 'Must be exactly 8 digits long';
                          }
                          if (!value.startsWith('9') && !value.startsWith('7')) {
                            return 'Must start with 9 or 7';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12.0),
                      // Address Dropdown
                      _buildAddressDropdown(),
                      SizedBox(height: 35),
                      // Register Button
                      _buildRegisterButton(),
                      SizedBox(height: 20),
                      // Login Navigation
                      _buildLoginButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    userNameController.dispose();
    userEmailController.dispose();
    userPwdController.dispose();
    confPwdController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}