import 'package:flutter/material.dart';
import 'patient_profile_screen.dart';
import 'add_new_patient_screen.dart'; // Import Add Patient Screen
import '../models/patient.dart'; // Import Patient model
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'state/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class PatientSelectionScreen extends StatefulWidget {
  final String imagePath;
  final String prediction;
  const PatientSelectionScreen(
      {super.key, required this.imagePath, required this.prediction});

  @override
  _PatientSelectionScreenState createState() => _PatientSelectionScreenState();
}

class _PatientSelectionScreenState extends State<PatientSelectionScreen> {
  List<Patient> _patients = [];
  String _searchQuery = '';
  int? _selectedIndex; // To keep track of the selected patient index

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
    _fetchPatients();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
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
            int? age = _parseInt(patientData['age']);
            int? id = _parseInt(patientData['ic']);

            return Patient(
              name: patientData['name'],
              id: id ?? 0,
              age: age ?? 0,
              phoneNumber: patientData['phone_number'],
              email: patientData['email'],
            );
          }).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch patients')),
        );
      }
      // db = FirebaseFirestore.instance;
    }
  }

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    try {
      return int.parse(value.toString());
    } catch (e) {
      return null;
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

  Future<void> _storeImageToCloud() async {
    if (widget.imagePath.isEmpty || _selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image and a patient")),
      );
      return;
    }

    try {
      // Convert the imagePath to a File object
      final File imageFile = File(widget.imagePath);

      // Create a reference to the storage bucket
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('uploads/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload the file
      final uploadTask = storageRef.putFile(imageFile);

      // Wait for the upload to complete and get the download URL
      await uploadTask.whenComplete(() async {
        final downloadUrl = await storageRef.getDownloadURL();

        // Get selected patient details
        final Patient selectedPatient = _patients[_selectedIndex!];

        // Store image URL and prediction in Firestore
        await FirebaseFirestore.instance
            .collection('patients')
            .doc(selectedPatient.id.toString()) // Use patient ID as document ID
            .collection('records') // Nested collection for storing records
            .add({
          'image_url': downloadUrl,
          'prediction': widget.prediction,
          'timestamp': FieldValue.serverTimestamp(), // Store server timestamp
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Upload and save successful!")),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload image: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Patient> filteredPatients = _patients
        .where((patient) =>
            patient.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients Medical Record'),
        backgroundColor: Colors.amber[200],
      ),
      backgroundColor: const Color.fromARGB(255, 255, 254, 250),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final newPatient = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddNewPatientScreen(),
                  ),
                );

                if (newPatient != null) {
                  _addNewPatient(newPatient);
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add New Patient'),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
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
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredPatients.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => PatientProfileScreen(
                      //       patient: filteredPatients[index],
                      //     ),
                      //   ),
                      // );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? Colors.amber.shade200 : Colors.white,
                        border: Border.all(
                          color:
                              isSelected ? Colors.amber : Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        filteredPatients[index].name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (widget.imagePath.isNotEmpty && _selectedIndex != null)
              MaterialButton(
                color: Colors.amber[300],
                child: const Text(
                  "Store To Cloud",
                  style: TextStyle(color: Colors.black87),
                ),
                onPressed: _storeImageToCloud,
              ),
          ],
        ),
      ),
    );
  }
}
