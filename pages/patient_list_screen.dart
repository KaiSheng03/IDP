import 'package:flutter/material.dart';
import 'patient_profile_screen.dart';
import 'add_new_patient_screen.dart'; // Import Add Patient Screen
import '../models/patient.dart'; // Import Patient model
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'state/user_provider.dart';

class PatientsListScreen extends StatefulWidget {
  const PatientsListScreen({super.key});

  @override
  _PatientsListScreenState createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends State<PatientsListScreen> {
  List<Patient> _patients = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    final userInfo = Provider.of<UserProvider>(context, listen: false).userInfo;
    if (userInfo != null) {
      final doctorId = userInfo['iduser'];

      final response = await http.get(
        Uri.parse('http://192.168.27.146:3000/get-patient?doctor_id=$doctorId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _patients = data.map((patientData) {
            // Use try-catch to handle invalid integer parsing
            int? age = _parseInt(patientData['age']);
            int? id = _parseInt(patientData['ic']);

            return Patient(
              name: patientData['name'],
              id: id ?? 0, // Use a fallback value if id is invalid
              age: age ?? 0, // Use a fallback value if age is invalid
              phoneNumber: patientData['phone_number'],
              email: patientData['email'],
            );
          }).toList();
        });
        print(data);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch patients')),
        );
      }
    }
  }

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    try {
      return int.parse(value.toString());
    } catch (e) {
      return null; // Return null if parsing fails
    }
  }

  void _addNewPatient(Map<String, dynamic> newPatient) {
    setState(() {
      _patients.add(
        Patient(
          name: newPatient['name'],
          id: newPatient['id'],
          age: newPatient['age'],
          phoneNumber: newPatient['phone'],
          email: newPatient['email'],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<Patient> filteredPatients = _patients
    //     .where((patient) =>
    //         patient.name.toLowerCase().contains(_searchQuery.toLowerCase()))
    //     .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Patients Medical Record'),
        backgroundColor: Colors.amber[200],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 254, 250),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add New Patient Button (Moved to the top)
            ElevatedButton.icon(
              onPressed: () async {
                final newPatient = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNewPatientScreen(),
                  ),
                );

                if (newPatient != null) {
                  _addNewPatient(newPatient);
                }
              },
              icon: Icon(Icons.add),
              label: Text('Add New Patient'),
            ),
            SizedBox(height: 16),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search patient...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            SizedBox(height: 16),

            // List of Patients
            Expanded(
              child: ListView.builder(
                itemCount: _patients.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_patients[index].name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PatientProfileScreen(patient: _patients[index]),
                        ),
                      );
                    },
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
