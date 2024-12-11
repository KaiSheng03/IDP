import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'state/user_provider.dart';

class AddNewPatientScreen extends StatefulWidget {
  const AddNewPatientScreen({super.key});

  @override
  _AddNewPatientScreenState createState() => _AddNewPatientScreenState();
}

class _AddNewPatientScreenState extends State<AddNewPatientScreen> {
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _savePatient() async {
    final userInfo = Provider.of<UserProvider>(context, listen: false).userInfo;
    String name = _nameController.text;
    int? id = int.tryParse(_idController.text);
    int? age = int.tryParse(_ageController.text);
    String? phone =
        _phoneController.text.isNotEmpty ? _phoneController.text : null;
    String? email =
        _emailController.text.isNotEmpty ? _emailController.text : null;

    if (name.isNotEmpty && id != null && age != null) {
      // Return only the name to the previous screen
      final response = await http.post(
        Uri.parse(
            'http://192.168.27.146:3000/add-patient'), // Replace with your backend URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'ic': id,
          'age': age,
          'phone': phone,
          'email': email,
          'doctor': userInfo?['iduser']
        }),
      );

      if (response.statusCode == 201) {
        // Assuming the backend returns success on status 201
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Patient added successfully')),
        );

        Navigator.pop(context, {
          'name': name,
          'id': id,
          'age': age,
          'email': email,
          'phone': phone,
        });
      } else {
        // Handle API error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add patient: ${response.body}')),
        );
      }
    } else {
      // Show an error if inputs are invalid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Patient'),
        backgroundColor: Colors.amber[200],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 254, 250),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name'),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter patient name',
              ),
            ),
            SizedBox(height: 16),
            Text('ID'),
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter patient ID',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Text('Age'),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter patient age',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Text('Phone Number'),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter patient phone number',
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            Text('Email'),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter patient email',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _savePatient,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[300], // Solid background color
                foregroundColor: Colors.black87, // Text color
              ),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
