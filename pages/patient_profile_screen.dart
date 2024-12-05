import 'package:flutter/material.dart';
import '../models/patient.dart'; // Import Patient model

class PatientProfileScreen extends StatelessWidget {
  final Patient patient;

  const PatientProfileScreen({Key? key, required this.patient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${patient.name} Profile'),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Details for ${patient.name}',
          style: TextStyle(fontSize: 24),
        ),
        Text(
          'ID: ${patient.id}',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 10),
        Text(
          'Email: ${patient.email ?? "Not available"}',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 10),
        Text(
          'Phone Number: ${patient.phoneNumber ?? "Not available"}',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 20),
      ]),
    );
  }
}
