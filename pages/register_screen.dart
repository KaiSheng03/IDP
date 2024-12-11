import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // FUNCTION TO ADD USER
  Future<void> addUser() async {
    final response = await http.post(
      Uri.parse(
          'http://192.168.27.146:3000/addUser'), // Replace with your server address
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': usernameController.text,
        'password': passwordController.text,
        'email': emailController.text
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('User added: ${data['userId']}');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User added successfully')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add user')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the content
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align elements to the left
          children: [
            // First Name
            Text(
              'First Name:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your first name',
              ),
            ),
            SizedBox(height: 16),

            // Last Name
            Text(
              'Last Name:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your last name',
              ),
            ),
            SizedBox(height: 16),

            // Email
            Text(
              'Email:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your email',
              ),
            ),
            SizedBox(height: 16),

            // Username
            Text(
              'Username:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your username',
              ),
            ),
            SizedBox(height: 16),

            // Password
            Text(
              'Password:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your password',
              ),
            ),
            SizedBox(height: 24),

            // Register Button
            ElevatedButton(
              onPressed: () {
                // Navigate back to the previous screen (Login Page)
                addUser();
                // Handle register logic
                print('Register Button Pressed');
                // Navigator.pop(context);
              },
              child: Text('Register'),
            ),

            SizedBox(height: 16),

            // Back Button
            TextButton(
              onPressed: () {
                // Navigate back to the previous screen (Login Page)
                Navigator.pop(context);

                print('Back to Login Page Button Pressed');
              },
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
