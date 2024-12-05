import 'package:flutter/material.dart';

class AddNewPatientScreen extends StatefulWidget {
  @override
  _AddNewPatientScreenState createState() => _AddNewPatientScreenState();
}

class _AddNewPatientScreenState extends State<AddNewPatientScreen> {
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _savePatient() {
    String name = _nameController.text;
    int? id = int.tryParse(_idController.text);
    String? phone =
        _phoneController.text.isNotEmpty ? _phoneController.text : null;
    String? email =
        _emailController.text.isNotEmpty ? _emailController.text : null;

    if (name.isNotEmpty && id != null) {
      // Return only the name to the previous screen
      Navigator.pop(context, {
        'name': name,
        'id': id,
        'email': email,
        'phone': phone,
      });
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
      ),
      body: Padding(
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
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
