import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.10:3000/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': usernameController.text,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(data['message'])));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Invalid login credentials")));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Unexpected error occurred")));
      }
    } catch (e) {
      print("Error: $e"); // Print to debug console
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Network error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center widgets vertically
          children: [
            // Image above the text
            Image.asset(
              'assets/skinalyze_logo.png', // Replace with your image path
              height: 150, // Adjust as needed
              width: 150, // Adjust as needed
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20), // Space between image and text

            // Welcome text
            Text(
              'Welcome to Skinalyze!',
              style: TextStyle(fontSize: 24), // Styling the text
            ),
            SizedBox(height: 20), // Space between text and buttons

            //Username Text Field
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'username', // Label for the text field
                border:
                    OutlineInputBorder(), // Adds border around the text field
              ),
            ),
            SizedBox(height: 20), // Space between text fields

            //Password Text Field
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'password', // Label for the text field
                border:
                    OutlineInputBorder(), // Adds border around the text field
              ),
            ),
            SizedBox(height: 20), // Space between text field and buttons

            // Login Button
            ElevatedButton(
              onPressed: () {
                // Action for the first button
                login();
                print('Log in button pressed!'); //text printed in debug console
              },
              child: Text('Log in'),
            ),
            SizedBox(height: 10), // Space between buttons

            // Register Button
            TextButton(
              onPressed: () {
                // Navigate to the second screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
                print('Register Button Pressed');
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Text color
                padding: EdgeInsets.all(16), // Padding inside the button
              ),
              child: Text('Don\'t have an account'),
            ),
          ],
        ),
      ),
    );
  }
}
