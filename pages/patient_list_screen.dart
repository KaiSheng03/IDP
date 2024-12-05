import 'package:flutter/material.dart';
import 'patient_profile_screen.dart';
import 'add_new_patient_screen.dart'; // Import Add Patient Screen
import '../models/patient.dart'; // Import Patient model

class PatientsListScreen extends StatefulWidget {
  @override
  _PatientsListScreenState createState() => _PatientsListScreenState();
}

class _PatientsListScreenState extends State<PatientsListScreen> {
  final List<Patient> _patients = [
    Patient(
        name: 'John Doe',
        id: 1,
        email: 'john.doe@example.com',
        phoneNumber: '123-456-7890'),
    Patient(
        name: 'Jane Smith',
        id: 2,
        email: 'jane.smith@example.com',
        phoneNumber: '987-654-3210'),
  ];

  String _searchQuery = '';

  void _addNewPatient(Map<String, dynamic> newPatient) {
    setState(() {
      _patients.add(
        Patient(
          name: newPatient['name'],
          id: newPatient['id'],
          phoneNumber: newPatient['phone'],
          email: newPatient['email'],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Patient> filteredPatients = _patients
        .where((patient) =>
            patient.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Patients Medical Records'),
      ),
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
                itemCount: filteredPatients.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredPatients[index].name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientProfileScreen(
                              patient: filteredPatients[index]),
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
